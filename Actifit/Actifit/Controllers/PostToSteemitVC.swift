//
//  PostToSteemitVC.swift
//  Actifit
//
//  Created by Hitender kumar on 12/08/18.
//

import UIKit

let PostContentMinWordCount = 30
let PostMinActivityStepsCount = 1000

class PostToSteemitVC: UIViewController {
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var steemitUsernameTextField : AFTextField!
    @IBOutlet weak var steemitPostingPrivateKeyTextField : AFTextField!
    @IBOutlet weak var postTitleTextView : AFTextView!
    @IBOutlet weak var postTitleTextViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var activityCountLabel : UILabel!
    @IBOutlet weak var activityTypeLabel : UILabel!
    @IBOutlet weak var heightTextField : AFTextField!
    @IBOutlet weak var weightTextField : AFTextField!
    @IBOutlet weak var bodyFatTextField : AFTextField!
    @IBOutlet weak var waistTextField : AFTextField!
    @IBOutlet weak var thighTextField : AFTextField!
    @IBOutlet weak var chestTextField : AFTextField!
    @IBOutlet weak var postTagsTextView : AFTextView!
    @IBOutlet weak var postTagsTextViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var postContentTextView : AFTextView!
    @IBOutlet weak var postContentTextViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var postToSteemitBtn : UIButton!
    
    @IBOutlet weak var postTitleTextViewLineLabel : UIView!
    @IBOutlet weak var postTagsTextViewLineLabel  : UIView!
    @IBOutlet weak var postContentTextViewLineLabel  : UIView!

    var currentTextField : AFTextField?
    
    lazy var todayActivity = {
        return Activity.all().first(where: {$0.date == self.todayStartDate()})
    }()
    
    lazy var currentUser = {
        return User.current()
    }()
    
    //MARK: VIEW LIFE CYCLE
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //show today activity steps count
        if let activity = todayActivity {
            self.activityCountLabel.text = "\(activity.steps)"
        }
        
        //show current user steemit username and private posting key
        if let currentUser = self.currentUser {
            self.steemitUsernameTextField.text = currentUser.steemit_username
            self.steemitPostingPrivateKeyTextField.text = currentUser.private_posting_key
        }
     
