//
//  MyMoviesListVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//


import UIKit
import Foundation
import FirebaseDatabase

//.. For displaying the list of my movies that I have saved..
class MyMovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var myMoviesTableViewObj: UITableView!
    
    let ref = Database.database().reference()
    
    var listArray: [(name: String, year: String, type: String, imdb: String, poster: String, comments: String)] = [("","","","","","")]
    
    let defaultImageArray = ["posternf.jpg","pearl.jpg","gitcat.jpg"]
   
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //..tableView.rowHeight = 40
        myMoviesTableViewObj.rowHeight = 200
        //myMoviesTableViewObj.separatorColor = UIColor.blue

        // Do any additional setup after loading the view.
       
        myMoviesTableViewObj.dataSource = self
        myMoviesTableViewObj.delegate = self
       
        //..  fetchData() does NOT work here with Tab Bar Controller;
        //..    put in viewWillAppear instead
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
        self.myMoviesTableViewObj.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return mymovies.count
        return listArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: MyMoviesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell2") as! MyMoviesTableViewCell
            
            if (cell == nil ) {
                //cell = UITableViewCell(style: UITableViewCell.CellStyle.default,
                cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: cellID) as! MyMoviesTableViewCell
                }

        let mmRow = listArray[indexPath.row]
        
        cell.myMovieName?.text = (mmRow.name)
        cell.myMovieYear?.text = (mmRow.year)
        cell.myMovieType?.text = (mmRow.type)
        cell.myMovieComments?.text = (mmRow.comments)
  
        print("****************** myMovieComments = \(mmRow.comments)")
        
        let url = mmRow.poster
        var myImage = UIImage(named: defaultImageArray[0])
        
        if url == "" {
            myImage = UIImage(named: defaultImageArray[0])
        } else {
            let imageURL = URL(string: url)
            if let imageData = try? Data(contentsOf: imageURL!) {
               
                myImage = UIImage(data: imageData)
                //print(myImage)
                DispatchQueue.main.async {
                    return myImage
                }
            } else {
                //myImage = UIImage(named: defaultImageArray[0])
                myImage = UIImage(named: "posternotfound.JPG")
            }
        }
     
        //.. this is referenced in TableViewCell.swift; if you just use cell.imageView?.image (commented out line below), the pictures just "default" to whatever size they come in as
        cell.myMovieImage.image = myImage
        //cell.imageView?.image = myImage
       
        return cell

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You tapped cell number \(indexPath.row).")
        
        let mmRowSelected = listArray[indexPath.row]
  
        let movieNameSelected = mmRowSelected.name
        let movieCommentsSelected = mmRowSelected.comments
        let movieIMDBSelect = mmRowSelected.imdb
        
        let alert = UIAlertController(title: "Your Choice", message: "\(movieNameSelected)", preferredStyle: .alert)

        //.. Placeholder text only shows up if there were no previous comments stored in CoreData for this row
        alert.addTextField(configurationHandler: {(textField) in textField.placeholder = "Enter new comments here..."
            //textField.isSecureTextEntry = true
        })
        
        //.. Next two lines file the alert text box with the comments that were previously stored in CoreData - user can therefore update or add more comments
        let textfield = alert.textFields![0]
        textfield.text = movieCommentsSelected

        //.. defines Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
                //Just dismiss the action sheet
        })
    
       //.. defines OK button
       let okAction = UIAlertAction(title: "OK", style: .default, handler: { action -> Void in
               //.. called savedText, which represents the first text field (note the index value of 0) on the alert controller. If you add more than one text field to an alert controller, you’ll need to define additional constants to represent those other text fields

        let savedText: String = alert.textFields![0].text ?? "nice try karen"
        print("savedText = \(savedText)")
        let savedText2: NSString = savedText as NSString
        print("savedText2 = \(savedText2)")
        
        //.. try to update the listArray and then save it
        self.listArray[indexPath.row].comments = savedText
        print("listArray comments = \(self.listArray[indexPath.row].comments)")
        
        //.. Now save the new comments
        self.ref.child("\(movieIMDBSelect)/comments").setValue("\(savedText)")
        self.myMoviesTableViewObj.reloadData()
        
        print("$$$$$$ updatedRow name = \(String(describing: self.listArray[indexPath.row].name)))")
        print("$$$$$$ updatedRow imdb = \(String(describing: self.listArray[indexPath.row].imdb)))")
        print("$$$$$$ updatedRow comments = \(String(describing: self.listArray[indexPath.row].comments)))")
        
       })

       //..adds the button to the alert controller and next line presents or displays the alert controller
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true , completion: nil)
        
    }
    
    //.. to swipe delete a tableView row
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "delete") { (action, view, completionHandler) in
         
            let imdbMovieToRemove = self.listArray[indexPath.row].imdb
            self.ref.child(imdbMovieToRemove).removeValue()
            self.fetchData()
            self.myMoviesTableViewObj.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    //.. read from db - get all data
    func fetchData() {
        
        listArray.removeAll()
        
        let rootref = Database.database().reference()
        rootref.observeSingleEvent(of: .value) { (snapshot) in
            
            let myMovies = snapshot.value as! [String: AnyObject]
            
            let count = myMovies.count
            var counter = 0
            print("****** count of movies is = \(count)")
           
            for (k,v) in myMovies {
                
                counter += 1
                print(".............................................")
                let ximdb = k
                print("ximdb = \(k)")
                
                let xname = v["name"] as! String
                print("xname = \(xname)")
                let xyear = v["year"] as! String
                print("xyear = \(xyear)")
                let xtype = v["type"] as! String
                print("xtype = \(xtype)")
                let xcomments = v["comments"] as! String
                print("xcomments = \(xcomments)")
                let xposter = v["poster"] as! String
                print("xposter = \(xposter)")
                
                self.listArray.append((name: xname, year: xyear, type: xtype, imdb: ximdb, poster: xposter, comments: xcomments))
                
//                for child in snapshot.children {
//                    let childSnapshot = child as! DataSnapshot
//                    print("childSnapshot = \(childSnapshot)")
//                    let xname = childSnapshot.childSnapshot(forPath: "name")
//                    print("name from childSnapshot = \(xname)")
//                    let xtype = childSnapshot.childSnapshot(forPath: "type")
//                    let xyear = childSnapshot.childSnapshot(forPath: "year")
//                    let xcomments = childSnapshot.childSnapshot(forPath: "comments")
//                    let xposter = childSnapshot.childSnapshot(forPath: "poster")
//                    let name: String = xname
//
//                    listArray.append((name: xname, year: xyear, type: xtype, imdb: ximdb, poster: xposter, comments: xcomments))
 //                }
               
            }
            
            //.. Sort the my movies...
            //.. 'sorted' creates a new array, 'sort' sorts the array in place
            //.. if the movie names aren't equal, sort on the names asc... if they are equal, sort on the year desc
            //.. Note: used listArray.sorted previously. Now using ListArraty.sort
//            let movieArrayTupSorted = self.listArray.sorted { $0.0 != $1.0 ? $0.0 < $1.0 : $0.1 > $1.1 }
            
            self.listArray.sort { $0.0 != $1.0 ? $0.0 < $1.0 : $0.1 > $1.1 }
            
            print("counter = \(counter)")
            
            print("listArray count = \(self.listArray.count)")
            self.myMoviesTableViewObj.reloadData()
            
        }
        
    }



}
