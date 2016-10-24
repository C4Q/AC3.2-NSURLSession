//
//  InstaDogTableViewCell.swift
//  AC3.2-InstaCats-2
//
//  Created by Erica Y Stevens on 10/21/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class InstaDogTableViewCell: UITableViewCell {

    @IBOutlet weak var instaDogImage: UIImageView!
    
    @IBOutlet weak var instaDogNameLabel: UILabel!
    
    @IBOutlet weak var instaDogStatsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    
        //Turns squre image into circular image
        instaDogImage.layer.cornerRadius =  instaDogImage.frame.size.width / 2
        instaDogImage.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
