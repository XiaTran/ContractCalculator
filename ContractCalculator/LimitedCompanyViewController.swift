//
//  ViewController.swift
//  ContractCalculator
//
//  Created by Xia Tran on 16/04/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit

class LimitedCompanyViewController: UIViewController,  UITextFieldDelegate {

  
  @IBOutlet weak var scrollview: UIScrollView!
  
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
  
  //MARK:- viewDidLoad
  override func viewDidLoad() {
    super.viewDidLoad()
    
    daysTotalLabel.delegate = self
    rateLabel.delegate = self
    annualLeaveLabel.delegate = self
    expenseLabel.delegate = self
    salaryLabel.delegate = self
    dividendLabel.delegate = self
    

    
//    calcButton.layer.shadowColor = UIColor.red.cgColor
//    calcButton.layer.shadowRadius = 50
//    calcButton.layer.shadowOpacity = 1
//    calcButton.layer.shadowOffset = CGSize(width: 0, height: 0)
  
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
  @objc func doneButtonAction(sender: AnyObject) {
    self.view.endEditing(true)
  }
  



  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }

  //MARK:- calculations
//  func maxDays() { //cap max days that can be entered
//    let numOfDays = Int(daysTotalLabel.text!)
//    if numOfDays == nil {
//      daysTotalLabel.text = "enter days"
//      return
//    } else
//    if numOfDays! <= 366 {
//       return
//    } else {
//       daysTotalLabel.text = ""
//      return
//    }
//    }
  
  func grossIncomeCalc() {
  guard let numOfDays = Double(daysTotalLabel.text!)
    else {
      daysTotalLabel.text = ""
      return
    }
  guard let dayRate = Double(rateLabel.text!)
    else {
      rateLabel.text = ""
      return
    }
  guard let annualLeave = Double(annualLeaveLabel.text!)
    else {
     annualLeaveLabel.text = ""
      return
    }
    if numOfDays <= 366 {
  let grossEarnings = Double(((numOfDays - annualLeave) * dayRate) * 1.2)
    IncomeResultLabel.text = currencyFormatter(input: grossEarnings)
    grossIncome = grossEarnings
      print("check")
    } else {
      daysTotalLabel.text = ""
      let message = ""
      let title: String = "You can not exceed the maximum possible days (366)"
      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let action = UIAlertAction(title: "Try Again", style: .default, handler: { action in return
      })
      alert.addAction(action)
      present(alert, animated: true, completion: nil)
    }
      return
    }
  
  
  func vatOwedToHMRCCalc() {
    let vatOwed : Double
    vatOwed = grossIncome * 0.155
    if grossIncome == 0 {
      vatToHMRCResultLabel.text = ""
      print("if empty")
      return
    } else {
    vatToHMRCResultLabel.text = currencyFormatter(input: vatOwed)
      print("if something")
    }
    vatOwedToHMRC = vatOwed
  }
  
  func corporationTaxCalc() {
    guard let expense = Double(expenseLabel.text!)
      else {
        expenseLabel.text = ""
        return
    }
    guard let salary = Double(salaryLabel.text!)
      else {
        salaryLabel.text = ""
        return
    }
    let corpTax = Double((grossIncome - vatOwedToHMRC - expense - salary) * 0.19)
    corpTaxResultLabel.text = currencyFormatter(input: corpTax)
    corporationTax = corpTax
  }
  
  func netProfitCalc() {
    guard let expense = Double(expenseLabel.text!)
      else {
        expenseLabel.text = ""
        return
    }
    guard let salary = Double(salaryLabel.text!)
      else {
        salaryLabel.text = ""
        return
    }
    let netProfit = Double(grossIncome - vatOwedToHMRC - corporationTax - expense - salary)
    netProfitResultLabel.text = currencyFormatter(input: netProfit)
    companyNetProfit = netProfit
  }
  
  func dividendCalc() {
    guard let dividend = Double(dividendLabel.text!)
      else {
        dividendLabel.text = ""
        return
    }
    let leftAfterDividends = (companyNetProfit - dividend)
    dividendResultLabel.text = currencyFormatter(input: leftAfterDividends)
    
  }
  //MARK:- currency
  
  func currencyFormatter(input: Double) -> String {
    let formatter = NumberFormatter()
    formatter.currencyCode = "GBP"
    formatter.currencySymbol = "£"
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .currencyAccounting
    return formatter.string(from: NSNumber(value: input))!
  }
  
  //MARK:- buttons
  @IBAction func calculations(_ sender: UIButton) { //work out
    completeFields()
    grossIncomeCalc()
    vatOwedToHMRCCalc()
    corporationTaxCalc()
    netProfitCalc()
    dividendCalc()
    self.view.endEditing(true)
    sender.pulsate()
    }


  func completeFields() {
    if (daysTotalLabel.text?.isEmpty ?? true) ||
    (rateLabel.text?.isEmpty ?? true) ||
    (annualLeaveLabel.text?.isEmpty ?? true) ||
    (expenseLabel.text?.isEmpty ?? true) ||
    (salaryLabel.text?.isEmpty ?? true) ||
    (dividendLabel.text?.isEmpty ?? true)
    {
  let message = ""
      let title: String = "Please complete all fields before calculating"
  let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
  let action = UIAlertAction(title: "Try Again", style: .default, handler: { action in return
  })
  alert.addAction(action)
  present(alert, animated: true, completion: nil)
  }
  }
  
  @IBAction func reset(_ sender: UIButton) {
    daysTotalLabel.text = String("")
    rateLabel.text = String("")
    expenseLabel.text = String("")
    annualLeaveLabel.text = String("")
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
  
  //MARK:- text field keyboard
  
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }
  
  func textFieldDidBeginEditing(_ textField: UITextField) {
    switch textField.tag {
    case 0...3:
      print("no movement")
    default:
    scrollview.setContentOffset(CGPoint(x: 0 , y: 100), animated: true)
    }
  }
  
  func textFieldDidEndEditing(_ textField: UITextField) {
    scrollview.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
  }
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
      self.view.endEditing(true)
    }
}
//MARK:- button
extension UIButton {
  
  func pulsate() {
    let pulse = CASpringAnimation(keyPath: "transform.scale")
    pulse.duration = 0.2
    pulse.fromValue = 0.95
    pulse.toValue = 1.0
    pulse.autoreverses = true
    pulse.repeatCount = 1
    pulse.initialVelocity = 0.5
    pulse.damping = 1.0
    
    layer.add(pulse, forKey: nil)
  }
  
}
