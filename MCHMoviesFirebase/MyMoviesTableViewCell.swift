//
//  MyMoviesTableViewCell.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//

import UIKit

//.. Custom cell that's used for the list of my movies that come back from the PLIST of saved movies
class MyMoviesTableViewCell: UITableViewCell {

    @IBOutlet var myMovieName: UILabel!
    @IBOutlet var myMovieYear: UILabel!
    @IBOutlet var myMovieType: UILabel!
    @IBOutlet var myMovieImage: UIImageView!
    @IBOutlet var myMovieComments: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
