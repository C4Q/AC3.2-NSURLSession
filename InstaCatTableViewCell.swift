//
//  InstaCatTableViewCell.swift
//  AC3.2-InstaCats-2
//
//  Created by Erica Y Stevens on 10/23/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaCatTableViewCell: UITableViewCell {

    @IBOutlet weak var instaCatImageView: UIImageView!
    @IBOutlet weak var instaCatNameLabel: UILabel!
    @IBOutlet weak var instaCatDescriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //Turns squre image into circular image
        instaCatImageView.layer.cornerRadius =  instaCatImageView.frame.size.width / 2
        instaCatImageView.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
