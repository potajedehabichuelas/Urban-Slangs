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
    
    @IBOutlet weak var examplesTextView: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var definitionNumberLabel: UILabel!
    
    //Stars outlet collection
    
    @IBOutlet var ratingStarsArr: [UIImageView]!
    
    var definition : Definition = Definition();
    
    var pageIndex : Int = 0;
    
    var totalPages : Int = 0;
    
    //Constriants
    @IBOutlet weak var defTvHeightConstriant: NSLayoutConstraint!
    
    @IBOutlet weak var examplesTvHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Set all the information
        self.setUpRating();
        //Word
        self.wordLabel.text = self.definition.word;
        //Definition
        self.defTextView.text = self.definition.definition;
        //Example
        self.examplesTextView.text = self.definition.example;
        //Tags
        
        //Definition number label
        self.definitionNumberLabel.text = "Definition \(self.pageIndex + 1) / \(self.totalPages)"
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if pageIndex % 2 != 0 {
            //If image is odd then flip it so it feels like the bg is continuous
            let srcImage = self.backgroundImageView.image!
            self.backgroundImageView.image = UIImage(CGImage: srcImage.CGImage, scale: srcImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        if self.pageIndex == 0 {
            self.backButton.hidden = false;
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        
        //Update the constraints for the text view so it sizes to its content
        self.defTvHeightConstriant.constant = self.defTextView.contentSize.height;
        
        self.examplesTvHeightConstraint.constant = self.examplesTextView.contentSize.height;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToSearch(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }

    
    func setUpRating() {
        
        var ratingValue : Double = Double(self.definition.thumbsUp) /  (Double(self.definition.thumbsDown) + Double(self.definition.thumbsUp));
        
        //Convert to scale 0 to 5
        ratingValue *= 5;
        for star : UIImageView  in self.ratingStarsArr {
            
            if ratingValue > Double(star.tag){
                star.image = UIImage(named: "fullStar.png")
            } else if (ratingValue - 0.5) > Double(star.tag - 1) {
                star.image = UIImage(named: "halfStar.png")
            } else {
                star.image = UIImage(named: "noStar.png")
            }
        }
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
