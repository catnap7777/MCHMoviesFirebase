//
//  TableViewCell.swift
//  MCHMoviesFirebase
//
//  Created by Karen Mathes on 2/18/21.
//  Copyright © 2021 TygerMatrix Software. All rights reserved.
//

import UIKit

//.. Custom cell that's used for the list of movies that come back from the API search
class TableViewCell: UITableViewCell {

    @IBOutlet var mainText: UILabel!
    @IBOutlet var subText: UILabel!
    @IBOutlet var typeText: UILabel!
    @IBOutlet var cellImage: UIImageView!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        
        
    }

}
