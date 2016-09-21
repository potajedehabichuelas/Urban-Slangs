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
        self.pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "PageViewController") as? UIPageViewController;
        self.pageViewController!.dataSource = self;
        self.pageViewController!.delegate = self;
        
        //Set it up
        let startingViewController = self.viewControllerAtIndex(0)!;
        
        self.pageViewController?.setViewControllers([startingViewController], direction: .forward, animated: false, completion: nil);
        
        // Change the size of page view controller
        self.pageViewController?.view.frame = self.view.frame;
        
        self.addChildViewController(self.pageViewController!);
        
        self.view.addSubview(self.pageViewController!.view);
        
        self.pageViewController?.didMove(toParentViewController: self);
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // #pragma mark - Page View Controller Data Source
    
    func viewControllerAtIndex(_ index : Int) -> ResultsPageViewController?
    {
        if(results.definitions!.count == 0 || index > results.definitions!.count) {
            return nil;
        }
        
        let resultVc = self.storyboard?.instantiateViewController(withIdentifier: "ResultContentVC") as! ResultsPageViewController;
        
        //Set the appropiate data for the VC
        resultVc.pageIndex = index;
        resultVc.totalPages = results.definitions!.count;
        resultVc.definition = self.results.definitions![index];
        resultVc.relatedTagsArray = self.results.tags!;
        
        return resultVc;
    }


    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index : Int = (viewController as! ResultsPageViewController).pageIndex
        
        if (index == NSNotFound) {
            return nil;
        }
        
        index += 1;
        
        if (index == results.definitions?.count) {
            return nil;
        }
        
        return self.viewControllerAtIndex(index);
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
       
        var index : Int = (viewController as! ResultsPageViewController).pageIndex
        
        if (index == NSNotFound || index == 0) {
            return nil;
        }
        //Allow index -1 to dismiss it
        
        index -= 1;
    
        return self.viewControllerAtIndex(index);
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        
        if (results.definitions?.count == nil) {
            return 0;
        } else {
            return results.definitions!.count - 1;
        }
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return 0;
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        self.currentIndex = (previousViewControllers.first as! ResultsPageViewController).pageIndex;
    }
}
