//
//  MyMoviesDeleteVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//

import UIKit
import Foundation
import CoreData

//.. For deleting movies from my movies that are saved in the PLIST
class MyMovieDeleteVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var myMoviePicker: UIPickerView!
    @IBOutlet var deleteMyMovieButtonObj: UIButton!
    @IBOutlet var myView: UIView!
    @IBOutlet var pickerPickedLabel: UILabel!
    
    var dataManager : NSManagedObjectContext!
    //.. array to hold the database info for loading/saving
    var listArray = [NSManagedObject]()
    
    var myMovieChosen: String = ""
    var myMovieIMDBChosen: String = ""
    var myMovieTypeChosen: String = ""
    var myMovieYearChosen: String = ""
    var myMoviePosterChosen: String = ""
    var myMovieCommentsChosen: String = ""
    
    var pickerTypeIndex = 0
    var pickerLabel = UILabel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        myMoviePicker.dataSource = self
        myMoviePicker.delegate = self
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        dataManager = appDelegate.persistentContainer.viewContext
        
        listArray.removeAll()
        fetchData()
       
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
    
        //.. in the picker itself
        pickerLabel.text = (self.listArray[row].value(forKey: "year") as! String) + "/" + (self.listArray[row].value(forKey: "type") as! String) + " - " + (self.listArray[row].value(forKey: "name") as! String)
        
        //pickerLabel.text = mymovies[row].name
       
        print("pickerlabel \(String(describing: pickerLabel.text)) - \((self.listArray[row].value(forKey: "name") as? String) ?? "again - what is happening")")

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
            //.. info that goes in the label for the row that's picked
            pickerPickedLabel.text = (self.listArray[row].value(forKey: "year") as! String) + "/" + (self.listArray[row].value(forKey: "type") as! String) + " - " + (self.listArray[row].value(forKey: "name") as! String)
        }
        
    }

    @IBAction func deleteMyMoviePressed(_ sender: Any) {
        
        //********* THIS NEEDS TO BE HERE TO GET CORRECT ALERT MSG
        //.. LEAVE the print statements for debugging
        //.. set the values for the picker row chosen so they can be displayed in the alert
        print("@@@@@@@@@ pickerTypeIndex BEFORE = \(pickerTypeIndex)")
        //** MUST reset pickerTypeIndex or you'll get an error when deleting 2nd to last row and then...
        //    trying to delete the last row -> index out of bounds
        pickerTypeIndex = myMoviePicker.selectedRow(inComponent: 0)
        print("@@@@@@@@@ pickerTypeIndex AFTER = \(pickerTypeIndex)")
 
        if !listArray.isEmpty {
            self.myMovieChosen = self.listArray[self.pickerTypeIndex].value(forKey: "name") as! String
            self.myMovieYearChosen = self.listArray[self.pickerTypeIndex].value(forKey: "year") as! String
            self.myMovieTypeChosen = self.listArray[self.pickerTypeIndex].value(forKey: "type") as! String
            self.myMovieIMDBChosen = self.listArray[self.pickerTypeIndex].value(forKey: "imdb") as! String
            self.myMovieCommentsChosen = self.listArray[self.pickerTypeIndex].value(forKey: "comments") as! String
            
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
                
                //.. delete the row from the array?? Doesn't seem to really delete until you save again
                self.dataManager.delete(self.listArray[self.pickerTypeIndex])
                
                //.. resave the data... appDelegate knows that there were changes and adjusts accordingly??
                do {
                    //**** Ask Bill ::: not sure why you're re-saving this ??? Doesn't the above do that already?
                    //.. re-save to the db
                    try self.dataManager.save()
                    
                    //.. Redisplay the "newly updated" picker (since a row was deleted)
                    //.. You seem to need to refetch because otherwise listArray isn't set right with picker
                    //..   I get errors unwrapping nils
                    
                    self.listArray.removeAll()
                    self.fetchData()
                    print("******* listArray after save and after re-fetch of data ==== \(self.listArray)")
                    
                    self.pickerPickedLabel.text = ""
                    self.myMoviePicker.reloadAllComponents()
                    self.myView.reloadInputViews()
                } catch {
                    print ("Error deleting data")
                }
                
            })
            
            alert.addAction(okAction)
            alert.addAction(cancelAction)
            self .present(alert, animated: true, completion: nil )
            
        }
        
    }
    
    //.. read from db - get all rows
    func fetchData() {
        
        //.. from https://stackoverflow.com/questions/35417012/sorting-nsmanagedobject-array
//        let fetchRequest = NSFetchRequest(entityName: CoreDataValues.EntityName)
//        let sortDescriptor = NSSortDescriptor(key: CoreDataValues.CreationDateKey, ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        do {
        
        //.. setup fetch from "Item" in xcdatamodeld
        let fetchRequest : NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "MyMovieTable")
        
        //.. do this if you're trying to sort it when it's coming back as part of the fetch request..
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            //.. try to fetch data
            let result = try dataManager.fetch(fetchRequest)
            //.. set the array equal to the results fetched
            listArray = result as! [NSManagedObject]
            
            //.. just display what's in the db right now... not really needed... but helps for debugging
            if !listArray.isEmpty {
                //.. for each item in the array, do the following..
                for item in listArray {
                    let myMovieNameRetrieved = item.value(forKey: "name") as! String
                    print("====> myMovieNameRetrieved in listArray/CoreData: \(myMovieNameRetrieved)")
                }
            }
        } catch {
            print ("Error retrieving data")
        }
        
    }

}
