//
//  SideMenuViewController.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 29/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController {
    
    @IBOutlet weak var imageViewBg: UIImageView!
    
    @IBOutlet weak var removeAdsButton: UIButton!

    @IBOutlet weak var blurView: UIView!
    
    var effectView:UIVisualEffectView = UIVisualEffectView();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Blur effect for the imagev background
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.effectView = UIVisualEffectView (effect: blur);
        self.effectView.frame = self.view.frame
        if (self.imageViewBg != nil) {
            self.view.insertSubview(effectView, aboveSubview: self.imageViewBg)
        }
    }
    
    override func viewWillLayoutSubviews() {
        //Update effect frame
        self.effectView.frame = self.view.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeAds(sender: AnyObject) {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
