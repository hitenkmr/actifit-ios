//
//  PostToSteemitVC.swift
//  Actifit
//
//  Created by Hitender kumar on 12/08/18.
//

import UIKit

class PostToSteemitVC: UIViewController {
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var steemitUsernameTextField : AFTextField!
    @IBOutlet weak var steemitPostingPrivateKeyTextField : AFTextField!
    @IBOutlet weak var postTitleTextView : AFTextView!
    @IBOutlet weak var postTitleTextViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var activityCountLabel : UILabel!
    @IBOutlet weak var activityTypeBtn : UIButton!
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
        
        self.postTitleTextView.delegate = self
        self.postTagsTextView.delegate = self
        self.postContentTextView.delegate = self

        self.backBtn.setImage(#imageLiteral(resourceName: "back_black").withRenderingMode(.alwaysTemplate), for: .normal)
        self.backBtn.tintColor = UIColor.white
        self.postContentTextView.heightConstraint = self.postContentTextViewHeightConstraint
        self.postTitleTextView.heightConstraint = self.postTitleTextViewHeightConstraint
        self.postTagsTextView.heightConstraint = self.postTagsTextViewHeightConstraint
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       self.registerTextFieldTextChangeNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.removeTextFieldTextChangeNotification()
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func backBtnAction(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func activityTypeBtnAction(_ sender : UIButton) {
        
    }
    
    @IBAction func postToSteemitBtnAction(_ sender : UIButton) {
        // check minimum steps count required to post the activity
        var stepsCount = 1100
        if let activity = self.todayActivity {
            stepsCount = activity.steps
        }
        if stepsCount < 1000 {
            self.showAlertWith(title: nil, message: Messages.error_minimun_activity)
            return
        }
        
        // check post content minimum words count to post the activity
        let components = (self.postContentTextView.text ?? "").components(separatedBy: .whitespacesAndNewlines)
        let postContentWordsArray = components.filter { !$0.isEmpty }
        if postContentWordsArray.count < 30 {
            self.showAlertWith(title: nil, message: Messages.error_post_content_word_count )
            return
        }
    }
    
    //MARK: HELPERS
    
    //returns current day date from midnight
    func todayStartDate() -> Date {
        //For Start Date
        var calendar = NSCalendar.current
        calendar.timeZone = NSTimeZone.local
        let dateAtMidnight = calendar.startOfDay(for: Date())
        return dateAtMidnight
    }
    
    @objc private func txtFieldTextDidChange(){
        if let currentUser = self.currentUser {
            //update user saved username and private posting key
            currentUser.updateUser(steemit_username: self.steemitUsernameTextField.text ?? "", private_posting_key: self.steemitPostingPrivateKeyTextField.text ?? "")
        } else {
            //save user username and private posting key
            User.saveWith(info: [UserKeys.steemit_username : self.steemitUsernameTextField.text ?? "", UserKeys.private_posting_key : self.steemitPostingPrivateKeyTextField.text ?? ""])
        }
        self.currentUser = User.current()
    }
    
    private func registerTextFieldTextChangeNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(txtFieldTextDidChange), name:NSNotification.Name.UITextFieldTextDidChange, object: nil)
    }
    
    private func removeTextFieldTextChangeNotification(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextFieldTextDidChange, object: nil)
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
