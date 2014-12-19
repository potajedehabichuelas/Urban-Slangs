//
//  SlangNet.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 17/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

private let BASE_URL : String = "http://api.urbandictionary.com/v0/";

private let DEFINE_API : String = "define?term=";

private let _singletonSharedInstance = SlangNet();

class SlangNet: NSObject {
   
    class var sharedInstance : SlangNet {
        //Ensure there is only one instance of this class
        return _singletonSharedInstance
    }
    
    func parseJSON(inputData: NSData) -> NSDictionary{
        var error: NSError?
        var boardsDictionary: NSDictionary = NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions.MutableContainers, error: &error) as NSDictionary
        
        return boardsDictionary
    }
    
    //Request information for a word
    func requestWordInformation(wordString: String) -> QueryResult?
    {
        println("Requesting information for word: " +  wordString);
        
        var dictParams : Dictionary<String, String>?;
        
        var requestResult : AnyObject? = HttpHelper.httpGetURL(BASE_URL, postPath:DEFINE_API.stringByAppendingString(wordString), parametersDict:dictParams);
    
        //Translate JSON object into Definition Objects
        var queryResult : QueryResult = QueryResult.queryResultFromJSON(wordString, jsonDict: requestResult! as NSDictionary);
    
        return queryResult;
    }
    
}
