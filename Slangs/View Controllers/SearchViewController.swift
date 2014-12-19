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

    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    var queryResult : QueryResult?;
    
    var canPerformResultSegue : Bool = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hidden status bar
        UIApplication.sharedApplication().statusBarHidden = true;
        
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
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            // do some task
            //Test Request
            //Remove spaces and put +
            var searchWord : String = self.searchTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: nil, range: nil)
            self.queryResult = SlangNet.sharedInstance.requestWordInformation(searchWord);
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                println("Request completed");
                if (self.queryResult != nil) {
                    self.searchTextField.text = "";
                    //Go to the next screen to display results
                    self.canPerformResultSegue = true;
                    self.performSegueWithIdentifier(QUERY_RESULT_SEGUE_ID, sender:self.searchButton);
                } else {
                    //Error!
                    
                }
                
            }
        }
        
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

