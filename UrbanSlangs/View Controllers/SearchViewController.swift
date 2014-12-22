//
//  ViewController.swift
//  Slang Dictionary
//
//  Created by Daniel Bolivar herrera on 12/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

private let QUERY_RESULT_SEGUE_ID : String = "QueryResultSegue";

class SearchViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var queryResult : QueryResult?;
    
    var canPerformResultSegue : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hidden status bar
        UIApplication.sharedApplication().statusBarHidden = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        
        //Dismiss keyboard when tapping outside the view
        var tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        self.view.addGestureRecognizer(tap)
        
        //TSmessage vc
        TSMessage.setDefaultViewController(self.navigationController);
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        self.canPerformResultSegue = false;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchString(sender: AnyObject) {
        
        //Search for the introduced string
        
        //DisableButton
        self.searchButton.enabled = false;

        //Show the activity indicator
        self.activityIndicator.alpha = 1.0;
        self.activityIndicator.hidden = false;
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.activityIndicator.alpha = 0.0;

            }, completion: nil)
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            //Remove spaces and put +
            var searchWord : String = self.searchTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
            self.queryResult = SlangNet.sharedInstance.requestWordInformation(searchWord);
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                
                //Hide the activity indicator
                UIView.animateWithDuration(0.3, delay: 0.0, options: .CurveEaseOut, animations: {
                    //WEIRD SHIT HAPPENS self.activityIndicator.alpha = 1.0
                    
                    }, completion: { finished in
                        self.activityIndicator.hidden = true;
                        //Re enable the button
                        self.searchButton.enabled = true;
                })
                
                println("Request completed");
                if (self.queryResult != nil && self.queryResult?.definitions?.count > 0) {
                    self.searchTextField.text = "";
                    //Go to the next screen to display results
                    self.canPerformResultSegue = true;
                    self.performSegueWithIdentifier(QUERY_RESULT_SEGUE_ID, sender:self.searchButton);
                    
                    if self.queryResult?.resultType != QueryConstants.QUERY_RESULT_TYPE_EXACT {
                        //TSMessage - //If result wasnt exact, inform the user
                        TSMessage.showNotificationWithTitle("Whooops :(", subtitle: "No results matched. But perhaps you might be interested in these!", type:TSMessageNotificationType.Warning);
                    }
                    
                } else {
                    //Error!
                    if self.queryResult?.definitions?.count == 0 {
                        //No results
                        println("no results")
                        //TSMessage
                        TSMessage.showNotificationWithTitle("Whooops :(", subtitle: "No results matched your search", type:TSMessageNotificationType.Error);
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
            var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
            
            //Get animation time
            var durationValue : Double = info[UIKeyboardAnimationDurationUserInfoKey] as Double;
            var animationDuration : NSTimeInterval = durationValue
            
            //And the animation curve
            var curveValue : Int = info[UIKeyboardAnimationCurveUserInfoKey] as Int;
            
            var animationCurve = UIViewAnimationCurve(rawValue: curveValue) // or use UIViewAnimationOptions(kbCurve << 16)  directly in the UIView animation
            
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
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        
        //Get animation time
        var durationValue : Double = info[UIKeyboardAnimationDurationUserInfoKey] as Double;
        var animationDuration : NSTimeInterval = durationValue
        
        //And the animation curve
        var curveValue : Int = info[UIKeyboardAnimationCurveUserInfoKey] as Int;
        
        var animationCurve = UIViewAnimationCurve(rawValue: curveValue) // or use UIViewAnimationOptions(kbCurve << 16)  directly in the UIView animation
        
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
            var destVC : ResultsManagerViewController = segue.destinationViewController as ResultsManagerViewController;
            destVC.results = self.queryResult!;
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if (identifier == QUERY_RESULT_SEGUE_ID && self.canPerformResultSegue) {
            self.canPerformResultSegue = false;
            return true;
        } else {
            return false;
        }
    }
}

