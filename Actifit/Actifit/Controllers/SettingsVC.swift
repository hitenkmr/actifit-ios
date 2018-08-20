//
//  SettingsVC.swift
//  Actifit
//
//  Created by Hitender kumar on 20/08/18.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var metricMeasurementSystemBtn : UIButton!
    @IBOutlet weak var USMeasurementSystemBtn : UIButton!
    @IBOutlet weak var donateTopCharityBtn : UIButton!
    @IBOutlet weak var metricDotView : UIView!
    @IBOutlet weak var usDotView : UIView!

    @IBOutlet weak var metricMeasurementSystemBtnDotViewWidthConstraint : NSLayoutConstraint!
    @IBOutlet weak var metricMeasurementSystemBtnDotViewHeightConstraint : NSLayoutConstraint!
    @IBOutlet weak var USMeasurementSystemBtnDotViewWidthConstraint  : NSLayoutConstraint!
    @IBOutlet weak var USMeasurementSystemBtnDotViewHeightConstraint  : NSLayoutConstraint!

    //MARK: VIEW LIFE CYCLE
    
    lazy var settings = {
        return Settings.current()
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        metricMeasurementSystemBtn.layer.cornerRadius = metricDotView.frame.size.width / 2
        USMeasurementSystemBtn.layer.cornerRadius = metricDotView.frame.size.width / 2

        metricDotView.layer.cornerRadius = metricDotView.frame.size.width / 2
        usDotView.layer.cornerRadius = usDotView.frame.size.width / 2
        self.donateTopCharityBtn.layer.borderColor = UIColor.darkGray.cgColor
        self.donateTopCharityBtn.layer.borderWidth = 1.0
        super.viewDidLoad()
        selectMetricSystem(select: false)
        selectUSSystem(select: false)
    }
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func backBtnAction(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func metricMeasurementSystemBtnAction(_ sender : UIButton) {
        if let settings = self.settings {
            settings.update(measurementSystem: .metric, isDonatingCharity: settings.isDonatingCharity, charityName: settings.charityName)
        } else {
            Settings.saveWith(info: [SettinsgKeys.measurementSystem : MeasurementSystem.metric.rawValue, SettinsgKeys.isDonatingCharity : false, SettinsgKeys.charityName : ""])
        }
        self.selectMetricSystem(select: true)
        self.selectUSSystem(select: false)
    }
    
    @IBAction func usMeasurementSystemBtnAction(_ sender : UIButton) {
        if let settings = self.settings {
            settings.update(measurementSystem: .us, isDonatingCharity: settings.isDonatingCharity, charityName: settings.charityName)
        } else {
            Settings.saveWith(info: [SettinsgKeys.measurementSystem : MeasurementSystem.us.rawValue, SettinsgKeys.isDonatingCharity : false, SettinsgKeys.charityName : ""])
        }
        self.selectUSSystem(select: true)
        self.selectMetricSystem(select: false)
    }
    
    @IBAction func donateTopCharityBtnAction(_ sender : UIButton) {
        sender.isSelected = !sender.isSelected
        self.donateTopCharityBtn.layer.borderColor = sender.isSelected ? UIColor.clear.cgColor :  UIColor.darkGray.cgColor
        self.donateTopCharityBtn.layer.borderWidth = sender.isSelected ? 1.0 : 0.0
        if sender.isSelected {
            self.donateTopCharityBtn.setImage(#imageLiteral(resourceName: "check").withRenderingMode(.alwaysTemplate), for: .normal)
            self.donateTopCharityBtn.tintColor = ColorTheme
        } else {
            self.donateTopCharityBtn.setImage(nil, for: .normal)
        }
        if let settings = self.settings {
            settings.update(measurementSystem: MeasurementSystem(rawValue: settings.measurementSystem)!, isDonatingCharity: settings.isDonatingCharity, charityName: settings.charityName)
        } else {
            Settings.saveWith(info: [SettinsgKeys.measurementSystem : MeasurementSystem.none, SettinsgKeys.isDonatingCharity : sender.isSelected, SettinsgKeys.charityName : ""])
        }
    }
    
    //MARK: HELPERS
    
    func selectMetricSystem(select : Bool) {
        self.metricMeasurementSystemBtn.layer.borderColor = select ? ColorTheme.cgColor : UIColor.darkGray.cgColor
        self.metricMeasurementSystemBtn.layer.borderWidth = 1.0
        self.metricMeasurementSystemBtnDotViewWidthConstraint.constant = select ? 10 : 0.0
        self.metricMeasurementSystemBtnDotViewHeightConstraint.constant = select ? 10 : 0.0
        self.view.layoutIfNeeded()
    }
    
    func selectUSSystem(select : Bool) {
        self.USMeasurementSystemBtn.layer.borderColor = select ? ColorTheme.cgColor : UIColor.darkGray.cgColor
        self.USMeasurementSystemBtn.layer.borderWidth = 1.0
        self.USMeasurementSystemBtnDotViewWidthConstraint.constant = select ? 10 : 0.0
        self.USMeasurementSystemBtnDotViewHeightConstraint.constant = select ? 10 : 0.0
        self.view.layoutIfNeeded()
    }
    
}
