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
//        fetchData()
        
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
        
        
        ref.child("kamtest1/imdb").observeSingleEvent(of: .value) { (snapshot) in
        
//            let kamtestname = snapshot.value as? String
//            print("**** kamtestname searched = \(kamtestname)")
//            if kamtestname != nil {
//                self.alreadyExists()
//            } else {
//                self.addNewMovie()
//            }
            
            if let mymovieimdb = snapshot.value as? String {
                print("**** mymovieimdb searched = \(mymovieimdb)")
                self.alreadyExists()
            } else {
                self.addNewMovie()
            }
            
//            if snapshot.value(forKey: "name") == nil {
//                self.notFound()
//            }
            
//            if found {
//                movie already in db func
//            } else {
//                add movie func
//            }
            
            
            
        }
        
        movieComments = commentsText.text
        print("12391840750375 in saveMyMovieButtonPressed")
        print("movie name = \(movieTitle)  movie imdb = \(movieIMDB)")
        
        var foundFlag = false
        
        //.. after fetch (fetchData() below), which is now looking for the specific
        //..  movie via imdb number, check to see if movie is already out there in db or not
        
//        for item in listArray {
//            if item.value(forKey: "imdb") as! String == movieIMDB {
//                //.. it's already in db so do nothing but alert and set foundFlag
//                foundFlag = true
//
//                let alert2 = UIAlertController(title: "Message", message: "Movie Already Exists in My Movies", preferredStyle: .alert)
//                //.. from https://stackoverflow.com/questions/27895886/uialertcontroller-change-font-color
//                //.. make text in alert message red
//                //alert2.view.tintColor = UIColor.red
//                //.. tints whole box red
//                alert2.view.backgroundColor = UIColor.red
//                //.. to set the "message" in red and "title" in blue
//                alert2.setValue(NSAttributedString(string: alert2.message ?? "nope", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.red]), forKey: "attributedMessage")
//                //.. to set the "title" in blue
//                alert2.setValue(NSAttributedString(string: alert2.title ?? "nada", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.medium), NSAttributedString.Key.foregroundColor : UIColor.blue]), forKey: "attributedTitle")
//
//                //.. style: .destructive = red "OK" button; .default = black
//                let okAction2 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
//                    //Just dismiss the action sheet
//                })
//                alert2.addAction(okAction2)
//                self.present(alert2, animated: true, completion: nil )
//                print("!@*$&*%*#^%#^ movie already in db - \(movieTitle)")
//            }  //.. end if
//        } //.. end for
//
//        if !foundFlag {
//            //.. movie not already found in db, so insert/save it
//            print("!@*$&*%*#^%#^ trying to insert movie in db - \(movieTitle)")
//            //.. insert it into db
//            //.. for "Item" table in xcdatamodeld
//            let newEntity = NSEntityDescription.insertNewObject(forEntityName:"MyMovieTable", into: dataManager)
//            //.. for "about" attribute/field in table "Item" in xcdatamodeld
//            newEntity.setValue(movieTitle, forKey: "name")
//            newEntity.setValue(movieYear, forKey: "year")
//            newEntity.setValue(movieType, forKey: "type")
//            newEntity.setValue(movieIMDB, forKey: "imdb")
//            newEntity.setValue(moviePoster, forKey: "poster")
//            newEntity.setValue(movieComments, forKey: "comments")
//
//            do{
//                //.. try to save in db
//                try self.dataManager.save()
//                //.. add new entity to array
//                //listArray.append(newEntity)
//
//                //.. if it saved, show an alert
//                let alert3 = UIAlertController(title: "Message", message: "Movie Saved to My Movies :)", preferredStyle: .alert)
//                let okAction3 = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
//                    //Just dismiss the action sheet
//                })
//                alert3.addAction(okAction3)
//                self.present(alert3, animated: true, completion: nil )
//            } catch{
//                print ("Error saving data")
//                print("$$$ MovieDetailVC ..tried to save coreData but it didn't work")
//            }
//
//            print("$$$$$$ newEntity = \(newEntity)")
//            //fetchData()
//
//            foundFlag = false
//
//        }  //.. end if
//
//
//
//    } //.. end saveMyButtonPressed
//
//    //.. read from db - FOR A PARTICULAR MOVIE ROW THAT'S BEING SEARCH FOR TO SEE
//    //..   IF IT'S ALREADY IN THE DB
//    func fetchData() {
//
//        //.. from https://stackoverflow.com/questions/45675149/how-to-fetch-only-one-column-data-in-core-data-using-swift-3
//        //        let fetchRequest = NSFetchRequest<NSDictionary>(entityName: TesCalculation.entity().name!)
//        //        fetchRequest.resultType = .dictionaryResultType
//        //        fetchRequest.predicate = NSPredicate(format: "testID == %@ ",testID)
//
//        //.. fetching for particular row - use PREDICATE
//        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyMovieTable")
//        fetchRequest.predicate = NSPredicate(format: "imdb == %@ ",movieIMDB)
//
//        //.. setup fetch from "Item" in xcdatamodeld -> below = "old" way and it works
////        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyMovieTable")
//
//        do {
//            //.. try to fetch data
//            let result = try dataManager.fetch(fetchRequest)
//            //.. set the array equal to the results fetched
//            listArray = result as! [NSManagedObject]
//            print("listArray = \(listArray)")
//
//            if listArray.isEmpty {
//                print("listArray is empty...ie movie \(movieTitle) not found")
//            }
//            //.. for each item in the array, do the following..
//            for item in listArray {
//                //.. get the value for "name, year, type, imdb, poster, comments" (attribute/field "name", etc. in xcdatamodeld) and set it equal to var product
//                //var product = item.value(forKey: "about") as! String
//                let myMovieNameRetrieved = item.value(forKey: "name") as! String
//                print("====> myMovieNameRetrieved in listArray/CoreData: \(myMovieNameRetrieved)")
//            }
//
//            } catch {
//                print ("Error retrieving data")
//            }
//
//        }
////
////    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
////         let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
////         return newText.count < 10
////    }
//
//
}
    func alreadyExists() {
        let alert2 = UIAlertController(title: "Message", message: "Movie Already Exists in My Movies", preferredStyle: .alert)
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
            ref.child("kamtest1").setValue(["imdb":"5555","type":"movie","year":"2021","comments":"none","poster":"poster addr"])
            //.. add new entity to array
            //listArray.append(newEntity)

            //.. if it saved, show an alert
            let alert3 = UIAlertController(title: "Message", message: "Movie Saved to My Movies :)", preferredStyle: .alert)
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
        
    
}
