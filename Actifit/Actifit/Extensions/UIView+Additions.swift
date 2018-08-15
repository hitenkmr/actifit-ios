//
//  UIView+Additions.swift
//  Actifit
//
//  Created by Hitender Kumar on 15/08/18.
//

import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var KeyIndexPath    = "IndexPath"
    static var KeyIdentifier   = "Identifier"
    static var KeyInfo         = "Info"
    static var KeyMarked       = "Marked"
}

private struct LayerNames {
    static var top    = "top"
    static var left   = "left"
    static var right         = "right"
    static var bottom       = "bottom"
}

extension UIView {
    
    var indexPath: IndexPath?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.KeyIndexPath) as? IndexPath
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.KeyIndexPath, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &AssociatedKeys.KeyIndexPath, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var identifier : String?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.KeyIdentifier) as? String
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.KeyIdentifier, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &AssociatedKeys.KeyIdentifier, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    
    var info : [String : Any]?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.KeyInfo) as? [String : Any]
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.KeyInfo, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &AssociatedKeys.KeyInfo, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    var marked : Bool?{
        get{
            return objc_getAssociatedObject(self, &AssociatedKeys.KeyMarked) as? Bool
        }
        set{
            objc_setAssociatedObject(self, &AssociatedKeys.KeyMarked, nil, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            objc_setAssociatedObject(self, &AssociatedKeys.KeyMarked, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    // MARK: Frame Setters
    
    func setOrigin(origin : CGPoint){
        var frame = self.frame
        frame.origin.x = origin.x
        frame.origin.y = origin.y
        self.frame = frame
    }
    
    func setXOrigin(xOrigin : CGFloat){
        var frame = self.frame
        frame.origin.x = xOrigin
        self.frame = frame
    }
    
    func setYOrigin(yOrigin : CGFloat){
        var frame = self.frame
        frame.origin.y = yOrigin
        self.frame = frame
    }
    
    func setWidth(width : CGFloat){
        var frame = self.frame
        frame.size.width = width
        self.frame = frame
    }
    
    func setHeight(height : CGFloat){
        var frame = self.frame
        frame.size.width = height
        self.frame = frame
    }
    
    // MARK: Frame Getters
    
    func getOrigin() -> CGPoint?{
        return self.frame.origin
    }
    
    func getXOrigin() -> CGFloat{
        return self.frame.origin.x
    }
    
    func getYOrigin() -> CGFloat{
        return self.frame.origin.y
    }
    
    func getWidth() -> CGFloat{
        return self.frame.size.width
    }
    
    func getHeight() -> CGFloat{
        return self.frame.size.height
    }
        
 }

public extension UIView {
    
    //https://github.com/aaronn/UIView-Borders-Swift
    
    //MARK FOR BERDERS
    
    public enum ViewSide {
        case top
        case right
        case bottom
        case left
    }
    
    public func createBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> CALayer {
        
        switch side {
        case .top:
            // Bottom Offset Has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .right:
            // Left Has No Effect
            // Subtract bottomOffset from the height to get our end.
            return _getOneSidedBorder(frame: CGRect(x: self.frame.size.width - thickness - rightOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height), color: color)
        case .bottom:
            // Top has No Effect
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: self.frame.size.height-thickness-bottomOffset,
                                                    width: self.frame.size.width - leftOffset - rightOffset,
                                                    height: thickness), color: color)
        case .left:
            // Right Has No Effect
            return _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                    y: 0 + topOffset,
                                                    width: thickness,
                                                    height: self.frame.size.height - topOffset - bottomOffset), color: color)
        }
    }
    
    public func createViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) -> UIView {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            return border
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            return border
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            return border
            
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            return border
        }
    }
    
    public func addBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .top:
            // Add leftOffset to our X to get start X position.
            // Add topOffset to Y to get start Y position
            // Subtract left offset from width to negate shifting from leftOffset.
            // Subtract rightoffset from width to set end X and Width.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset,
                                                                   height: thickness), color: color)
          self.tagBorderLayerWith(name: LayerNames.top, layer: border)
          self.removeExistingBorderLayerWith(name: LayerNames.top)
          self.layer.addSublayer(border)
            
        case .right:
            // Subtract the rightOffset from our width + thickness to get our final x position.
            // Add topOffset to our y to get our start y position.
            // Subtract topOffset from our height, so our border doesn't extend past teh view.
            // Subtract bottomOffset from the height to get our end.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                   y: 0 + topOffset, width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.tagBorderLayerWith(name: LayerNames.right, layer: border)
            self.removeExistingBorderLayerWith(name: LayerNames.right)
            self.layer.addSublayer(border)
        case .bottom:
            // Subtract the bottomOffset from the height and the thickness to get our final y position.
            // Add a left offset to our x to get our x position.
            // Minus our rightOffset and negate the leftOffset from the width to get our endpoint for the border.
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: self.frame.size.height-thickness-bottomOffset,
                                                                   width: self.frame.size.width - leftOffset - rightOffset, height: thickness), color: color)
            self.tagBorderLayerWith(name: LayerNames.bottom, layer: border)
            self.removeExistingBorderLayerWith(name: LayerNames.bottom)
            self.layer.addSublayer(border)
        case .left:
            let border: CALayer = _getOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                   y: 0 + topOffset,
                                                                   width: thickness,
                                                                   height: self.frame.size.height - topOffset - bottomOffset), color: color)
            self.tagBorderLayerWith(name: LayerNames.left, layer: border)
            self.removeExistingBorderLayerWith(name: LayerNames.left)
            self.layer.addSublayer(border)
        }
    }
    
    public func addViewBackedBorder(side: ViewSide, thickness: CGFloat, color: UIColor, leftOffset: CGFloat = 0, rightOffset: CGFloat = 0, topOffset: CGFloat = 0, bottomOffset: CGFloat = 0) {
        
        switch side {
        case .top:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
            self.addSubview(border)
            
        case .right:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: self.frame.size.width-thickness-rightOffset,
                                                                            y: 0 + topOffset, width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleLeftMargin]
            self.addSubview(border)
            
        case .bottom:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: self.frame.size.height-thickness-bottomOffset,
                                                                            width: self.frame.size.width - leftOffset - rightOffset,
                                                                            height: thickness), color: color)
            border.autoresizingMask = [.flexibleWidth, .flexibleTopMargin]
            self.addSubview(border)
        case .left:
            let border: UIView = _getViewBackedOneSidedBorder(frame: CGRect(x: 0 + leftOffset,
                                                                            y: 0 + topOffset,
                                                                            width: thickness,
                                                                            height: self.frame.size.height - topOffset - bottomOffset), color: color)
            border.autoresizingMask = [.flexibleHeight, .flexibleRightMargin]
            self.addSubview(border)
        }
    }
    
    //////////
    // Private: Our methods call these to add their borders.
    //////////
    
    
    fileprivate func _getOneSidedBorder(frame: CGRect, color: UIColor) -> CALayer {
        let border:CALayer = CALayer()
      //  border.cornerRadius = 2
        border.frame = frame
        border.backgroundColor = color.cgColor
        return border
    }
    
    fileprivate func _getViewBackedOneSidedBorder(frame: CGRect, color: UIColor) -> UIView {
        let border:UIView = UIView.init(frame: frame)
        border.backgroundColor = color
        return border
    }
    
    //tag border with name so that can be removed later
    fileprivate func tagBorderLayerWith(name : String, layer : CALayer) {
        layer.name = name
    }
    
    // remove existing border with name
    public func removeExistingBorderLayerWith(name : String) {
        if let subLayers = self.layer.sublayers {
            subLayers.forEach { (borderLayer) in
                if borderLayer.name == name {
                    borderLayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    
}
