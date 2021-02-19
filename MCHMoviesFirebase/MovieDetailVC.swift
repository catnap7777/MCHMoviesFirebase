//
//  MovieDetailVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//
import UIKit
import Foundation
import FirebaseDatabase
//import CoreData

//.. Detail movie info for one of the movies that was "selected" (clicked on)
//..   in the tableView of the movies that came back from the API search
class MovieDetailVC: UIViewController {

    @IBOutlet var movieTitleLabel: UILabel!
    @IBOutlet var yearLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var imdbLabel: UILabel!
    @IBOutlet var detailImage: UIImageView!
    @IBOutlet var commentsText: UITextView!
    
//    var dataManager : NSManagedObjectContext!
//    //.. array to hold the database info for loading/saving
//    var listArray = [NSManagedObject]()
    
    let ref = Database.database().reference()
    
    //.. from json search
//    var movieArrayTup: [(xName: String, xYear: String, xType: String, xIMDB: String, xPoster: String)] = [("","","","","")]
    var listArray: [(xName: String, xYear: String, xType: String, xIMDB: String, xPoster: String)] = [("","","","","")]
    
    var movieTitle = ""
    var movieYear = ""
    var movieType = ""
    var movieIMDB = ""
    var moviePoster = ""
    var movieComments = ""
    
