//
//  PersonalEarningsViewController.swift
//  ContractCalculator
//
//  Created by Xia Tran on 19/04/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class PersonalEarningsViewController: UITableViewController, UITextFieldDelegate, GADBannerViewDelegate {

  @IBOutlet weak var adBanner: GADBannerView!

  
  @IBOutlet weak var salaryLabel: UITextField!
  @IBOutlet weak var salaryUntaxedLabel: UITextField!
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
      
      adBannerInfo()
      adViewDidReceiveAd(adBanner)
      toolBar()
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
    print("Banner 2 loaded successfully")
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
  
  
  //MARK:- salary and dividend calculations
  @IBAction func salaryCalculations(_ sender: UITextField) {
    resetSalary()
    salaryRateCalc()
    salaryNICalc()
    salaryIncomeTaxCalc()
    natInsuranceCalc()
    summaryCalcs()
  }
    
 
  func resetSalary() {
      salaryUntaxedLabel.text = ""
      basicRateLabel.text = ""
      higherRateLabel.text = ""
      AllowanceHolderLabel.text = ""
      firstSetHolderLabel.text = ""
      secondSetHolderLabel.text = ""
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
  
  func resetDividend() {
    dividendAt0Label.text = ""
    dividendAt75Label.text = ""
    dividendAt325Label.text = ""
   totalDividend = 0
    dividendAt0 = 0
    dividendAt75 = 0
    dividendAt325 = 0
    
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
  
  @IBAction func resetButton(_ sender: UIButton) {
    print("reset tapped in personal")
    salaryLabel.text = ""
    dividendTotalLabel.text = ""
    resetSalary()
    resetDividend()
    salaryTaxLabel.text = ""
    salaryBRTaxLabel.text = ""
    salaryHRTaxLabel.text = ""
    niTaxLabel.text = ""
    firstNITaxLabel.text = ""
    secondNITaxLabel.text = ""
    dividendTaxLabel.text = ""
    dividendAt75TaxLabel.text = ""
    dividendAt325TaxLabel.text = ""
    annualTakeHomeLabel.text = ""
    monthlyTakeHomeLabel.text = ""
    weeklyTakeHomeLabel.text = ""
    sender.pulsate()
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
    self.salaryLabel.inputAccessoryView = toolbar
    self.dividendTotalLabel.inputAccessoryView = toolbar
  }

  
  //MARK:- textfield
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
   self.view.endEditing(true)
    return true
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    self.view.endEditing(true)
  }
  

}
