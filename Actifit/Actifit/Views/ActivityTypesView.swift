//
//  ActivityTypesView.swift
//  Actifit
//
//  Created by Hitender kumar on 15/08/18.
//

import UIKit

class ActivityTypesView: UIView {

    @IBOutlet weak var activitiesTableView : UITableView!
    @IBOutlet weak var doneBtn : UIButton!

    let activityTypes = ["Aerobics", "BasketBall", "Boxing", "Cycling", "Daily Activity", "Dancing", "Elliptical", "Football", "House Chores", "Jogging", "Martial Arts", "Moving Around Office", "Rope Skipping", "Running", "Shopping", "Stair Mill", "Table Tennis", "Tennis", "Treadmill", "Walking", "Weight Lifting"]
    
    var selectedActivities = [String]()
    
    var SelectedActivityTypesCompletion : ((_ selectedActivityTypes : [String]) -> ())?

    override func awakeFromNib() {
        super.awakeFromNib()
        activitiesTableView.layer.cornerRadius = 4.0
        self.doneBtn.layer.cornerRadius = 4.0
        self.activitiesTableView.register(UINib.init(nibName: "ActivityTypeTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "ActivityTypeTableViewCell")
    }
    
    //MARK : INTERFACE BUILDER ACTIONS
    
    @IBAction func doneBtnAction(_ sender : UIButton) {
        if let selectedActivityTypesCompletion = SelectedActivityTypesCompletion {
            selectedActivityTypesCompletion(self.selectedActivities)
        }
    }
}

extension ActivityTypesView : UITableViewDelegate, UITableViewDataSource {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activityTypes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : ActivityTypeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ActivityTypeTableViewCell", for: indexPath) as! ActivityTypeTableViewCell
        cell.selectionStyle = .none
        let activityType = self.activityTypes[indexPath.row]
        cell.activityTypeLabel.text = activityType
       
        let contains = self.selectedActivities.contains(activityType)
        cell.selectedActivityImageview.backgroundColor = contains ? UIColor.red : UIColor.clear
       // cell.selectedActivityImageview.isHidden = !contains
        cell.selectedActivityImageview.layer.cornerRadius = 2.0

         cell.selectedActivityImageview.layer.borderWidth = contains ? 0.0 : 1.0
        
        cell.selectedActivityImageview.layer.borderColor = contains ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = self.activityTypes[indexPath.row]
        if !self.selectedActivities.contains(type) {
            self.selectedActivities.append(self.activityTypes[indexPath.row])
        } else {
           self.selectedActivities = self.selectedActivities.filter({$0 != type})
        }
        self.activitiesTableView.reloadData()
    }
    
    //MARK: UITableViewDelegate

    
}
