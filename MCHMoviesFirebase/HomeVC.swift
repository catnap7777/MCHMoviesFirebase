//
//  HomeVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//

import UIKit
import FirebaseDatabase

class HomeVC: UIViewController {

   @IBOutlet var enterButtonObj: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "popcorn2_wo_middle3.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        //backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        let ref = Database.database().reference()
        
//        ref.child("imdb1234").setValue(["name":"test movie1","type":"movie","year":"2021","comments":"none","poster":"poster addr"])
        
//        ref.child("test movie4").setValue(["imdb":"3333","type":"movie","year":"2021","comments":"none","poster":"poster addr"])
       
//        ref.child("search").setValue(["imdb":"4444","name":"testmovie3","type":"movie","year":"2021","comments":"none","poster":"poster addr"])
        
//        ref.childByAutoId().setValue(["imdb":"2222","name":"testmovie2","type":"movie","year":"2021","comments":"none","poster":"poster addr"])
        
        // Do any additional setup after loading the view.
    }

    @IBAction func enterButtonPressed(_ sender: Any) {
        
    }
}
