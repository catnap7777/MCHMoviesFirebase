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
//import CoreData

//.. For displaying the list of my movies that I have saved..
class MyMovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var myMoviesTableViewObj: UITableView!
    
//    var dataManager : NSManagedObjectContext!
//    //.. array to hold the database info for loading/saving
//    var listArray = [NSManagedObject]()
    
    
    let ref = Database.database().reference()
    
    var listArray: [(name: String, year: String, type: String, imdb: String, poster: String, comments: String)] = [("","","","","","")]
    
//    var listArray2: [String] = ["karen","tom","erik"]
//    var listArray = [(name: "karen", year: "2021", type: "movie", comments: "yup", poster: "poster", imdb: "imdb")]
    
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
        
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        dataManager = appDelegate.persistentContainer.viewContext
        
//        listArray.append((name: "elsa", year: "2020", type: "game", comments: "nope", poster: "poster2", imdb: "imdb2"))
        
        listArray = fetchData()
        print("listArray count = \(listArray.count)")
        
        
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
        
//        cell.myMovieName?.text = (mmRow.value(forKey: "name") as! String)
//        cell.myMovieYear?.text = (mmRow.value(forKey: "year") as! String)
//        cell.myMovieType?.text = (mmRow.value(forKey: "type") as! String)
//        cell.myMovieComments?.text = (mmRow.value(forKey: "comments") as! String)
        
//        print("****************** myMovieComments = \(mmRow.value(forKey: "comments") as! String)")
        print("****************** myMovieComments = \(mmRow.comments)")
        
//        let url = mmRow.value(forKey: "poster") as! String
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
        
//        let movieNameSelected = mmRowSelected.value(forKey: "name") as! String
//        let movieCommentsSelected = mmRowSelected.value(forKey: "comments") as! String
//        let movieIMDBSelect = mmRowSelected.value(forKey: "imdb") as! String
        
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
        
        let savedText2: NSString = savedText as NSString

        //.. try to update the listArray and then save it
//        self.listArray[indexPath.row].setValue(savedText2, forKey: "comments")
        
        //.. next line does the same thing as above
        //mmRowSelected.setValue(savedText2, forKey: "comments")
        
        //.. Now save the "new row" with the new comments --- it would be better to just update it
//        do{
//            //.. try to save in db
//            try self.dataManager.save()
//            //self.fetchData()
//            self.myMoviesTableViewObj.reloadData()
//        } catch{
//            print ("Error saving updated data")
//            print("$$$ MovieDetailVC ..tried to save coreData but it didn't work")
//        }
                
//        print("$$$$$$ updatedRow name = \(String(describing: self.listArray[indexPath.row].value(forKey: "name")))")
//        print("$$$$$$ updatedRow imdb = \(String(describing: self.listArray[indexPath.row].value(forKey: "imdb")))")
//        print("$$$$$$ updatedRow comments = \(String(describing: self.listArray[indexPath.row].value(forKey: "comments")))")
        
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
         
            let movieToRemove = self.listArray[indexPath.row]
            
//            self.dataManager.delete(movieToRemove)
            
//            do {
//                try self.dataManager.save()
//            } catch {
//                print("...was not able to swipe/delete row - \(movieToRemove)")
//            }
            
            self.fetchData()
            self.myMoviesTableViewObj.reloadData()
           
        }
        
        return UISwipeActionsConfiguration(actions: [action])
        
    }
    
    //.. read from db - get all data
    func fetchData() -> [(name: String, year: String, type: String, imdb: String, poster: String, comments: String)] {
        
        listArray.removeAll()
        
        let rootref = Database.database().reference()
        rootref.observeSingleEvent(of: .value) { (snapshot) in
            
            let kam = snapshot.value as! [String: AnyObject]
            
            let count = kam.count
            print("****** count of movies is = \(count)")
           
            for (k,v) in kam {
                
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
            
            print("2nd listArray count = \(self.listArray.count)")
            self.myMoviesTableViewObj.reloadData()
            //return listArray
            
        }
        print("3rd listArray count = \(self.listArray.count)")
        return listArray
      
    }



}
