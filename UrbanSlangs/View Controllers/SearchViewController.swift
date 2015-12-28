//
//  ViewController.swift
//  Slang Dictionary
//
//  Created by Daniel Bolivar herrera on 12/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

struct SeguesID {
    static let QUERY_RESULT_SEGUE_ID : String = "QueryResultSegue"
}

private let RANDOM_BUTTON_TAG = 10;

class SearchViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var randomButton: UIButton!
    
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var fullScreenAd : GADInterstitial = GADInterstitial();
    
    var queryResult : QueryResult?;
    
    var canPerformResultSegue : Bool = false;
    
    var settingsOnScreen = false;
    var bookmarksOnScreen = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hidden status bar
        UIApplication.sharedApplication().statusBarHidden = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //Dismiss keyboard when tapping outside the view
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        //TSmessage vc
        TSMessage.setDefaultViewController(self.navigationController);
        
        //Admob thing
        self.bannerView.adUnitID = "ca-app-pub-7267181828972563/6462911130"
        self.bannerView.rootViewController = self;
        let request:GADRequest = GADRequest()
        self.bannerView.loadRequest(request)
        
        //SWRevealVc
        self.revealViewController().toggleAnimationDuration = 0.8;
        self.revealViewController().bounceBackOnOverdraw = true;
        self.revealViewController().bounceBackOnLeftOverdraw = true;
        
        //Gesture recognizers
        let swipeRight = UISwipeGestureRecognizer(target: self, action: "gestureResponder:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: "gestureResponder:")
        swipeLeft.direction = UISwipeGestureRecognizerDirection.Left
        self.view.addGestureRecognizer(swipeLeft)
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
            Int64(3.0 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            //hide disclaimer tag
            UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                self.disclaimerLabel.alpha = 0.0;
                }, completion: { finished in
            })
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.canPerformResultSegue = false;
        
        //Recreate full screen ad (object can be used only once)
        self.fullScreenAd = AdMobHelper.createAndLoadFullScreenAd();
        
    }
    @IBAction func bookmarksClicked(sender: AnyObject?) {
        
        self.revealViewController().rightRevealToggleAnimated(true);
        self.bookmarksOnScreen = self.bookmarksOnScreen ? false : true;
        self.view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureResponder(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Right) {
                if (self.bookmarksOnScreen) {
                    self.bookmarksClicked(swipeGesture);
                } else {
                    self.settingsClicked(swipeGesture);
                }
            } else if (swipeGesture.direction == UISwipeGestureRecognizerDirection.Left) {
                if (self.settingsOnScreen) {
                    self.settingsClicked(swipeGesture);
                } else {
                    self.bookmarksClicked(swipeGesture);
                }
            }
        }
    }
    
    @IBAction func settingsClicked(sender: AnyObject?) {
        self.revealViewController().revealToggleAnimated(true);
        self.settingsOnScreen = self.settingsOnScreen ? false : true;
        self.view.endEditing(true);
    }
    
    @IBAction func searchString(sender: AnyObject) {
        
        //Search for the introduced string
        
        //Hide side menu or bookmarks menu if on screen
        if self.bookmarksOnScreen {
            self.bookmarksClicked(nil);
        } else if self.settingsOnScreen {
            self.settingsClicked(nil);
        }
        
        //DisableButton
        self.searchButton.enabled = false;
        self.randomButton.enabled = false;

        //Show the activity indicator
        self.activityIndicator.alpha = 1.0;
        self.activityIndicator.hidden = false;
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.activityIndicator.alpha = 0.0;

            }, completion: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            
            if ((sender as! UIButton).tag == RANDOM_BUTTON_TAG) {
                //Random
                self.queryResult = SlangNet.sharedInstance.requestRandomWordInformation();
            } else {
                //Input string
                //Remove spaces and put +
                let searchWord : String = self.searchTextField.text!
                self.queryResult = SlangNet.sharedInstance.requestWordInformation(searchWord);
            }
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                
                //Hide the activity indicator
                UIView.animateWithDuration(0.1, delay: 0.0, options: .CurveEaseOut, animations: {
                    
                    }, completion: { finished in
                        self.activityIndicator.hidden = true;
                        //Re enable the button
                        self.searchButton.enabled = true;
                        self.randomButton.enabled = true;
                        self.dismissKeyboard()
                })
                
                print("Request completed");
                if (self.queryResult != nil && self.queryResult?.definitions?.count > 0) {
                    self.searchTextField.text = "";
                    //Go to the next screen to display results
                    self.canPerformResultSegue = true;
                    
                    self.performSegueWithIdentifier(SeguesID.QUERY_RESULT_SEGUE_ID, sender:self.searchButton);
                    
                    //Show ad and after that perform segue
                    self.fullScreenAd.presentFromRootViewController(self.navigationController);
                    
                    if self.queryResult?.resultType != QueryConstants.QUERY_RESULT_TYPE_EXACT && self.queryResult?.searchString != "random_Search" {
                        //TSMessage - //If result wasnt exact, inform the user
                        TSMessage.showNotificationWithTitle("Whooops :(", subtitle: "No results matched. But perhaps you might be interested in these!", type:TSMessageNotificationType.Warning);
                    }
                    
                } else {
                    //Error!
                    if self.queryResult?.definitions?.count == 0 {
                        //No results
                        print("no results")
                        //TSMessage
                        TSMessage.showNotificationWithTitle("Whooops :(", subtitle: "No results matched your search", type:TSMessageNotificationType.Error);
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
    
    //MARK - UITextField

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchString(self.searchButton);
        
        return true
    }

    
    //MARK - Keyboard and view editing
    
    func keyboardWillShow(notification: NSNotification)
    {
        //Lift the view up only if the device is in landscape
        if UIInterfaceOrientationIsLandscape(UIApplication.sharedApplication().statusBarOrientation) {
            
            var info = notification.userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
            
            //Get animation time
            let durationValue : Double = info[UIKeyboardAnimationDurationUserInfoKey] as! Double;
            let animationDuration : NSTimeInterval = durationValue
            
            //And the animation curve
            //let curveValue : Int = info[UIKeyboardAnimationCurveUserInfoKey] as! Int;
            
            //var animationCurve = UIViewAnimationCurve(rawValue: curveValue) // or use UIViewAnimationOptions(kbCurve << 16)  directly in the UIView animation
            
            //When we are typing the comment, move upwards the view so we can see what we are typing
            
            UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
                if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
                    self.view.frame = CGRectMake(self.view.frame.origin.x, -keyboardFrame.size.height * 0.2, self.view.frame.size.width, self.view.frame.size.height)
                } else {
                    self.view.frame = CGRectMake(self.view.frame.origin.x, -keyboardFrame.size.height * 0.5, self.view.frame.size.width, self.view.frame.size.height)
                }
            }, completion: nil)
        }
    }
    
    
    func keyboardWillHide(notification: NSNotification)
    {
        var info = notification.userInfo!
        //var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //Get animation time
        let durationValue : Double = info[UIKeyboardAnimationDurationUserInfoKey] as! Double;
        let animationDuration : NSTimeInterval = durationValue
        
        //And the animation curve
        //let curveValue : Int = info[UIKeyboardAnimationCurveUserInfoKey] as! Int;
        
        //var animationCurve = UIViewAnimationCurve(rawValue: curveValue) // or use UIViewAnimationOptions(kbCurve << 16)  directly in the UIView animation
        
        //When we are typing the comment, move upwards the view so we can see what we are typing
        
        UIView.animateWithDuration(animationDuration, delay: 0.0, options: .CurveEaseInOut, animations: {
            self.view.frame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)
            }, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true);
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "QueryResultSegue") {
            let destVC : ResultsManagerViewController = segue.destinationViewController as! ResultsManagerViewController;
            destVC.results = self.queryResult!;
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if (identifier == SeguesID.QUERY_RESULT_SEGUE_ID && self.canPerformResultSegue) {
            self.canPerformResultSegue = false;
            return true;
        } else {
            return false;
        }
    }
}

