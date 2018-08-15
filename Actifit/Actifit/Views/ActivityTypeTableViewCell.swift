//
//  ActivityTypeTableViewCell.swift
//  Actifit
//
//  Created by Hitender kumar on 15/08/18.
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
