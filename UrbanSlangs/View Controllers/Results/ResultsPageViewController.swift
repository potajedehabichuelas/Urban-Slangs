//
//  ResultsViewController.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 17/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit
import CoreData

class ResultsPageViewController: UIViewController {

    @IBOutlet weak var starredButton: UIButton!
    
    @IBOutlet weak var backgroundImageView: UIImageView!;
    
    @IBOutlet weak var defTextView: UITextView!
    
    @IBOutlet weak var examplesTextView: UITextView!
    
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var wordLabel: UILabel!
    
    @IBOutlet weak var definitionNumberLabel: UILabel!
    
    @IBOutlet weak var relatedTagsTextView: UITextView!
    
    @IBOutlet weak var relatedLabel: UILabel!
    
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
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ResultsPageViewController.relatedTagTapped(_:)))
        self.relatedTagsTextView.addGestureRecognizer(tap)
        
        //Hide related label if there are not any related tags
        if (self.relatedTagsArray.count == 0) {
            self.relatedLabel.hidden = true;
        }
        
        //Add entry to the history View
        Storage.addHistoryWordEntry(self.definition)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if pageIndex % 2 != 0 {
            //If image is odd then flip it so it feels like the bg is continuous
            let srcImage = self.backgroundImageView.image!
            self.backgroundImageView.image = UIImage(CGImage: srcImage.CGImage!, scale: srcImage.scale, orientation: UIImageOrientation.UpMirrored)
        }
        
        self.setUpPageInformation()
        
        //Recreate full screen ad (object can be used only once)
        self.fullScreenAd = AdMobHelper.createAndLoadFullScreenAd();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        
        self.backButton.hidden = false;
        self.backButton.alpha = 0.0;
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.backButton.alpha = 1.0;
            }, completion:nil)
    }
    
    @IBAction func setWordBookmarked(sender: AnyObject) {
        
        self.starredButton.selected = self.starredButton.selected ? false : true;
        if (self.starredButton.selected) {
            //Add entry
            Storage.addStarredWordEntry(self.definition);
        } else {
            //Delete entry
            Storage.removeStarredWordEntry(self.definition);
        }
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
        self.relatedTagsTextView.sizeToFit();
        
        //Call it after to resize constraints
        self.view.layoutIfNeeded()
        
        //Definition number label / if else just in case its 0 (minimun is 1 when it comes from bookmars / history
        self.definitionNumberLabel.text = "Definition \(self.pageIndex + 1) / \(self.totalPages > 0 ? self.totalPages : 1)"
        
        //Set if the word is starred
        for def in Storage.getStarredArray() {
            if (def.isEqualToDefinition(self.definition)) {
                //Mark button as enabled
                self.starredButton.selected = true;
                break;
            }
        }
    
    }
    
    func setTagsText()
    {
        let tagString : NSMutableAttributedString = NSMutableAttributedString(string: "");
        
        for tag in self.relatedTagsArray {
            let font : UIFont? =  UIFont(name: "AvenirNext-Bold", size: 20.0)
            let attrs = ["tagWord": tag, NSFontAttributeName: font!, NSForegroundColorAttributeName : UIColor.darkGrayColor()]
            let attString = NSMutableAttributedString(string: tag.uppercaseString, attributes: attrs)
            
            tagString.appendAttributedString(attString)
            
            if tag != self.relatedTagsArray.last {
                //Add " - "
                let otherAtts = [NSFontAttributeName: font!, NSForegroundColorAttributeName : UIColor.blackColor()]
                let separatorString = NSMutableAttributedString(string: " - ", attributes: otherAtts)
                
                tagString.appendAttributedString(separatorString)
            }
        }
        
        self.relatedTagsTextView.attributedText = tagString;
        self.relatedTagsTextView.selectable = false;
    }
    
    func relatedTagTapped(recognizer: UITapGestureRecognizer)
    {

        let layoutManager = self.relatedTagsTextView.layoutManager
        let textView = self.relatedTagsTextView;
        var location: CGPoint = recognizer.locationInView(textView)
        location.x -= textView.textContainerInset.left
        location.y -= textView.textContainerInset.top
        
        let charIndex = layoutManager.characterIndexForPoint(location, inTextContainer: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if charIndex < textView.textStorage.length {
            var range = NSRange(location: 0, length: 0)
            
            if let tagVal = textView.attributedText?.attribute("tagWord", atIndex: charIndex, effectiveRange: &range) as? NSString {
                print("Tag value: \(tagVal)")
                print("charIndex: \(charIndex)")
                print("range.location = \(range.location)")
                print("range.length = \(range.length)")
                let tappedPhrase = (textView.attributedText.string as NSString).substringWithRange(range)
                print("tapped phrase: \(tappedPhrase)")
                let mutableText = textView.attributedText.mutableCopy() as! NSMutableAttributedString
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
        if self.navigationController != nil {
            self.navigationController?.popViewControllerAnimated(true);
        } else {
            self.dismissViewControllerAnimated(true, completion: nil);
        }
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
            let searchWord : String = word
            self.queryResult = SlangNet.sharedInstance.requestWordInformation(searchWord);
            
            print("Request completed");
        
            dispatch_async(dispatch_get_main_queue()) {
                self.view.userInteractionEnabled = true;
                //Hide progress indicator
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if (self.queryResult != nil && self.queryResult?.definitions?.count > 0) {
                    
                    let secondViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ResultManagerVC") as! ResultsManagerViewController
                    secondViewController.results = self.queryResult!;
                    self.navigationController?.pushViewController(secondViewController, animated: true)
                    
                    //Show ad and after that perform segue
                    self.fullScreenAd.presentFromRootViewController(self.navigationController);
                    
                } else {
                    //Error!
                    if self.queryResult?.definitions?.count == 0 {
                        //No results
                        print("no results")
                    } else {
                        //Error
                        print("error")
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