        self.applyFinishingTouchToUIElements()
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func backBtnAction(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func activityTypeBtnAction(_ sender : UIButton) {
        if let nib = Bundle.main.loadNibNamed("ActivityTypesView", owner: self, options: nil) {
            var objActivityTypesView : ActivityTypesView? = nib[0] as? ActivityTypesView
            objActivityTypesView?.selectedActivities = (self.activityTypeLabel.text ?? "").components(separatedBy: CharacterSet.init(charactersIn: ","))
            objActivityTypesView?.activitiesTableView.reloadData()
            self.view.addSubview(objActivityTypesView!)
            objActivityTypesView?.prepareForNewConstraints { (v) in
                v?.setLeadingSpaceFromSuperView(leadingSpace: 0)
                v?.setTrailingSpaceFromSuperView(trailingSpace: 0)
                v?.setTopSpaceFromSuperView(topSpace: 0)
                v?.setBottomSpaceFromSuperView(bottomSpace: 0)
            }
            objActivityTypesView?.SelectedActivityTypesCompletion = { selectedActivities in
                
                if let firstChar = selectedActivities.joined(separator: ",").first {
                    if firstChar == "," {
                        let trimmiedStr = selectedActivities.joined(separator: ",").dropFirst(1)
                        self.activityTypeLabel.text = trimmiedStr.description
                    } else {
                        self.activityTypeLabel.text = selectedActivities.joined(separator: ",")
                    }
                } else {
                    self.activityTypeLabel.text = ""
                }
                objActivityTypesView?.selectedActivities.removeAll()
                objActivityTypesView?.removeFromSuperview()
                objActivityTypesView = nil
            }
        }
    }
    
    @IBAction func postToSteemitBtnAction(_ sender : UIButton) {
        
        //save user steemit credentials privately in local database
        self.saveOrUpdateUserCredentials()
        
        // check minimum steps count required to post the activity
        var stepsCount = 0
        if let activity = self.todayActivity {
            stepsCount = activity.steps
        }
        if stepsCount < PostMinActivityStepsCount {
            self.showAlertWith(title: nil, message: Messages.min_activity_steps_count_error + "\(PostMinActivityStepsCount) " + "steps to post your activity")
            return
        }
        
        // check post content minimum words count to post the activity
        let components = (self.postContentTextView.text ?? "").components(separatedBy: .whitespacesAndNewlines)
        let postContentWordsArray = components.filter { !$0.isEmpty }
        if postContentWordsArray.count < PostContentMinWordCount {
            self.showAlertWith(title: nil, message: Messages.error_post_content_word_count)
            return
        }
        
        //check is user has not selected any activity from the dropdown
        if let selectedActivityTypes = self.activityTypeLabel.text {
            if selectedActivityTypes.isEmpty {
                self.showAlertWith(title: nil, message: Messages.error_need_select_one_activity )
                return
            }
        }
        
        //remove more than one "actifit' tags from tags string
        var tagsString : NSMutableString = NSMutableString.init(string: self.postTagsTextView.text.trimmingCharacters(in: CharacterSet.init(charactersIn: "actifit")))
        if tagsString.contains("actifit") {
            tagsString = NSMutableString.init(string: tagsString.replacingOccurrences(of: "actifit", with: ""))
        }
        tagsString.insert("actifit", at: 0)
        
        var activityJson = [String : Any]()
        activityJson["author"] = self.currentUser?.steemit_username ?? ""
        activityJson["posting_key"] = self.currentUser?.private_posting_key ?? ""
        activityJson["title"] = self.postTitleTextView.text
        activityJson["content"] = self.postContentTextView.text
        activityJson["tags"] = tagsString
        activityJson["step_count"] = stepsCount
        activityJson["activity_type"] = self.activityTypeLabel.text ?? ""
        activityJson["height"] = self.heightTextField.text ?? ""
        activityJson["weight"] = self.weightTextField.text ?? ""
        activityJson["chest"] = self.chestTextField.text ?? ""
        activityJson["waist"] = self.waistTextField.text ?? ""
        activityJson["thigs"] = self.thighTextField.text ?? ""
        activityJson["bodyfat"] = self.bodyFatTextField.text ?? ""
        activityJson["heightUnit"] = "cm"
        activityJson["weightUnit"] = "cm"
        activityJson["heightUnit"] = "cm"
        activityJson["chestUnit"] = "cm"
        activityJson["waistUnit"] = "cm"
        activityJson["thighsUnit"] = "cm"
        activityJson["appType"] = "iOS"
        
        self.postActvityWith(json: activityJson)
        
    }
    
    //MARK: HELPERS
    
    func applyFinishingTouchToUIElements() {
        self.postToSteemitBtn.layer.cornerRadius = 4.0
        self.postTitleTextView.delegate = self
        self.postTagsTextView.delegate = self
        self.postContentTextView.delegate = self
        
        self.backBtn.setImage(#imageLiteral(resourceName: "back_black").withRenderingMode(.alwaysTemplate), for: .normal)
        self.backBtn.tintColor = UIColor.white
        self.postContentTextView.heightConstraint = self.postContentTextViewHeightConstraint
        self.postTitleTextView.heightConstraint = self.postTitleTextViewHeightConstraint
        self.postTagsTextView.heightConstraint = self.postTagsTextViewHeightConstraint
    }
    
    //returns current day date from midnight
    func todayStartDate() -> Date {
        //For Start Date
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let dateAtMidnight = calendar.startOfDay(for: Date())
        return dateAtMidnight
    }
    
    func saveOrUpdateUserCredentials() {
        let userName = (self.steemitUsernameTextField.text ?? "").trimmingCharacters(in: CharacterSet.init(charactersIn: "@"))
        let privatePostingKey = self.steemitPostingPrivateKeyTextField.text ?? ""
        
        if let currentUser = self.currentUser {
            //update user saved username and private posting key
            
            currentUser.updateUser(steemit_username: userName, private_posting_key: privatePostingKey)
        } else {
            //save user username and private posting key
            User.saveWith(info: [UserKeys.steemit_username : userName, UserKeys.private_posting_key : privatePostingKey])
        }
        self.currentUser = User.current()
    }
    
    //MARK: WEB SERVICES
    
    func postActvityWith(json : [String : Any]) {
        
        APIMaster.loginUserWith(info: json, completion: { (json, httpResponse) in
            
        }) { (error) in
            
        }
    }
}

extension PostToSteemitVC : UITextViewDelegate{
    
    //MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if let afTextView = (textView as? AFTextView) {
            if afTextView.isEqual(self.postTitleTextView) {
                self.postTitleTextViewLineLabel.backgroundColor = UIColor.red
            } else if afTextView.isEqual(self.postTagsTextView) {
                self.postTagsTextViewLineLabel.backgroundColor = UIColor.red
            } else if afTextView.isEqual(self.postContentTextView) {
                self.postContentTextViewLineLabel.backgroundColor = UIColor.red
            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if let afTextView = (textView as? AFTextView) {
            if afTextView.isEqual(self.postTitleTextView) {
                self.postTitleTextViewLineLabel.backgroundColor = UIColor.lightGray
            } else if afTextView.isEqual(self.postTagsTextView) {
                self.postTagsTextViewLineLabel.backgroundColor = UIColor.lightGray
            } else if afTextView.isEqual(self.postContentTextView) {
                self.postContentTextViewLineLabel.backgroundColor = UIColor.lightGray
            }
        }
    }
}

extension PostToSteemitVC : UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.currentTextField = textField as? AFTextField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
}
