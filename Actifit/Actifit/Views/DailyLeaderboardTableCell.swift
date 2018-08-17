//
//  DailyLeaderboardTableCell.swift
//  Actifit
//
//  Created by Hitender kumar on 16/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit

class DailyLeaderboardTableCell: UITableViewCell {

    @IBOutlet weak var leaderboardNameAndScoreLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
