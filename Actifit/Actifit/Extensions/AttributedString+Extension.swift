//
//  AttributedString+Extension.swift
//  Actifit
//
//  Created by Hitender kumar on 13/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import Foundation
import UIKit

extension NSAttributedString {
    func heightFor(boundingWidth : CGFloat) -> CGFloat {
        let rect = self.boundingRect(with: CGSize.init(width: boundingWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, context: nil)
        return rect.height
    }
}
