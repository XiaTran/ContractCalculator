//
//  PersonalEarningCalculations.swift
//  ContractCalculator
//
//  Created by Xia Tran on 26/09/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import Foundation

extension PersonalEarningsViewController {
  
  func salaryRateCalc() {
    guard let totalSalary = Double(salaryLabel.text!)
      else {
        salaryLabel.text = ""
        return
    }
    if totalSalary >= 11850 {
      salaryAfterAllowance = totalSalary - 11850
      salaryUntaxedLabel.text = "£11,850.00"
    } else {
      salaryUntaxedLabel.text = currencyFormatter(input: totalSalary)
      basicRateLabel.text = ""
      higherRateLabel.text = ""
    }
    if salaryAfterAllowance >= 34500 {
      salaryAfterBasicRate = salaryAfterAllowance - 34500
      basicRateLabel.text = "£34,500.00"
    } else {
      basicRateLabel.text = currencyFormatter(input: salaryAfterAllowance)
      higherRateLabel.text = ""
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
      firstSetHolderLabel.text = ""
      secondSetHolderLabel.text = ""
    }
    if allowanceNI >= 37960 {
      firstSetNI = allowanceNI - 37960
      firstSetHolderLabel.text = "£37,960.00"
    } else {
      firstSetHolderLabel.text = currencyFormatter(input: allowanceNI)
      secondSetHolderLabel.text = ""
    }
    secondSetHolderLabel.text = currencyFormatter(input: firstSetNI)
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
        dividendAt75Label.text = ""
        dividendAt325Label.text = ""
    }
    if dividendAt0 >= 32500 {
      dividendAt75 = dividendAt0 - 32500
      dividendAt75Label.text = "£32,500.00"
    } else {
      dividendAt75Label.text = currencyFormatter(input: dividendAt0)
      dividendAt325Label.text = ""
    }
    dividendAt325Label.text = currencyFormatter(input: dividendAt75)
    totalDividend = dividendTotal
  }
  
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
  
}
