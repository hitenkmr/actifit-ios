//
//  ActivityTypesView.swift
//  Actifit
//
//  Created by Hitender kumar on 15/08/18.
//

import UIKit

class ActivityTypesView: UIView {

    @IBOutlet weak var activitiesTAbleView : UITableView!
    @IBOutlet weak var selectActivityBtn : UIButton!

    let activityTypes = ["Aerobics", "BasketBall", "Boxing", "Cycling", "Daily Activity", "Dancing", "Elliptical", "Football", "House Chores", "Jogging", "Martial Arts", "Moving Around Office", "Rope Skipping", "Running", "Shopping", "Stair Mill", "Table Tennis", "Tennis", "Treadmill", "Walking", "Weight Lifting"]
    
    var selectedActivities : [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    //MARK : INTERFACE BUILDER ACTIONS
    
}

extension ActivityTypesView : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ActivityTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTypeTableViewCell", for: indexPath) as! ActivityTypeTableViewCell
        cell.SelectActivityBtnCompletion = { selectedIndexPath in
            self.selectedActivities.append(self.activityTypes[selectedIndexPath.row])
        }
        return cell
    }
    
    //MARK: UITableViewDelegate

    
}
