//
//  PersonalEarningsViewController.swift
//  ContractCalculator
//
//  Created by Xia Tran on 19/04/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit

class PersonalEarningsViewController: UIViewController, UITextFieldDelegate {

  
  @IBOutlet weak var salaryView: UIView!
  @IBOutlet weak var dividendView: UIView!
  @IBOutlet weak var taxView: UIView!
  @IBOutlet weak var summaryView: UIView!
  
  
  @IBOutlet weak var salaryLabel: UITextField!
  @IBOutlet weak var personalAllowanceLabel: UITextField!
  @IBOutlet weak var basicRateLabel: UITextField!
  @IBOutlet weak var higherRateLabel: UITextField!
  @IBOutlet weak var AllowanceHolderLabel: UITextField!
  @IBOutlet weak var firstSetHolderLabel: UITextField!
  @IBOutlet weak var secondSetHolderLabel: UITextField!
  
  @IBOutlet weak var dividendTotalLabel: UITextField!
  @IBOutlet weak var dividendAt0Label: UITextField!
  @IBOutlet weak var dividendAt75Label: UITextField!
  @IBOutlet weak var dividendAt325Label: UITextField!
  
  @IBOutlet weak var salaryTaxLabel: UITextField!
  @IBOutlet weak var salaryBRTaxLabel: UITextField!
  @IBOutlet weak var salaryHRTaxLabel: UITextField!
  @IBOutlet weak var niTaxLabel: UITextField!
  @IBOutlet weak var firstNITaxLabel: UITextField!
  @IBOutlet weak var secondNITaxLabel: UITextField!
  @IBOutlet weak var dividendTaxLabel: UITextField!
  @IBOutlet weak var dividendAt75TaxLabel: UITextField!
  @IBOutlet weak var dividendAt325TaxLabel: UITextField!
  
  @IBOutlet weak var annualTakeHomeLabel: UITextField!
  @IBOutlet weak var monthlyTakeHomeLabel: UITextField!
  @IBOutlet weak var weeklyTakeHomeLabel: UITextField!
  
  var salaryTotal: Double = 0
  var salaryAfterAllowance: Double = 0
  var salaryAfterBasicRate: Double = 0
  var salaryAfterHigherRate: Double = 0
  
  var allowanceNI: Double = 0
  var firstSetNI: Double = 0
  var secondSetNI: Double = 0
  
  var totalDividend: Double = 0
  var dividendAt0: Double = 0
  var dividendAt75: Double = 0
  var dividendAt325: Double = 0
  
  var salaryIncomeTax: Double = 0
  var natInsuranceTax: Double = 0
  var dividendTax: Double = 0
  
  //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        self.salaryLabel.delegate = self
        self.dividendTotalLabel.delegate = self
      
      salaryView.layer.borderColor = UIColor.darkGray.cgColor
      dividendView.layer.borderColor = UIColor.darkGray.cgColor
      taxView.layer.borderColor = UIColor.darkGray.cgColor
      summaryView.layer.borderColor = UIColor.darkGray.cgColor
      
