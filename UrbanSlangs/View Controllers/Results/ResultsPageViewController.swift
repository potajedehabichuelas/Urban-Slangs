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
    
    @IBOutlet weak var relatedTagsTextView: UITextView!
    
    
    //Stars outlet collection
    
    @IBOutlet var ratingStarsArr: [UIImageView]!
    
    var definition : Definition = Definition();
    
    var relatedTagsArray : Array<String> = Array();
    
    var pageIndex : Int = 0;
    
    var totalPages : Int = 0;
    
    var fullScreenAd : GADInterstitial = GADInterstitial();
    
    //For new requests
    var queryResult : QueryResult?;
    
    //Constriants
    @IBOutlet weak var defTvHeightConstriant: NSLayoutConstraint!
    @IBOutlet weak var relatedTvHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var examplesTvHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Gesture tapper for the textview to recognize which word was tapped
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "relatedTagTapped:")
        self.relatedTagsTextView.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if pageIndex % 2 != 0 {
            //If image is odd then flip it so it feels like the bg is continuous
            let srcImage = self.backgroundImageView.image!
            self.backgroundImageView.image = UIImage(CGImage: srcImage.CGImage, scale: srcImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        self.setUpPageInformation()
        
        //Recreate full screen ad (object can be used only once)
        self.fullScreenAd = AdMobHelper.createAndLoadFullScreenAd();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.backButton.hidden = false;
        self.backButton.alpha = 0.0;
        UIView.animateWithDuration(1.0, delay: 0.0, options: .CurveEaseOut, animations: {
            self.backButton.alpha = 1.0;
            }, completion:nil)
    }
    
    func setUpPageInformation() {
        //Set all the information
        self.setUpRating();
        //Word
        self.wordLabel.text = self.definition.word;
        //Definition
        self.defTextView.text = self.definition.definition;
        //Example
        self.examplesTextView.text = self.definition.example;
        //Tags
        self.setTagsText()
        
        //Call it before using contentsize
        self.view.layoutIfNeeded()
        
        //Force textview to calculate its content
        self.defTextView.sizeToFit();
        self.examplesTextView.sizeToFit();
        
        //Call it after to resize constraints
        self.view.layoutIfNeeded()
        
        //Definition number label
        self.definitionNumberLabel.text = "Definition \(self.pageIndex + 1) / \(self.totalPages)"
    
    }
    
    func setTagsText()
    {
        var tagString : NSMutableAttributedString = NSMutableAttributedString(string: "");
        
        for tag in self.relatedTagsArray {
            var font : UIFont? =  UIFont(name: "AvenirNext-Bold", size: 20.0)
            var attrs = ["tagWord": tag, NSFontAttributeName: font!, NSForegroundColorAttributeName : UIColor.darkGrayColor()]
            var attString = NSMutableAttributedString(string: tag.uppercaseString, attributes: attrs)
            
            tagString.appendAttributedString(attString)
            
            if tag != self.relatedTagsArray.last {
                //Add " - "
                var otherAtts = [NSFontAttributeName: font!, NSForegroundColorAttributeName : UIColor.blackColor()]
                var separatorString = NSMutableAttributedString(string: " - ", attributes: otherAtts)
                
                tagString.appendAttributedString(separatorString)
            }
        }
        
        self.relatedTagsTextView.attributedText = tagString;
        self.relatedTagsTextView.selectable = false;
    }
    
    func relatedTagTapped(recognizer: UITapGestureRecognizer)
    {

        var layoutManager = self.relatedTagsTextView.layoutManager
        var textView = self.relatedTagsTextView;
        var location: CGPoint = recognizer.locationInView(textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        var charIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if charIndex < textView.textStorage.length {
            var range = NSRange(location: 0, length: 0)
            
            let tagVal2 = textView.attributedText?.attribute("tagWord", atIndex: charIndex, effectiveRange: &range) as? NSString
            if let tagVal = textView.attributedText?.attribute("tagWord", atIndex: charIndex, effectiveRange: &range) as? NSString {
                println("Tag value: \(tagVal)")
                println("charIndex: \(charIndex)")
                println("range.location = \(range.location)")
                println("range.length = \(range.length)")
                let tappedPhrase = (textView.attributedText.string as NSString).substringWithRange(range)
                println("tapped phrase: \(tappedPhrase)")
                var mutableText = textView.attributedText.mutableCopy() as NSMutableAttributedString
                mutableText.addAttributes([NSForegroundColorAttributeName: UIColor.blueColor()], range: range)
                textView.attributedText = mutableText
                
                //Request new word
                self.requestTagWordInformation(tappedPhrase);
            }

        }


    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        UIView.animateWithDuration(0.2, delay: 0.0, options: .CurveEaseOut, animations: {
            self.backButton.alpha = 0.0;
            }, completion:{ finished in
                self.backButton.hidden = true;
        })
    }
    
    override func viewWillLayoutSubviews() {
        
        //Update the constraints for the text view so it sizes to its content
        self.defTvHeightConstriant.constant = self.defTextView.contentSize.height;        
        self.examplesTvHeightConstraint.constant = self.examplesTextView.contentSize.height;
        self.relatedTvHeightConstraint.constant = self.relatedTagsTextView.contentSize.height;
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func backToSearch(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true);
    }

    func requestTagWordInformation(word : String)
    {
        //Show progress indicator
        MBProgressHUD.showHUDAddedTo(self.view, animated: true);
        //Disable editing for a bit
        self.view.userInteractionEnabled = false;
        
        //Launch new request for the tapped word
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            //Remove spaces and put +
            var searchWord : String = word.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
            self.queryResult = SlangNet.sharedInstance.requestWordInformation(searchWord);
            
            println("Request completed");
        
            dispatch_async(dispatch_get_main_queue()) {
                self.view.userInteractionEnabled = true;
                //Hide progress indicator
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if (self.queryResult != nil && self.queryResult?.definitions?.count > 0) {
                    
                    let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultManagerVC") as ResultsManagerViewController
                    secondViewController.results = self.queryResult!;
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                    
                    //Show ad and after that perform segue
                    self.fullScreenAd.presentFromRootViewController(self.navigationController);
                    
                } else {
                    //Error!
                    if self.queryResult?.definitions?.count == 0 {
                        //No results
                        println("no results")
                    } else {
                        //Error
                        println("error")
                        //TSMessage
                        TSMessage.showNotificationWithTitle("Connection failed", subtitle: "Check your internet connection!", type:TSMessageNotificationType.Error);
                    }
                    
                }
            }
        }
    
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

}
