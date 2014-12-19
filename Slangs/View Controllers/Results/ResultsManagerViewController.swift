//
//  ResultsPageManagerViewController.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 19/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class ResultsManagerViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, UIScrollViewDelegate {
    
    var results : QueryResult = QueryResult();
    
    var currentIndex : Int = 0;
    
    //Wind page control stuff
    var pageViewController : UIPageViewController?;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Create page view controller
        self.pageViewController = self.storyboard?.instantiateViewControllerWithIdentifier("PageViewController") as? UIPageViewController;
        self.pageViewController!.dataSource = self;
        self.pageViewController!.delegate = self;
        
        //Set it up
        var startingViewController : ResultsPageViewController = self.viewControllerAtIndex(0)!;
        
        var viewControllers : NSArray = [startingViewController];
        
        self.pageViewController?.setViewControllers(viewControllers, direction: .Forward, animated: false, completion: nil);
    
        
        // Change the size of page view controller
        self.pageViewController?.view.frame = self.view.frame;
        
        self.addChildViewController(self.pageViewController!);
        
        self.view.addSubview(self.pageViewController!.view);
        
        self.pageViewController?.didMoveToParentViewController(self);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // #pragma mark - Page View Controller Data Source
    
    func viewControllerAtIndex(index : Int) -> ResultsPageViewController?
    {
        if(results.definitions!.count == 0 || index > results.definitions!.count) {
            return nil;
        }
        
        var resultVc : ResultsPageViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ResultContentVC") as ResultsPageViewController;
        
        //Set the appropiate data for the VC
        resultVc.pageIndex = index;
        resultVc.definition = self.results.definitions![index];
        
        return resultVc;
    }


    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index : Int = (viewController as ResultsPageViewController).pageIndex
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index++;
        
        if (index == results.definitions?.count) {
            return nil;
        }
        
        return self.viewControllerAtIndex(index);
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
       
        var index : Int = (viewController as ResultsPageViewController).pageIndex
        
        if (index == NSNotFound || index == 0) {
            return nil;
        }
        //Allow index -1 to dismiss it
        
        index--;
    
        return self.viewControllerAtIndex(index);
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        if (results.definitions?.count == nil) {
            return 0;
        } else {
            return results.definitions!.count - 1;
        }
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return 0;
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [AnyObject], transitionCompleted completed: Bool) {
        self.currentIndex = (previousViewControllers.first as ResultsPageViewController).pageIndex;
    }
}
