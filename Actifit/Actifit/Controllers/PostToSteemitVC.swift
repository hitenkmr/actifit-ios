//
//  PostToSteemitVC.swift
//  Actifit
//
//  Created by Hitender kumar on 12/08/18.
//

import UIKit

class PostToSteemitVC: UIViewController {
    
    @IBOutlet weak var steemitUsernameTextField : UITextField!
    @IBOutlet weak var steemitPostingPrivateKeyTextField : UITextField!
    @IBOutlet weak var postTextField : UITextField!
    @IBOutlet weak var activityCountLabel : UILabel!
    @IBOutlet weak var activityTypeBtn : UIButton!
    @IBOutlet weak var heightTextField : UITextField!
    @IBOutlet weak var weightTextField : UITextField!
    @IBOutlet weak var bodyFatTextField : UITextField!
    @IBOutlet weak var waistTextField : UITextField!
    @IBOutlet weak var thighTextField : UITextField!
    @IBOutlet weak var chestTextField : UITextField!
    @IBOutlet weak var postTagsTextView : UITextView!
    @IBOutlet weak var postContentTextView : UITextView!
    @IBOutlet weak var postToSteemitBtn : UITextView!

    //MARK: VIEW LIFE CYCLE
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func activityTypeBtnAction(_ sender : UIButton) {
        
    }
    
    @IBAction func postToSteemitBtnAction(_ sender : UIButton) {
        
    }
}
