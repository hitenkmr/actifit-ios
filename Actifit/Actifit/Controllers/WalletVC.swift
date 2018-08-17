//
//  WalletVC.swift
//  Actifit
//
//  Created by Hitender kumar on 17/08/18.
//  Copyright © 2018 actifit.io. All rights reserved.
//

import UIKit

class WalletVC: UIViewController {
    
    @IBOutlet weak var backBtn : UIButton!
    @IBOutlet weak var usernameTextField : AFTextField!
    @IBOutlet weak var checkBalanceBtn : UIButton!
    @IBOutlet weak var actfitTokensLabel : UILabel!
    @IBOutlet weak var transactionsTableView : UITableView!

    var transactions = [Transaction]()

    var username = ""
    
    //MARK: VIEW LIFE CYCLE
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.applyFinishingTouchToUIElements()
        self.getWalletBalance()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
     }
    
    //MARK: Private Helpers
    
    //MARK: INTERFACE BUILDER ACTIONS
    
    @IBAction func backBtnAction(_ sender : UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func checkBalanceBtnAction(_ sender : UIButton) {
        self.getWalletBalance()
        self.getTransactions()
    }
    
    //MARK: HELPERS
    
    func applyFinishingTouchToUIElements() {
        self.checkBalanceBtn.layer.cornerRadius = 4.0
        self.transactionsTableView.tableFooterView = UIView()
        self.backBtn.setImage(#imageLiteral(resourceName: "back_black").withRenderingMode(.alwaysTemplate), for: .normal)
        self.backBtn.tintColor = UIColor.white
    }
    
    //MARK: WEB SERVICES
    
    func getWalletBalance() {
        if let text = self.usernameTextField.text {
            self.username = text.byTrimming(string: "@").lowercased()
        }
        self.view.endEditing(true)
        SwiftLoader.show(title: Messages.fetching_user_balance, animated: true)
        APIMaster.getWalletBalanceWith(username:self.username ,completion: { [weak self] (jsonString) in
            DispatchQueue.main.async(execute: {
                SwiftLoader.hide()
            })
            self?.getTransactions()
            var actifitTokens = "Unable to fetch balance"
            if let jsonString = jsonString as? String {
                let data = jsonString.utf8Data()
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonInfo = (json as? [String : Any]){
                        if let tokens = jsonInfo["tokens"] as? String {
                            actifitTokens = tokens
                        }
                    }
                } catch {
                    print("unable to fetch tokens")
                }
                DispatchQueue.main.async(execute: {
                    self?.actfitTokensLabel.text = actifitTokens
                })
            }
        }) { (error) in
            DispatchQueue.main.async(execute: {
                SwiftLoader.hide()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.showAlertWith(title: nil, message: error.localizedDescription)
            })
        }
    }
    
    func getTransactions() {
        APIMaster.getTransactions(username: self.username,completion: { [weak self] (jsonString) in
            DispatchQueue.main.async(execute: {
                SwiftLoader.hide()
            })
            if let jsonString = jsonString as? String {
                let data = jsonString.utf8Data()
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    if let jsonArray = (json as? [[String : Any]]){
                        self?.transactions = jsonArray.map({Transaction.init(info: $0)})
                    }
                } catch {
                    self?.transactions.removeAll()
                    print("unable to fetch transactions")
                }
                DispatchQueue.main.async(execute: {
                    self?.transactionsTableView.reloadData()
                })
            }
        }) { (error) in
            DispatchQueue.main.async(execute: {
                SwiftLoader.hide()
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: {
                self.showAlertWith(title: nil, message: error.localizedDescription)
            })
        }
    }
}

extension WalletVC : UITableViewDataSource, UITableViewDelegate {
    
    //MARK: UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transactions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : TransactionTableViewCell = tableView.dequeueReusableCell(withIdentifier: "TransactionTableViewCell", for: indexPath) as! TransactionTableViewCell
        let transaction = self.transactions[indexPath.row]
        cell.configureWith(transaction: transaction)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

