//
//  ViewController.swift
//  Slang Dictionary
//
//  Created by Daniel Bolivar herrera on 12/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


struct SeguesID {
    static let QUERY_RESULT_SEGUE_ID : String = "QueryResultSegue"
}

private let RANDOM_BUTTON_TAG = 10;

class SearchViewController: UIViewController, UITextFieldDelegate, GADInterstitialDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    @IBOutlet weak var randomButton: UIButton!
    
    @IBOutlet weak var disclaimerLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var fullScreenAd : GADInterstitial?;
    
    var queryResult : QueryResult?;
    
    var canPerformResultSegue : Bool = false;
    
    var settingsOnScreen = false;
    var bookmarksOnScreen = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hidden status bar
        UIApplication.shared.isStatusBarHidden = true;
        
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(SearchViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        //Dismiss keyboard when tapping outside the view
        let tap:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        
        //TSmessage vc
        TSMessage.setDefaultViewController(self.navigationController);
        
        //Admob thing
        self.bannerView.adUnitID = "ca-app-pub-7267181828972563/6462911130"
        self.bannerView.rootViewController = self;
        let request:GADRequest = GADRequest()
        self.bannerView.load(request)
        
        //SWRevealVc
        self.revealViewController().toggleAnimationDuration = 0.8;
        self.revealViewController().bounceBackOnOverdraw = true;
        self.revealViewController().bounceBackOnLeftOverdraw = true;
        
        //Gesture recognizers
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SearchViewController.gestureResponder(_:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(SearchViewController.gestureResponder(_:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(3.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
            //hide disclaimer tag
            UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
                self.disclaimerLabel.alpha = 0.0;
                }, completion: { finished in
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        self.canPerformResultSegue = false;
        
        //Recreate full screen ad (object can be used only once)
        self.fullScreenAd = AdMobHelper.createAndLoadInterstitial(self);
        
    }
    
    @IBAction func bookmarksClicked(_ sender: AnyObject?) {
        
        self.revealViewController().rightRevealToggle(animated: true);
        self.bookmarksOnScreen = self.bookmarksOnScreen ? false : true;
        self.view.endEditing(true);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func gestureResponder(_ gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            if (swipeGesture.direction == UISwipeGestureRecognizerDirection.right) {
                if (self.bookmarksOnScreen) {
                    self.bookmarksClicked(swipeGesture);
                } else {
                    self.settingsClicked(swipeGesture);
                }
            } else if (swipeGesture.direction == UISwipeGestureRecognizerDirection.left) {
                if (self.settingsOnScreen) {
                    self.settingsClicked(swipeGesture);
                } else {
                    self.bookmarksClicked(swipeGesture);
                }
            }
        }
    }
    
    @IBAction func settingsClicked(_ sender: AnyObject?) {
        self.revealViewController().revealToggle(animated: true);
        self.settingsOnScreen = self.settingsOnScreen ? false : true;
        self.view.endEditing(true);
    }
    
    @IBAction func searchString(_ sender: AnyObject) {
        
        //Search for the introduced string
        
        //Hide side menu or bookmarks menu if on screen
        if self.bookmarksOnScreen {
            self.bookmarksClicked(nil);
        } else if self.settingsOnScreen {
            self.settingsClicked(nil);
        }
        
        //DisableButton
        self.searchButton.isEnabled = false;
        self.randomButton.isEnabled = false;

        //Show the activity indicator
        self.activityIndicator.alpha = 1.0;
        self.activityIndicator.isHidden = false;
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.activityIndicator.alpha = 0.0;

            }, completion: nil)
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            if ((sender as! UIButton).tag == RANDOM_BUTTON_TAG) {
                //Random
                self.queryResult = SlangNet.sharedInstance.requestRandomWordInformation();
            } else {
                //Input string
                //Remove spaces and put +
                let searchWord : String = self.searchTextField.text!
                self.queryResult = SlangNet.sharedInstance.requestWordInformation(searchWord);
            }
            
            DispatchQueue.main.async {
                // update some UI
                
                //Hide the activity indicator
                UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: {
                    
                    }, completion: { finished in
                        self.activityIndicator.isHidden = true;
                        //Re enable the button
                        self.searchButton.isEnabled = true;
                        self.randomButton.isEnabled = true;
                        self.dismissKeyboard()
                })
                
                print("Request completed");
                if (self.queryResult != nil && self.queryResult?.definitions?.count > 0) {
                    self.searchTextField.text = "";
                    //Go to the next screen to display results
                    self.canPerformResultSegue = true;
                    
                    self.performSegue(withIdentifier: SeguesID.QUERY_RESULT_SEGUE_ID, sender:self.searchButton);
                    
                    //Show ad and after that perform segue
                    self.fullScreenAd!.present(fromRootViewController: self.navigationController!);
                    
                    if self.queryResult?.resultType != QUERY_RESULT_TYPE_EXACT && self.queryResult?.searchString != "random_Search" {
                        //TSMessage - //If result wasnt exact, inform the user
                        TSMessage.showNotification(withTitle: "Whooops :(", subtitle: "No results matched. But perhaps you might be interested in these!", type:TSMessageNotificationType.warning);
                    }
                    
                } else {
                    //Error!
                    if self.queryResult?.definitions?.count == 0 {
                        //No results
                        print("no results")
                        //TSMessage
                        TSMessage.showNotification(withTitle: "Whooops :(", subtitle: "No results matched your search", type:TSMessageNotificationType.error);
                    } else {
                        //Error
                        print("error")
                        //TSMessage
                        TSMessage.showNotification(withTitle: "Connection failed", subtitle: "Check your internet connection!", type:TSMessageNotificationType.error);
                    }
                    
                }
                
            }
        }
        
    }
    
    //MARK - UITextField

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.searchString(self.searchButton);
        
        return true
    }

    
    //MARK - Keyboard and view editing
    
    func keyboardWillShow(_ notification: Notification)
    {
        //Lift the view up only if the device is in landscape
        if UIInterfaceOrientationIsLandscape(UIApplication.shared.statusBarOrientation) {
            
            var info = (notification as NSNotification).userInfo!
            let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            
            //Get animation time
            let durationValue : Double = info[UIKeyboardAnimationDurationUserInfoKey] as! Double;
            let animationDuration : TimeInterval = durationValue
            
            //When we are typing the comment, move upwards the view so we can see what we are typing
            
            UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
                if UIDevice.current.userInterfaceIdiom == .pad {
                    self.view.frame = CGRect(x: self.view.frame.origin.x, y: -keyboardFrame.size.height * 0.2, width: self.view.frame.size.width, height: self.view.frame.size.height)
                } else {
                    self.view.frame = CGRect(x: self.view.frame.origin.x, y: -keyboardFrame.size.height * 0.5, width: self.view.frame.size.width, height: self.view.frame.size.height)
                }
            }, completion: nil)
        }
    }
    
    
    func keyboardWillHide(_ notification: Notification)
    {
        var info = (notification as NSNotification).userInfo!
        //var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        
        //Get animation time
        let durationValue : Double = info[UIKeyboardAnimationDurationUserInfoKey] as! Double;
        let animationDuration : TimeInterval = durationValue
        
        //When we are typing the comment, move upwards the view so we can see what we are typing
        
        UIView.animate(withDuration: animationDuration, delay: 0.0, options: UIViewAnimationOptions(), animations: {
            self.view.frame = CGRect(x: self.view.frame.origin.x, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }, completion: nil)
    }
    
    func dismissKeyboard() {
        self.view.endEditing(true);
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "QueryResultSegue") {
            let destVC : ResultsManagerViewController = segue.destination as! ResultsManagerViewController;
            destVC.results = self.queryResult!;
        }
    }

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if (identifier == SeguesID.QUERY_RESULT_SEGUE_ID && self.canPerformResultSegue) {
            self.canPerformResultSegue = false;
            return true;
        } else {
            return false;
        }
    }
}

