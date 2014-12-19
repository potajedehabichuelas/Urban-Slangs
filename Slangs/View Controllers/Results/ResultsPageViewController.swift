//
//  ResultsViewController.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 17/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class ResultsPageViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!;
    
    
    @IBOutlet weak var defTextView: UITextView!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    var definition : Definition = Definition();
    
    var pageIndex : Int = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set all the information
        
        //Word
        self.wordLabel.text = self.definition.word;
        //Definition
        self.defTextView.text = self.definition.definition;
        //Example
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if pageIndex % 2 != 0 {
            //If image is odd then flip it so it feels like the bg is continuous
            let srcImage = self.backgroundImageView.image!
            self.backgroundImageView.image = UIImage(CGImage: srcImage.CGImage, scale: srcImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
