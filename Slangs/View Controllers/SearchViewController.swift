//
//  ViewController.swift
//  Slang Dictionary
//
//  Created by Daniel Bolivar herrera on 12/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
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
            var definition : QueryResult? = SlangNet.sharedInstance.requestWordInformation(self.searchTextField.text);
            
            dispatch_async(dispatch_get_main_queue()) {
                // update some UI
                println("Request completed");
                if (definition != nil) {
                    self.searchTextField.text = "";
                    //Go to the next screen to display results
                    
                } else {
                    //Error!
                    
                }
                
            }
        }
        
    }

}

