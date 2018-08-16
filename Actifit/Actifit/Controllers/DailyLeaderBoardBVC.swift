//
//  DailyLeaderBoardBVC.swift
//  Actifit
//
//  Created by Hitender kumar on 16/08/18.
//

import UIKit
import SwiftLoader

class DailyLeaderBoardBVC: UIViewController {
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var dailyLeaderboardTableView : UITableView!
    
    lazy var leaderboardArray = {
        return [String]()
    }()
    
    //MARK: VIEW LIFE CYCLE
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.backBtn.setImage(#imageLiteral(resourceName: "back_black").withRenderingMode(.alwaysTemplate), for: .normal)
        self.backBtn.tintColor = UIColor.white
        self.dailyLeaderboardTableView.tableFooterView = UIView()
        
        //get all daily leaderboard users list
        self.getDailyLeaderboard()
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func backBtnAction(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: WEB SERVICES
    
    func getDailyLeaderboard() {
        SwiftLoader.show(title: Messages.fetching_leaderboard, animated: true)
        APIMaster.getDailyLeaderboard(completion: { [weak self] (jsonString) in
            DispatchQueue.main.async(execute: {
                SwiftLoader.hide()
            })
            var noLeaderboardUsers = true
            if let jsonString = jsonString as? String {
                //set varialbe to false if string is empty/true otherwise
                noLeaderboardUsers = jsonString.isEmpty || (jsonString == "{}")
                //show leaderboard user score
                if noLeaderboardUsers == false {
                    self?.leaderboardArray = jsonString.components(separatedBy: CharacterSet.init(charactersIn: ";"))
                    
                    //remove last element if an empty string
                    if let lastElement = self?.leaderboardArray.last {
                        if lastElement.isEmpty {
                            if let arraySlice = self?.leaderboardArray.dropLast() {
                                self?.leaderboardArray = Array(arraySlice)
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        self?.dailyLeaderboardTableView.reloadData()
                    }
                }
            }
            
            //show no users on leaderboard is api fails
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                if noLeaderboardUsers {
                    self?.showAlertWith(title: nil, message: Messages.leader_no_results)
                }
            })
        }) { (error) in
            DispatchQueue.main.async(execute: {
                SwiftLoader.hide()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.showAlertWith(title: nil, message: error.localizedDescription)
            })
        }
    }
    
}

extension DailyLeaderBoardBVC : UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.leaderboardArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DailyLeaderboardTableCell = tableView.dequeueReusableCell(withIdentifier: "DailyLeaderboardTableCell", for: indexPath) as! DailyLeaderboardTableCell
        cell.leaderboardNameAndScoreLabel.text = self.leaderboardArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Daily Leaderboard: Top 5"
    }
}

