//
//  MovieListVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//
import UIKit

//.. Populate a tableView with the list of movies that came back from the search criteria
class MovieListVC: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var movieTable: UITableView!
    @IBOutlet var labelName: UILabel!
    
    var finalName = ""
    
    //.. array used for movie API info coming back
    var movieArrayTupSorted2: [(xName: String, xYear: String, xType: String, xIMDB: String, xPoster: String)] = [("","","","","")]
    
    let defaultImageArray = ["posternf.png","pearl.jpg","gitcat.jpg"]
    
    let cellID = "cellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        movieTable.dataSource = self
        movieTable.delegate = self
        
        finalName = finalName.uppercased()
        
        //labelName.text = "\"" + finalName + "\"" + " Movies"
        labelName.text = "Results for: \"" + finalName + "\""
        
        //..tableView.rowHeight = 40
        movieTable.rowHeight = 145
        movieTable.separatorColor = UIColor.red
        
    }
    
    func tableView( _ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            return movieArrayTupSorted2.count
        }
        
    func tableView( _ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
        //var cell = tableView.dequeueReusableCell(withIdentifier: cellID)
        var cell: TableViewCell = tableView.dequeueReusableCell(withIdentifier: "customCell") as! TableViewCell
        
        if (cell == nil ) {
            //cell = UITableViewCell(style: UITableViewCell.CellStyle.default,
            cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle,reuseIdentifier: cellID) as! TableViewCell
            }
           
        //.. note: this already came in sorted from SearchVC.swift
        let mRow = movieArrayTupSorted2[indexPath.row]
        
        cell.mainText?.text = mRow.xName
        cell.subText?.text = mRow.xYear
        cell.typeText?.text = mRow.xType
        
        let url = mRow.xPoster
        var myImage = UIImage(named: defaultImageArray[0])
        
        if url == "" {
            myImage = UIImage(named: defaultImageArray[0])
        } else {
            let imageURL = URL(string: url)
            if let imageData = try? Data(contentsOf: imageURL!) {
               
                myImage = UIImage(data: imageData)
                //print(myImage)
//                DispatchQueue.main.async {
//                    return myImage
//                }
            } else {
                //myImage = UIImage(named: defaultImageArray[0])
                myImage = UIImage(named: "posternotfound.JPG")
            }
        }
     
        //.. this is referenced in TableViewCell.swift; if you just use cell.imageView?.image (commented out line below), the pictures just "default" to whatever size they come in as
        cell.cellImage.image = myImage
        //cell.imageView?.image = myImage
       
        return cell
    }
        
        // method to run when table view cell is tapped
        //.. NOTE:  Per "bug" where MovieDetailVC2 VC apparently loads twice per stackoverflow
        //..   https://stackoverflow.com/questions/1081131/viewdidload-getting-called-twice-on-rootviewcontroller-at-launch
        //.. 2020 - see this for solution and why it's happening!!!!!!!
        //.. https://stackoverflow.com/questions/32300300/view-controller-loads-twice-how-do-i-fix-it#:~:text=Here's%20the%20simplest%20solution%20ever,and%20you%20should%20be%20okay.
    
        //..   post about viewDidLoad from segue call from MovieListViewController, I had
        //..   to rename MovieDetailVC to MovieDetailVC2 and redo the segue
        //..   to stop this from loading two times (first time had nil for movie title)
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            print("You tapped cell number \(indexPath.row).")
            self.performSegue(withIdentifier: "movieDetailSegue", sender: indexPath.row)
           
        }
        
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            let selectedRow = sender as? Int
            //print("selected row --->>>>> \(selectedRow)")
            
            let mRowSelected = movieArrayTupSorted2[selectedRow ?? 0]
            
            let vc = segue.destination as! MovieDetailVC
            
            vc.movieTitle = mRowSelected.xName
            vc.movieYear = mRowSelected.xYear
            vc.movieType = mRowSelected.xType
            vc.movieIMDB = mRowSelected.xIMDB
            vc.moviePoster = mRowSelected.xPoster
            
        }
    
    
}
