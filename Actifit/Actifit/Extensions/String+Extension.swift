//
//  String+Extension.swift
//  Actifit
//
//  Created by Hitender kumar on 13/08/18.
//

import Foundation
import UIKit

extension String {
    func attributedString(font : UIFont) -> NSMutableAttributedString {
        let attributedStr = NSMutableAttributedString.init(string: self)
        attributedStr.addAttributes([NSAttributedStringKey.font : font as Any], range: NSRange.init(location: 0, length: attributedStr.length))
        return attributedStr
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    func utf8Data() -> Data {
        return self.data(using: String.Encoding.utf8)!
    }
}
