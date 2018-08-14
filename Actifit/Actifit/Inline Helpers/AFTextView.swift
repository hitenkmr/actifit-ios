//
//  AFTextView.swift
//  Actifit
//
//  Created by Hitender kumar on 13/08/18.
//

import UIKit

class AFTextView: UITextView {
    
    //MARK: View Life Cycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    //MARK: Designated Initilizer/DeInitilizer
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.clipsToBounds = false
        self.registerTextViewTextChangeNotification()
    }
    
    deinit{
        
    }
    
    //MARK: Private Helpers
    
    @objc private func txtViewTextDidChange(){
        //http://iosanchor.com/dynamically-change-parent-uiviews-height-textview-height-changes/
        let fixedWidth = self.frame.size.width
        let newSize = self.sizeThatFits(CGSize(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude))
        self.heightConstraint?.constant = newSize.height
        self.layoutIfNeeded()
    }
    
    private func registerTextViewTextChangeNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(txtViewTextDidChange), name:NSNotification.Name.UITextViewTextDidChange, object: self)
    }
}
