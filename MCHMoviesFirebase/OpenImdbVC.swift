//
//  OpenImdbVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//


import UIKit

class OpenImdbVCViewController: UIViewController {

    @IBOutlet var ImdbButtonObj: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //.. For initial load of IMDB
        //.. Need to use viewDidAppear so that if tab is re-clicked, IMDB loads again
        
        //let imdbURL = "https://www.imdb.com/title/" + movieIMDB
        let imdbURL = "https://www.imdb.com"
        
        if let url = URL(string: imdbURL) {
            UIApplication.shared.open(url, options: [:])
        }
        
    }
    
    //.. extra so that user can reload IMDB if desired
    @IBAction func ImdbButtonPressed(_ sender: Any) {
            //let imdbURL = "https://www.imdb.com/title/" + movieIMDB
            let imdbURL = "https://www.imdb.com"
        
            if let url = URL(string: imdbURL) {
                UIApplication.shared.open(url, options: [:])
            }
    }
    
    //.. reload IMDB when focus switches back to this tab
    override func viewDidAppear(_ animated: Bool) {
        let imdbURL = "https://www.imdb.com"
        
        if let url = URL(string: imdbURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    
}
