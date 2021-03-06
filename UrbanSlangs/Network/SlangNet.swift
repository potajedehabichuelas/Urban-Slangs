//
//  SlangNet.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 17/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

private let BASE_URL : String = "http://api.urbandictionary.com/v0/";

private let DEFINE_API : String = "define";

private let RANDOM_API : String = "random"

private let TERM_KEY : String = "term";

private let _singletonSharedInstance = SlangNet();

class SlangNet: NSObject {
   
    class var sharedInstance : SlangNet {
        //Ensure there is only one instance of this class
        return _singletonSharedInstance
    }
    
    func parseJSON(_ inputData: Data) -> NSDictionary{
        let boardsDictionary: NSDictionary = (try! JSONSerialization.jsonObject(with: inputData, options: JSONSerialization.ReadingOptions.mutableContainers)) as! NSDictionary
        
        return boardsDictionary
    }
    
    //Request information for a word
    func requestWordInformation(_ wordString: String) -> QueryResult?
    {
        print("Requesting information for word: " +  wordString);
        
        var dictParams : Dictionary<String, String> = Dictionary();
        dictParams[TERM_KEY] = wordString;
        
        let requestResult : AnyObject? = HttpHelper.httpGetURL(BASE_URL, postPath:DEFINE_API, parametersDict:dictParams as Dictionary<String, AnyObject>?);
    
        //Translate JSON object into Definition Objects
        var queryResult : QueryResult?;
        
        if (requestResult != nil) {
            queryResult = QueryResult.queryResultFromJSON(wordString, jsonDict: requestResult as! NSDictionary);
        }
    
        return queryResult;
    }
    
    //Request information for a RANDOM word
    func requestRandomWordInformation() -> QueryResult?
    {
        
        let requestResult : AnyObject? = HttpHelper.httpGetURL(BASE_URL, postPath:RANDOM_API, parametersDict:nil);
        
        //Translate JSON object into Definition Objects
        var queryResult : QueryResult?;
        
        if (requestResult != nil) {
            queryResult = QueryResult.queryResultFromJSON("random_Search", jsonDict: requestResult as! NSDictionary);
        }
        
        return queryResult;
    }
    
}
