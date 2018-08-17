//
//  ActivityTypeTableViewCell.swift
//  Actifit
//
//  Created by Hitender kumar on 15/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit
import Foundation

class ActivityTypeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var activityTypeLabel : UILabel!
    @IBOutlet weak var selectedActivityImageview : UIImageView!
    
    var SelectActivityBtnCompletion : ((_ indexPath : IndexPath) -> ())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}
