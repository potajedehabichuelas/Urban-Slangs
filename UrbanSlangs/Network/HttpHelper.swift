//
//  HttpHelper.swift
//  Slang Dictionary
//
//  Created by Daniel Bolivar herrera on 16/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

class HttpHelper: NSObject {
    
    /* Maybe use this as class variables so requests are in a queue (?)
    //Qeue for the requests
    let queue: dispatch_queue_t
    //Semaphore
    let semaphore: dispatch_semaphore_t
    
    init() {
        self.stream = []
        self.semaphore = dispatch_semaphore_create(0)
        self.queue = dispatch_queue_create("channel.queue.", DISPATCH_QUEUE_CONCURRENT)
    }
    */
    
    //POST Request
    class func httpPostURL(url: String, postPath: String, parametersDict:Dictionary<String, AnyObject>?) -> AnyObject?
    {
        // ? declares variable as optional, just in case the request fails
        var responseJSON : AnyObject? = nil;
        
        //Create the urls
        let fullURL = url.stringByAppendingString(postPath);
        
        //Semaphore to wait for completition block
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager();
        
        manager.POST(fullURL,
            parameters: parametersDict,
            success: {
                (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //println("JSON: " + responseObject.description);
                
                responseJSON = responseObject;
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
                
            }, failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                print("[HTTPHelper Error]: " + error.localizedDescription);
                //Maybe check for internet connection ?
                
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
        });
        
        //Wait for the completition of the request
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
        return responseJSON;
    }

    //GET Request
    class func httpGetURL(url: String, postPath: String, parametersDict:Dictionary<String, String>?) -> AnyObject?
    {
    
        // ? declares variable as optional, just in case the request fails
        var responseJSON : AnyObject? = nil;
        
        //Create the urls
        let fullURL = url.stringByAppendingString(postPath);
        
        //Semaphore to wait for completition block
        let semaphore: dispatch_semaphore_t = dispatch_semaphore_create(0);
        
        let manager : AFHTTPRequestOperationManager = AFHTTPRequestOperationManager();
        
        manager.GET(fullURL,
            parameters: parametersDict,
            success: {
                (operation: AFHTTPRequestOperation!,responseObject: AnyObject!) in
                //print("JSON: " + responseObject.description);
                
                responseJSON = responseObject;
                print(responseJSON);
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
                
            },failure: { (operation: AFHTTPRequestOperation!,error: NSError!) in
                print("[HTTPHelper Error]: " + error.localizedDescription);
                //Maybe check for internet connection ?
                
                //Signal semaphore
                dispatch_semaphore_signal(semaphore);
        });
        
        //Wait for the completition of the request
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        return responseJSON;

    }
}
