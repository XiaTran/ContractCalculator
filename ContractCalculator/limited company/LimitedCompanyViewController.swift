//
//  ViewController.swift
//  ContractCalculator
//
//  Created by Xia Tran on 16/04/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class LimitedCompanyViewController: UITableViewController,  UITextFieldDelegate, GADBannerViewDelegate {

  @IBOutlet weak var adBanner: GADBannerView!
  
  @IBOutlet weak var resetButton: UIButton! //reset button
  @IBOutlet weak var calcButton: UIButton! //calculate button
  
  @IBOutlet weak var daysTotalLabel: UITextField! //number of days worked
  @IBOutlet weak var rateLabel: UITextField! //day rate
  @IBOutlet weak var annualLeaveLabel: UITextField! //days off
  @IBOutlet weak var expenseLabel: UITextField! // charging to company
  @IBOutlet weak var salaryLabel: UITextField! //salary
  @IBOutlet weak var dividendLabel: UITextField! //dividend
  
  
  @IBOutlet weak var IncomeResultLabel: UITextField! //gross income
  @IBOutlet weak var vatToHMRCResultLabel: UITextField! //VAT owed to HMRC
  @IBOutlet weak var corpTaxResultLabel: UITextField! //corporation tax
  @IBOutlet weak var netProfitResultLabel: UITextField! //company net profit
  @IBOutlet weak var dividendResultLabel: UITextField! //left in company after dividends

  var grossIncome: Double = 0
  var vatOwedToHMRC: Double = 0
  var corporationTax: Double = 0
  var companyNetProfit: Double = 0
  
  
  override func viewWillAppear(_ animated: Bool) {
    daysTotalLabel.text = String("253")
    annualLeaveLabel.text = String("0")
  }
  //MARK:- viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    daysTotalLabel.delegate = self
    rateLabel.delegate = self
    annualLeaveLabel.delegate = self
    expenseLabel.delegate = self
    salaryLabel.delegate = self
    dividendLabel.delegate = self
    adBannerInfo()
    adViewDidReceiveAd(adBanner)
    toolBar()
    self.view.bringSubviewToFront(tableView)
    self.view.bringSubviewToFront(resetButton)
  
  }
  
  func adBannerInfo() {
  let request = GADRequest()
  request.testDevices = [kGADSimulatorID]
  //set up ad
  adBanner.adUnitID = "ca-app-pub-2264605657544505/4403882708"
  adBanner.rootViewController = self
  adBanner.delegate = self
  adBanner.load(request)
  }
  func adViewDidReceiveAd(_ bannerView: GADBannerView) {
    print("Banner 1 loaded successfully")
    let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
    bannerView.transform = translateTransform
    UIView.animate(withDuration: 0.5) {
      bannerView.transform = CGAffineTransform.identity
    }
  }
  
  @objc func doneButtonAction(sender: AnyObject) {
    self.view.endEditing(true)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK:- currency
  func currencyFormatter(input: Double) -> String {
    let formatter = NumberFormatter()
    formatter.currencyCode = "GBP"
    formatter.currencySymbol = "£"
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .currency
    return formatter.string(from: NSNumber(value: input))!
  }
  
  
  //MARK:- buttons
  @IBAction func calculations(_ sender: UIButton) {
    autoCompleteFields()
    defaultFieldsForDays()
    grossIncomeCalc()
    vatOwedToHMRCCalc()
    corporationTaxCalc()
    netProfitCalc()
    dividendCalc()
    self.view.endEditing(true)
    sender.pulsate()
    }

  @IBAction func reset(_ sender: UIButton) {
    print("reset tapped in limited")
    daysTotalLabel.text = String("253")
    rateLabel.text = String("")
    expenseLabel.text = String("")
    annualLeaveLabel.text = String("0")
    salaryLabel.text = String("")
    dividendLabel.text = String("")
        IncomeResultLabel.text = String("")
        vatToHMRCResultLabel.text = String("")
        corpTaxResultLabel.text = String("")
        netProfitResultLabel.text = String("")
        dividendResultLabel.text = String("")
    grossIncome = 0
    vatOwedToHMRC = 0
    corporationTax = 0
    companyNetProfit = 0
    sender.pulsate()
  }
  
  //MARK:- alerts
  func autoCompleteFields() {
  //var text = [rateLabel.text, annualLeaveLabel.text, expenseLabel.text, salaryLabel.text, dividendLabel.text]
    if rateLabel.text?.isEmpty == true {
      rateLabel.text = "0.00"
    }
    if annualLeaveLabel.text?.isEmpty == true {
      annualLeaveLabel.text = "0"
    }
    if expenseLabel.text?.isEmpty == true {
      expenseLabel.text = "0.00"
    }
    if salaryLabel.text?.isEmpty == true {
      salaryLabel.text = "0.00"
    } 
    if dividendLabel.text?.isEmpty == true {
      dividendLabel.text = "0.00"
    } else {
      return
    }
  }
  
  func defaultFieldsForDays() {
    if (daysTotalLabel.text?.isEmpty ?? true)
      {
        let message = "Default billable days (253) are used for these calculations"
        let title: String = "Billable days section is empty"
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Try Again", style: .default, handler: { action in return
        })
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
  }
  
  func alertMaxDays() {
    daysTotalLabel.text = ""
    let message = ""
    let title: String = "You can not exceed the maximum possible days (366)"
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Try Again", style: .default, handler: { action in return
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  func alertMaxDaysofAnnualLeave() {
    annualLeaveLabel.text = ""
    let message = ""
    let title: String = "The number of annual leave days cannot exceed the maximum billable days"
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let action = UIAlertAction(title: "Try Again", style: .default, handler: { action in return
    })
    alert.addAction(action)
    present(alert, animated: true, completion: nil)
  }
  
  func toolBar() {
    // init toolbar
    let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
    //create left side empty space so that done button set on right side
    let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
    let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
    toolbar.setItems([flexSpace, doneBtn], animated: false)
    toolbar.sizeToFit()
    //setting toolbar as inputAccessoryView
    self.daysTotalLabel.inputAccessoryView = toolbar
    self.rateLabel.inputAccessoryView = toolbar
    self.annualLeaveLabel.inputAccessoryView = toolbar
    self.expenseLabel.inputAccessoryView = toolbar
    self.salaryLabel.inputAccessoryView = toolbar
    self.dividendLabel.inputAccessoryView = toolbar
  }
  

  //MARK:- text field keyboard
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
    }
  
  
}
