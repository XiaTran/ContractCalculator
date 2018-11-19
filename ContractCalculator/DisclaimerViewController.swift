//
//  DisclaimerViewController.swift
//  ContractCalculator
//
//  Created by Xia Tran on 27/04/2018.
//  Copyright © 2018 Xia Tran. All rights reserved.
//

import UIKit
import GoogleMobileAds

class DisclaimerViewController: UITableViewController, GADBannerViewDelegate {
  
  @IBOutlet weak var adBanner: GADBannerView!
  
    override func viewDidLoad() {
        super.viewDidLoad()

        adBannerInfo()
      adViewDidReceiveAd(adBanner)
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
    print("Banner 3 loaded successfully")
    let translateTransform = CGAffineTransform(translationX: 0, y: -bannerView.bounds.size.height)
    bannerView.transform = translateTransform
    UIView.animate(withDuration: 0.5) {
      bannerView.transform = CGAffineTransform.identity
    }
  }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
      
}