     // init toolbar
      let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
      //create left side empty space so that done button set on right side
      let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
      let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonAction))
      toolbar.setItems([flexSpace, doneBtn], animated: false)
      toolbar.sizeToFit()
      //setting toolbar as inputAccessoryView
      self.salaryLabel.inputAccessoryView = toolbar
      self.dividendTotalLabel.inputAccessoryView = toolbar
  }
  @objc func doneButtonAction(sender: AnyObject) {
    self.view.endEditing(true)
  }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
  //MARK:- salary and dividend calculations
  
  
  @IBAction func salaryCalculations(_ sender: UITextField) {
    resetSalary()
    salaryRateCalc()
    salaryNICalc()
    salaryIncomeTaxCalc()
    natInsuranceCalc()
    summaryCalcs()
  }
    
  func salaryRateCalc() {
    guard let totalSalary = Double(salaryLabel.text!)
      else {
        salaryLabel.text = ""
        return
    }
    if totalSalary >= 11850 {
      salaryAfterAllowance = totalSalary - 11850
      personalAllowanceLabel.text = "£11,850.00"
    } else {
      personalAllowanceLabel.text = currencyFormatter(input: totalSalary)
      basicRateLabel.text = "0.00"
      higherRateLabel.text = "0.00"
    }
    if salaryAfterAllowance >= 34500 {
      salaryAfterBasicRate = salaryAfterAllowance - 34500
      basicRateLabel.text = "£34,500.00"
    } else {
      basicRateLabel.text = currencyFormatter(input: salaryAfterAllowance)
      higherRateLabel.text = "0.00"
    }
      higherRateLabel.text = currencyFormatter(input: salaryAfterBasicRate)
    salaryTotal = totalSalary
  }
  
  func salaryNICalc() {
    guard let totalSalary = Double(salaryLabel.text!)
      else {
        salaryLabel.text = ""
        return
    }
    if totalSalary == 0 {
      salaryAfterAllowance = 0
      salaryAfterBasicRate = 0
      salaryAfterHigherRate = 0
    } else if
     totalSalary >= 8424 {
      allowanceNI = totalSalary - 8424
      AllowanceHolderLabel.text = "£8,424.00"
    } else {
      AllowanceHolderLabel.text = currencyFormatter(input: totalSalary)
      firstSetHolderLabel.text = "0.00"
      secondSetHolderLabel.text = "0.00"
    }
    if allowanceNI >= 37960 {
      firstSetNI = allowanceNI - 37960
      firstSetHolderLabel.text = "£37,960.00"
    } else {
      firstSetHolderLabel.text = currencyFormatter(input: allowanceNI)
      secondSetHolderLabel.text = "0.00"
    }
    secondSetHolderLabel.text = currencyFormatter(input: firstSetNI)
  }
  
  func resetSalary() {
      personalAllowanceLabel.text = "0.00"
      basicRateLabel.text = "0.00"
      higherRateLabel.text = "0.00"
      AllowanceHolderLabel.text = "0.00"
      firstSetHolderLabel.text = "0.00"
      secondSetHolderLabel.text = "0.00"
    salaryTotal = 0
    salaryAfterAllowance = 0
    salaryAfterBasicRate = 0
    salaryAfterHigherRate = 0
    allowanceNI = 0
    firstSetNI = 0
    secondSetNI = 0
  }
  
  @IBAction func dividendTotalCalc(_ sender: UITextField) {
    resetDividend()
    dividendCalc()
    dividendTaxCalc()
    summaryCalcs()
  }
  
  func dividendCalc() {
    guard var dividendTotal = Double(dividendTotalLabel.text!)
      else {
        dividendTotalLabel.text = ""
        return
    }
    if dividendTotal == 0 {
      totalDividend = 0
      dividendAt0 = 0
      dividendAt75 = 0
      dividendAt325 = 0
      dividendTotal = 0
    } else
      if dividendTotal >= 2000 {
        dividendAt0 = dividendTotal - 2000
        dividendAt0Label.text = "£2,000.00"
      } else {
        dividendAt0Label.text = currencyFormatter(input: dividendTotal)
        dividendAt0 = 0
        dividendAt75Label.text = "0.00"
        dividendAt325Label.text = "0.00"
    }
    if dividendAt0 >= 32500 {
      dividendAt75 = dividendAt0 - 32500
      dividendAt75Label.text = "£32,500.00"
    } else {
      dividendAt75Label.text = currencyFormatter(input: dividendAt0)
      dividendAt325Label.text = "0.00"
    }
    dividendAt325Label.text = currencyFormatter(input: dividendAt75)
    totalDividend = dividendTotal
  }
  
  
  func resetDividend() {
    dividendAt0Label.text = "0.00"
    dividendAt75Label.text = "0.00"
    dividendAt325Label.text = "0.00"
   totalDividend = 0
    dividendAt0 = 0
    dividendAt75 = 0
    dividendAt325 = 0
    
  }
  //MARK:- Tax Calculations
  
  func salaryIncomeTaxCalc() {
    var salaryBRTax: Double = 0
    var salaryHRTax: Double = 0
  
      if salaryAfterAllowance >= 34500 {
        salaryBRTax = 34500 * 0.2
      } else {
        salaryBRTax = salaryAfterAllowance * 0.2
    }
    salaryHRTax = salaryAfterBasicRate * 0.4
    
    salaryIncomeTax = salaryBRTax + salaryHRTax
        salaryBRTaxLabel.text = currencyFormatter(input: salaryBRTax)
        salaryHRTaxLabel.text = currencyFormatter(input: salaryHRTax)
        salaryTaxLabel.text = currencyFormatter(input: salaryIncomeTax)
  }
  
  func natInsuranceCalc() {
    var natInsuranceFirstSet: Double = 0
    var natInsuranceSecondSet: Double = 0
    
    if allowanceNI >= 37960 {
      natInsuranceFirstSet = 37960 * 0.12
    } else {
      natInsuranceFirstSet = allowanceNI * 0.12
    }
    natInsuranceSecondSet = firstSetNI * 0.02
    
    natInsuranceTax = natInsuranceFirstSet + natInsuranceSecondSet
    firstNITaxLabel.text = currencyFormatter(input: natInsuranceFirstSet)
    secondNITaxLabel.text = currencyFormatter(input: natInsuranceSecondSet)
    niTaxLabel.text = currencyFormatter(input: natInsuranceTax)
  }
  
  func dividendTaxCalc() {

    var dividendTaxAt75: Double = 0
    var dividendTaxAt325: Double = 0
    
    if dividendAt0 >= 32500 {
      dividendTaxAt75 = 32500 * 0.075
    } else {
      dividendTaxAt75 = dividendAt0 * 0.075
    }
    dividendTaxAt325 = dividendAt75 * 0.325
    
    dividendTax = dividendTaxAt75 + dividendTaxAt325
    dividendAt75TaxLabel.text = currencyFormatter(input: dividendTaxAt75)
    dividendAt325TaxLabel.text = currencyFormatter(input: dividendTaxAt325)
    dividendTaxLabel.text = currencyFormatter(input: dividendTax)
  }
  
  func summaryCalcs() {

    var annualTakeHome: Double = 0
    var monthlyTakeHome: Double = 0
    var weeklyTakeHome: Double = 0
    
      annualTakeHome = (salaryTotal + totalDividend) - salaryIncomeTax - natInsuranceTax - dividendTax
      monthlyTakeHome = annualTakeHome / 12
      weeklyTakeHome = annualTakeHome / 52
    
    annualTakeHomeLabel.text = currencyFormatter(input: annualTakeHome)
    monthlyTakeHomeLabel.text = currencyFormatter(input: monthlyTakeHome)
    weeklyTakeHomeLabel.text = currencyFormatter(input: weeklyTakeHome)
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
  
  @IBAction func resetButton(_ sender: Any) {
    salaryLabel.text = "0"
    dividendTotalLabel.text = "0"
    resetSalary()
    resetDividend()
    salaryTaxLabel.text = "£0.00"
    salaryBRTaxLabel.text = "£0.00"
    salaryHRTaxLabel.text = "£0.00"
    niTaxLabel.text = "£0.00"
    firstNITaxLabel.text = "£0.00"
    secondNITaxLabel.text = "£0.00"
    dividendTaxLabel.text = "£0.00"
    dividendAt75TaxLabel.text = "£0.00"
    dividendAt325TaxLabel.text = "£0.00"
    annualTakeHomeLabel.text = "£0.00"
    monthlyTakeHomeLabel.text = "£0.00"
    weeklyTakeHomeLabel.text = "£0.00"
  }

  //MARK:-
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   self.view.endEditing(true)
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  

}
