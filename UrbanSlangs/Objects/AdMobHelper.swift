//
//  AdMobHelper.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 27/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class AdMobHelper: NSObject {
   
    class func createAndLoadFullScreenAd() -> GADInterstitial{
        var ad : GADInterstitial = GADInterstitial();
        
        //Interstitial ad
        ad.adUnitID = "ca-app-pub-7267181828972563/7939644330"
        var fullAdrequest:GADRequest = GADRequest()
        ad.loadRequest(fullAdrequest)
        return ad;
    }
}
