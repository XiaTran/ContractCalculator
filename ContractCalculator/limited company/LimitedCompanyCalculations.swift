//
//  LimitedCompanyCalculations.swift
//  ContractCalculator
//
//  Created by Xia Tran on 26/09/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import Foundation

extension LimitedCompanyViewController {
  
  func grossIncomeCalc() {
    guard let numOfDays = Double(daysTotalLabel.text!)
      else {
        daysTotalLabel.text = "253"
        return
    }
    guard let dayRate = Double(rateLabel.text!)
      else {
        rateLabel.text = "0.00"
        return
    }
    guard let annualLeave = Double(annualLeaveLabel.text!)
      else {
        annualLeaveLabel.text = "0"
        return
    }
    if numOfDays <= 366 {
      let grossEarnings = Double(((numOfDays - annualLeave) * dayRate) * 1.2)
      IncomeResultLabel.text = currencyFormatter(input: grossEarnings)
      grossIncome = grossEarnings
      print("check")
    } else {
      alertMaxDays()
    }
    if annualLeave >= numOfDays {
      alertMaxDaysofAnnualLeave()
    }
    return
  }
  
  func vatOwedToHMRCCalc() {
    let vatOwed : Double
    vatOwed = grossIncome * 0.155
      if grossIncome == 0 {
        vatToHMRCResultLabel.text = "£0.00"
        corpTaxResultLabel.text = "£0.00"
        netProfitResultLabel.text = "£0.00"
        dividendResultLabel.text = "£0.00"
        print("if income is empty")
        return
      } else {
        vatToHMRCResultLabel.text = currencyFormatter(input: vatOwed)
        print("if something is entered")
      }
    vatOwedToHMRC = vatOwed
  }
  
  func corporationTaxCalc() {
    guard let expense = Double(expenseLabel.text!)
      else {
        expenseLabel.text = "0.00"
        return
    }
    guard let salary = Double(salaryLabel.text!)
      else {
        salaryLabel.text = "0.00"
        return
    }
    let corpTax = Double((grossIncome - vatOwedToHMRC - expense - salary) * 0.19)
    corpTaxResultLabel.text = currencyFormatter(input: corpTax)
    corporationTax = corpTax
  }
  
  func netProfitCalc() {
    guard let expense = Double(expenseLabel.text!)
      else {
        expenseLabel.text = "0.00"
        return
    }
    guard let salary = Double(salaryLabel.text!)
      else {
        salaryLabel.text = "0.00"
        return
    }
    let netProfit = Double(grossIncome - vatOwedToHMRC - corporationTax - expense - salary)
    netProfitResultLabel.text = currencyFormatter(input: netProfit)
    companyNetProfit = netProfit
  }
  
  func dividendCalc() {
    guard let dividend = Double(dividendLabel.text!)
      else {
        dividendLabel.text = "0.00"
        return
    }
    let leftAfterDividends = (companyNetProfit - dividend)
    dividendResultLabel.text = currencyFormatter(input: leftAfterDividends)
  }
  
  
}
