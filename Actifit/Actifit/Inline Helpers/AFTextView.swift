//
//  AFTextView.swift
//  Actifit
//
//  Created by Hitender kumar on 13/08/18.
//

import UIKit

class AFTextView: UITextView {
    
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
        self.clipsToBounds = false
        self.registerTextViewBeginEditingNotification()
        self.registerTextViewEndEditingNotification()
        self.registerTextViewTextChangeNotification()
        self.setUpLineLabel()
    }
    
    deinit{
        
    }
    
    //MARK: Private Helpers
    
    private func setUpLineLabel() {
        self.lineLabel.backgroundColor = UIColor.lightGray
        self.addSubview(self.lineLabel)

        self.lineLabel.prepareForNewConstraints(block: { (view) in
            self.lineLabel.setBottomSpaceFromSuperView(bottomSpace: 35)
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
    
    @objc private func txtViewDidBeignEditing(){
        self.highlightLineLabel()
    }
    
    @objc private func txtViewDidEndEditing(){
        self.unHighlightLineLabel()
    }
    
    @objc private func txtViewTextDidChange(){
        let attrbutedStr = self.text.attributedString(font: UIFont.systemFont(ofSize: 15))
        let newHeight = attrbutedStr.heightFor(boundingWidth: ScreenWidth - 20)
        if newHeight < 30 { return }
        self.heightConstraint?.constant = newHeight
        self.superview?.layoutIfNeeded()
        self.sizeToFit()
        self.isScrollEnabled = false
    }
    
    private func registerTextViewBeginEditingNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(txtViewDidBeignEditing), name:NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
    }
    
    private func registerTextViewEndEditingNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(txtViewDidEndEditing), name:NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    private func registerTextViewTextChangeNotification(){
        NotificationCenter.default.addObserver(self, selector:#selector(txtViewTextDidChange), name:NSNotification.Name.UITextViewTextDidChange, object: self)
    }
}
