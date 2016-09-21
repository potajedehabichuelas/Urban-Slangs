//
//  AdMobHelper.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 27/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class AdMobHelper: NSObject {
    class func createAndLoadInterstitial(_ delegate : GADInterstitialDelegate) -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-7267181828972563/7939644330")
        interstitial.delegate = delegate;
        interstitial.load(GADRequest())
        
        return interstitial
    }
}
