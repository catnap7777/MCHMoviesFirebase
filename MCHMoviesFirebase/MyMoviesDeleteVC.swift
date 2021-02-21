//
//  MyMoviesDeleteVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

//.. For deleting movies from my movies that are saved in the PLIST
class MyMovieDeleteVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var myMoviePicker: UIPickerView!
    @IBOutlet var deleteMyMovieButtonObj: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet var pickerPickedLabel: UILabel!
    
    var listArray: [(name: String, year: String, type: String, imdb: String, poster: String, comments: String)] = [("","","","","","")]
    
    var myMovieChosen: String = ""
    var myMovieIMDBChosen: String = ""
    var myMovieTypeChosen: String = ""
    var myMovieYearChosen: String = ""
    var myMoviePosterChosen: String = ""
    var myMovieCommentsChosen: String = ""
    
    var pickerTypeIndex = 0
    var pickerLabel = UILabel()
    
    let ref = Database.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myMoviePicker.dataSource = self
        myMoviePicker.delegate = self
    
        //.. for picker itself
//        self.pickerLabel.text = (self.listArray[0].value(forKey: "name") as! String)
//
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        listArray.removeAll()
        fetchData()
        
        self.myMoviePicker.reloadAllComponents()
        self.myView.reloadInputViews()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return listArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        pickerLabel = UILabel()
    
        //.. for line items on the actual picker
        pickerLabel.text = (self.listArray[row].year) + "/" + (self.listArray[row].type) + " - " + (self.listArray[row].name)
        
        print("pickerlabel \(String(describing: pickerLabel.text)) - \(self.listArray[row].name)")
        
        //.. for the label that shows the full description of what the picker
        //..    is currently positioned on
        pickerPickedLabel.text = (self.listArray[row].year + "/" + self.listArray[row].type + " - " + self.listArray[row].name)

        if UIDevice.current.userInterfaceIdiom == .pad {
            pickerLabel.font = UIFont.systemFont(ofSize: 14)
            //pickerLabel.text = "Row \(row)"  //.. not needed bc set above
        } else if UIDevice.current.userInterfaceIdiom == .phone {
            pickerLabel.font = UIFont.systemFont(ofSize: 14)
//            pickerLabel.font = UIFont.systemFont(ofSize: 14)
            //pickerLabel.text = "Row \(row)"  //.. not needed bc set above
        }
        
        return pickerLabel
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        pickerTypeIndex = myMoviePicker.selectedRow(inComponent: 0)
        
        if !listArray.isEmpty {
            
            pickerPickedLabel.text = (self.listArray[row].year + "/" + self.listArray[row].type + " - " + self.listArray[row].name)
        }
        
    }

    @IBAction func deleteMyMoviePressed(_ sender: Any) {
        
        print("@@@@@@@@@ pickerTypeIndex BEFORE delete = \(pickerTypeIndex)")
 
        if !listArray.isEmpty {
            
            self.myMovieChosen = self.listArray[self.pickerTypeIndex].name
            self.myMovieYearChosen = self.listArray[self.pickerTypeIndex].year
            self.myMovieTypeChosen = self.listArray[self.pickerTypeIndex].type
            self.myMovieIMDBChosen = self.listArray[self.pickerTypeIndex].imdb
            self.myMovieCommentsChosen = self.listArray[self.pickerTypeIndex].comments
            
            let msg = "Are you sure you want to delete... \n\n- Movie: \(myMovieChosen) \n\n- Year: \(myMovieYearChosen) \n- Type: \(myMovieTypeChosen) \n- Imdb: \(myMovieIMDBChosen) \n- Comments: \(myMovieCommentsChosen)\n???"
            
            let alert = UIAlertController(title: "Confirm", message: msg, preferredStyle: .alert)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { action -> Void in
                //Just dismiss the action sheet
            })
            
            let okAction = UIAlertAction(title: "Delete", style: .default, handler: { action -> Void in
                
                print("movie to delete = \(self.myMovieChosen)  \(self.myMovieIMDBChosen)  \(self.myMovieCommentsChosen)")
                
                //.. set the String of what you want to delete
                let deleteName = self.myMovieChosen
                let deleteComments = self.myMovieCommentsChosen
                let deleteImdb: NSString = self.myMovieIMDBChosen as NSString
                
                print("111122223333 === movie to delete = \(deleteName) ::: comments = \(deleteComments) ::: Imdb = \(deleteImdb)")
                
                self.ref.child(self.myMovieIMDBChosen).removeValue()
           
                self.listArray.removeAll()
                self.fetchData()
//                print("******* listArray after save and after re-fetch of data ==== \(self.listArray)")
                
                //.. reset pickerTypeIndex here because picker is redrawn after delete
                //..   and should be at 0 entry
                self.pickerTypeIndex = 0
                print("@@@@@@@@@ pickerTypeIndex AFTER delete = \(self.pickerTypeIndex)")
                
                self.pickerPickedLabel.text = ""
                self.myMoviePicker.reloadAllComponents()
                self.myView.reloadInputViews()
                
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self .present(alert, animated: true, completion: nil )
            
        }
        
    }
    
    //.. read from db - get all rows
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
               
            }
            
            //.. Sort the my movies...
                        //.. 'sorted' creates a new array, 'sort' sorts the array in place
                        //.. if the movie names aren't equal, sort on the names asc... if they are equal, sort on the year desc
                        //.. Note: used listArray.sorted previously. Now using ListArraty.sort
            //            let movieArrayTupSorted = self.listArray.sorted { $0.0 != $1.0 ? $0.0 < $1.0 : $0.1 > $1.1 }
                        
            self.listArray.sort { $0.0 != $1.0 ? $0.0 < $1.0 : $0.1 > $1.1 }
            
            print("counter = \(counter)")
            
            print("listArray count = \(self.listArray.count)")
            //self.myMoviesTableViewObj.reloadData()
            self.myMoviePicker.reloadAllComponents()
            
        }
    }


}
