//
//  SideMenuViewController.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 29/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var imageViewBg: UIImageView!
    
    @IBOutlet weak var removeAdsButton: UIButton!

    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var historyTableView: UITableView!
    
    var historyArray : Array <Definition> = Array();
    
    var effectView:UIVisualEffectView = UIVisualEffectView();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Blur effect for the imagev background
        let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
        self.effectView = UIVisualEffectView (effect: blur);
        self.effectView.frame = self.view.frame
        if (self.imageViewBg != nil) {
            self.view.insertSubview(effectView, aboveSubview: self.imageViewBg)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        
        //Reload data
        self.historyArray = Storage.getHistoryArray()
        
        if (self.historyTableView != nil) {
            self.historyTableView.reloadData();
            //Scrollable only if contents biggah
            if self.historyTableView.contentSize.height < self.historyTableView.frame.size.height {
                self.historyTableView.scrollEnabled = false;
            } else {
                self.historyTableView.scrollEnabled = true;
            }
        }
    }
    
    override func viewWillLayoutSubviews() {
        //Update effect frame
        self.effectView.frame = self.view.frame
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func removeAds(sender: AnyObject) {
        
    }

    @IBAction func trashHistory(sender: AnyObject) {
        self.historyArray = Array();
        Storage.saveHistoryArray(self.historyArray)
        ;
        var indexSet : NSIndexSet = NSIndexSet(indexesInRange: NSRange(location: 0, length:self.historyTableView.numberOfSections()))
        self.historyTableView.deleteSections(indexSet, withRowAnimation: UITableViewRowAnimation.Top);
    }
    
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "HistorySegue") {
            var destVC : ResultsPageViewController = segue.destinationViewController as ResultsPageViewController;
            destVC.definition = self.historyArray[self.historyTableView.indexPathForSelectedRow()!.section]
            self.historyTableView.deselectRowAtIndexPath(self.historyTableView.indexPathForSelectedRow()!, animated: true)
        }
    }

    //MARK : UITableView Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.historyArray.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell = self.historyTableView.dequeueReusableCellWithIdentifier("DefinitionCell") as UITableViewCell
        
        var def : Definition =  self.historyArray[indexPath.section]
        cell.textLabel?.text = def.word
        
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
        if section == 0 {
            return 0.0
        } else {
            return 5.0
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.0
        } else if section == 1 {
            return 10.0
        } else {
            return 5.0
        }
    }

}
