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
        
        //Ios 8 or higher
        if #available(iOS 8.0, *) {
            self.effectView = UIVisualEffectView()
            //Blur effect for the imagev background
            let blur:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
            self.effectView! = UIVisualEffectView (effect: blur);
            self.effectView!.frame = self.view.frame
            
            if (self.imageViewBg != nil) {
                self.view.insertSubview(self.effectView!, aboveSubview: self.imageViewBg)
            }
        } else {
            // Fallback on earlier versions
            
            //ios 7 and lower
            print("ios 7")
        };
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        
        //Reload data
        self.bookmarksArray = Storage.getStarredArray()
        
        if (self.bookmarksTableView != nil) {
            self.bookmarksTableView.reloadData();
            //Scrollable only if contents biggah
            if self.bookmarksTableView.contentSize.height < self.bookmarksTableView.frame.size.height {
                self.bookmarksTableView.isScrollEnabled = false;
            } else {
                self.bookmarksTableView.isScrollEnabled = true;
            }
        }
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "BookmarksSegue") {
            let destVC : ResultsPageViewController = segue.destination as! ResultsPageViewController;
            destVC.definition = self.bookmarksArray[(self.bookmarksTableView.indexPathForSelectedRow! as NSIndexPath).section]
            self.bookmarksTableView.deselectRow(at: self.bookmarksTableView.indexPathForSelectedRow!, animated: true)
        }
    }
    
    //MARK : UITableView Delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.bookmarksArray.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.bookmarksTableView.dequeueReusableCell(withIdentifier: "DefinitionCell")
        
        let def : Definition =  self.bookmarksArray[(indexPath as NSIndexPath).section]
        cell!.textLabel?.text = def.word
        
        cell!.backgroundColor = UIColor(red:0.0, green:0.0,blue:0.0,alpha:0.41)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        footerView.backgroundColor = UIColor.clear
        
        return footerView
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 5))
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 10.0
        } else {
            return 5.0
        }
    }

}
