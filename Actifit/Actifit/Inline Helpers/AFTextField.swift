//
//  AFTextField.swift
//  Actifit
//
//  Created by Hitender kumar on 12/08/18.
//  Copyright © 2018 Hitender kumar. All rights reserved.


import UIKit

class AFTextField: UITextField {
    
    lazy var lineLabel : UILabel = {
        return UILabel()
    }()
    
    //MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: Designated Initilizer/DeInitilizer
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
        self.registerTextFieldBeginEditingNotification()
        self.registerTextFieldEndEditingNotification()
        
        self.setUpLineLabel()
    }
    
    deinit{
        
    }
    
    //MARK: Private Helpers
    
    private func setUpLineLabel() {
        self.lineLabel.backgroundColor = UIColor.lightGray
        self.lineLabel.prepareForNewConstraints(block: { (view) in
            self.addSubview(self.lineLabel)
            self.lineLabel.setBottomSpaceFromSuperView(bottomSpace: 0)
            self.lineLabel.setLeadingSpaceFromSuperView(leadingSpace: 0)
            self.lineLabel.setTrailingSpaceFromSuperView(trailingSpace: 0)
            self.lineLabel.pinHeightConstraint(constant: 1)
        })
    }
    
    
    private func highlightLineLabel()  {
        self.lineLabel.backgroundColor = UIColor.red
    }
    
    private func unHighlightLineLabel()  {
        self.lineLabel.backgroundColor = UIColor.lightGray
    }
    
    @objc private func txtFieldDidBeignEditing(){
        self.highlightLineLabel()
    }
    
    @objc private func txtFieldDidEndEditing(){
        self.unHighlightLineLabel()
    }
    
    private func registerTextFieldBeginEditingNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(txtFieldDidBeignEditing), name:NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
    }
    
    private func registerTextFieldEndEditingNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(txtFieldDidEndEditing), name:NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
    }
}


