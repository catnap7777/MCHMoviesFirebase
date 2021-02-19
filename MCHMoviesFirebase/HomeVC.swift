//
//  HomeVC.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

   @IBOutlet var enterButtonObj: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "popcorn2_wo_middle3.jpg")
        backgroundImage.contentMode = UIView.ContentMode.scaleAspectFill
        //backgroundImage.contentMode = UIView.ContentMode.scaleToFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        // Do any additional setup after loading the view.
    }

    @IBAction func enterButtonPressed(_ sender: Any) {
        
    }
}
