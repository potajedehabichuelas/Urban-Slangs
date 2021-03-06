//
//  Word.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 17/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

private let WORD_TAGS_KEY : String = "tags";
private let WORD_LIST_KEY : String = "list";
private let WORD_SOUNDS_KEY : String = "sounds";
private let WORD_RESULT_TYPE_KEY : String = "result_type";

public let QUERY_RESULT_TYPE_EXACT : String = "exact"

class QueryResult: NSObject {
    
    var searchString : String = "";
    
    var sounds : Array<AnyObject>? = Array();
    
    var tags : Array <String>? = Array();
    
    var definitions : Array <Definition>? = Array();
    
    var resultType : String = "";

    
    class func queryResultFromJSON(_ searchString : String, jsonDict : NSDictionary) -> QueryResult
    {
        let qresult : QueryResult = QueryResult();
        
        //Store the searchedString
        qresult.searchString = searchString;
        //First Dict has 4 Keys :
        
        // tags
        if ((jsonDict[WORD_TAGS_KEY]) != nil) {
            for tag in jsonDict[WORD_TAGS_KEY] as! NSArray {
                //Add the tags to the array
                qresult.tags?.append(tag as! String);
            }
        }
        
        // sounds
        /*for sound : AnyObject? in jsonDict[WORD_SOUNDS_KEY] as NSMutableArray {
            //Add the sounds to the array
            
        }*/
        
        // list
        for defDict in jsonDict[WORD_LIST_KEY] as! NSArray {
            //Add the definitions to the array
            let definition : Definition = Definition.definitionFromJSON(defDict as! NSDictionary);
            qresult.definitions?.append(definition);
        }
        
        // result_type
        if (jsonDict[WORD_RESULT_TYPE_KEY] != nil) {
            qresult.resultType = jsonDict[WORD_RESULT_TYPE_KEY] as! String;
        }
        
        return qresult;
    }
}
