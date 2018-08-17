//
//  TransactionTableViewCell.swift
//  Actifit
//
//  Created by Hitender kumar on 17/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var activityTypeLabel : UILabel!
    @IBOutlet weak var tokenCountLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var noteLabel : UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(transaction : Transaction) {
        self.activityTypeLabel.text = "Activity Type: \(transaction.reward_activity)"
        self.tokenCountLabel.text = "Token Count: \(transaction.token_count)"
        self.dateLabel.text = "Date Added: \(transaction.date)"
        self.noteLabel.text = "Note: \(transaction.note)"
    }

}
