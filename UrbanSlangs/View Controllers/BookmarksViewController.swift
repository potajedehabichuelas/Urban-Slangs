//
//  BookmarksViewController.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 11/01/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit

class BookmarksViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var imageViewBg: UIImageView!
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var bookmarksTableView: UITableView!
    
    var bookmarksArray : Array <Definition> = Array();
    
    var effectView:UIView? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //If device has ios 7, UIVisualEffectView is not available
        switch UIDevice.currentDevice().systemVersion.compare("8.0.0", options: NSStringCompareOptions.NumericSearch) {
        case .OrderedSame, .OrderedDescending:
            //Ios 8 or higher
            self.effectView = UIVisualEffectView();
            //Blur effect for the imagev background
            let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
            self.effectView! = UIVisualEffectView (effect: blur);
            self.effectView!.frame = self.view.frame
            
            if (self.imageViewBg != nil) {
                self.view.insertSubview(self.effectView!, aboveSubview: self.imageViewBg)
            }
        case .OrderedAscending:
            //ios 7 and lower
            println("ios 7")
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        //Update effect frame
        if self.effectView != nil  {
            self.effectView!.frame = self.view.frame
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        //Reload data
        self.bookmarksArray = Storage.getStarredArray()
        
        if (self.bookmarksTableView != nil) {
            self.bookmarksTableView.reloadData();
            //Scrollable only if contents biggah
            if self.bookmarksTableView.contentSize.height < self.bookmarksTableView.frame.size.height {
                self.bookmarksTableView.scrollEnabled = false;
            } else {
                self.bookmarksTableView.scrollEnabled = true;
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "BookmarksSegue") {
            var destVC : ResultsPageViewController = segue.destinationViewController as ResultsPageViewController;
            destVC.definition = self.bookmarksArray[self.bookmarksTableView.indexPathForSelectedRow()!.section]
            self.bookmarksTableView.deselectRowAtIndexPath(self.bookmarksTableView.indexPathForSelectedRow()!, animated: true)
        }
    }
    
    //MARK : UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.bookmarksArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.bookmarksTableView.dequeueReusableCellWithIdentifier("DefinitionCell") as UITableViewCell
        
        var def : Definition =  self.bookmarksArray[indexPath.section]
        cell.textLabel?.text = def.word
        
        cell.backgroundColor = UIColor(red:0.0, green:0.0,blue:0.0,alpha:0.41)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 5))
        footerView.backgroundColor = UIColor.clearColor()
        
        return footerView
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRectMake(0, 0, tableView.frame.size.width, 5))
        headerView.backgroundColor = UIColor.clearColor()
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10.0
        } else {
            return 5.0
        }
    }

}