    let defaultImageArray = ["posternf.png"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        dataManager = appDelegate.persistentContainer.viewContext
        
        //        The first line defines the view as an observer to receive the keyboardWillShowNotification. When this notification appears, then the app needs to run a function called keyboardWillShow. The second line defines the view as an observer to receive the keyboardWillHideNotification. When this notification appears, then the app needs to run a function called keyboardWillHide.
                    
            NotificationCenter.default.addObserver( self , selector: #selector (keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil )
            
            NotificationCenter.default.addObserver( self , selector: #selector (keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil )
                    
            //        This code allows the view to detect tap gestures (when the user taps outside of a text field). When this occurs, this line runs a function called dismissKeyboard .
                    
            let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self , action: #selector (self.dismissKeyboard))
            view.addGestureRecognizer(tap)
        
        print("Documents Directory: ", FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last ?? "Not Found!")
        
        movieTitleLabel.text = movieTitle
        yearLabel.text = movieYear
        typeLabel.text = movieType
        imdbLabel.text = movieIMDB
        //posterLabel.text = moviePoster
                
        //        let url = URL(string: "https://static.independent.co.uk/s3fs-public/thumbnails/image/2017/09/12/11/naturo-monkey-selfie.jpg?w968h681")
        
        //.. value of which was already set from MovieListVC when row was clicked on and segue performed
        //.. NOTE: If the movie is older, it may not have a movie poster.
        //..  If it doesn't, the url will be blank or N/A
        //..  In that case, set the self.detailImage.image = posternotfound.jpg
        let url = moviePoster
        //self.detailImage.image = UIImage(named: defaultImageArray[0])
        self.detailImage.image = UIImage(named: "posternotfound.JPG")
        //.. takes the movie url from moviePoster and call func setImage to place picture on screen
        self.setImage(from: url)
        //  self.imgView.downloadImage(from: url!)
                
    }
    
    //    This function runs when the user taps outside of a text field, which ends editing and sends the notification that the virtual keyboard needs to go away (keyboardWillHideNotification).
       
        @objc func dismissKeyboard() {
            view.endEditing( true )
        }
        
    //    This function defines the keyboard size based on the size of the iOS screen. (Remember, iPhone screens are narrower than iPad screens.) Then this function uses the height of the virtual keyboard to determine how far to slide the view (along with all its user interface objects) up to make room for the virtual keyboard.

        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
               }
            }
        }
        
    //    This function checks if the virtual keyboard is visible. If not, then do nothing. If the virtual keyboard is visible, then move the view back down to cover and hide the virtual keyboard

        @objc func keyboardWillHide(notification: NSNotification) {
            if ((notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue) != nil {
                if self.view.frame.origin.y != 0 {
                    self.view.frame.origin.y = 0
                }
            }
        }
    
    func setImage(from url: String) {
        guard let imageURL = URL(string: url) else { return }
        
        // just not to cause a deadlock in UI!
        DispatchQueue.global().async {
            guard let imageData = try? Data(contentsOf: imageURL) else {
                return }
            
            let image = UIImage(data: imageData)
            DispatchQueue.main.async {
                self.detailImage.image = image
            }
        }
    }
    
    @IBAction func IMDBButton(_ sender: Any) {
        
        let imdbURL = "https://www.imdb.com/title/" + movieIMDB
        
        if let url = URL(string: imdbURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @IBAction func saveMyMovieButtonPressed(_ sender: Any) {
        
        listArray.removeAll()

        //..........................................................................
        //.. firebase database structure for this example is..
        //  - someid (or at this level can be randomly auto-generated key - see below)
        //      |_ age:39
        //      |_ name: Tori
        //      |_ role: Admin
        //
        //     //.. to read one key/value pair
        //        ref.child("someid/name").observeSingleEvent(of: .value)
        //        { (snapshot) in
        //            let name = snapshot.value as? String
        //            print("*** name = \(name)")
        //        }
        //
        //        //.. to read multiple key/value pairs - use dictionary to hold data
        //        ref.child("someid").observeSingleEvent(of: .value)
        //        { (snapshot) in
        //            let data = snapshot.value as? [String: Any]
        //            print("*** data = \(data)")
        //        }
        
        //.. this should work because IMDB number is unique
        //ref.child("kamtest1/imdb").observeSingleEvent(of: .value) { (snapshot) in
        ref.child("\(movieIMDB)/comments").observeSingleEvent(of: .value) { (snapshot) in
            
            //.. since searching for a particular imdb number/comments, I can pull back
            //..   comments from fb to see if they changed from what user typed on
            //..   the screen.  If comments are not equal, I proceed with addNewMovie()
            //..   eventhough it's really an update
            if let sComments = snapshot.value as? String {
                
                let kamComments = self.commentsText.text
                
                print("**** sComments | kamComments to comapare = \(sComments) | \(kamComments)")

                if sComments == kamComments {
                    self.alreadyExists()
                } else {
                    self.addNewMovie()
                }
            } else {
                self.addNewMovie()
            }
 
            
        }
        
        movieComments = commentsText.text
        print("12391840750375 in saveMyMovieButtonPressed")
        print("movie name = \(movieTitle)  movie imdb = \(movieIMDB)")
  
    }
      

    func alreadyExists() {
        let alert2 = UIAlertController(title: "Message", message: "Movie Already Exists in My Movies or No Change to 'My Comments'", preferredStyle: .alert)
        //.. from https://stackoverflow.com/questions/27895886/uialertcontroller-change-font-color
        //.. make text in alert message red
        //alert2.view.tintColor = UIColor.red
        //.. tints whole box red
        alert2.view.backgroundColor = UIColor.red
        //.. to set the "message" in red and "title" in blue
        alert2.setValue(NSAttributedString(string: alert2.message ?? "nope", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedMessage")
        //.. to set the "title" in blue
        alert2.setValue(NSAttributedString(string: alert2.title ?? "nada", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.blue]), forKey: "attributedTitle")

        //.. style: .destructive = red "OK" button; .default = black
        let okAction2 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
            //Just dismiss the action sheet
        })
        alert2.addAction(okAction2)
        self.present(alert2, animated: true, completion: nil )
        print("!@*$&*%*#^%#^ movie already in db - \(movieTitle)")
    }

    func addNewMovie() {
        
        do{
            //.. try to save in db
            ref.child("\(movieIMDB)").setValue(["name":"\(movieTitle)","type":"\(movieType)","year":"\(movieYear)","comments":"\(movieComments)","poster":"\(moviePoster)"])
            //.. add new entity to array
            //listArray.append(newEntity)

            //.. if it saved, show an alert
            let alert3 = UIAlertController(title: "Message", message: "Movie Saved/Updated to My Movies :)", preferredStyle: .alert)
            let okAction3 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
                //Just dismiss the action sheet
            })
            alert3.addAction(okAction3)
            self.present(alert3, animated: true, completion: nil )
        } catch{
            print ("Error saving data")
            print("$$$ MovieDetailVC ..tried to save coreData but it didn't work")
        }
    }
        
    //
    //    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //         let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
    //         return newText.count < 10
    //    }
    
    
}
