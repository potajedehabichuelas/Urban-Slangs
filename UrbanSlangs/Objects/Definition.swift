//
//  Word.swift
//  Slangs
//
//  Created by Daniel Bolivar herrera on 17/12/2014.
//  Copyright (c) 2014 Xquare. All rights reserved.
//

import UIKit

private let DEFINITION_DEF_KEY : String = "definition";

private let DEFINITION_THUMBS_UP_KEY : String = "thumbs_up";

private let DEFINITION_THUMBS_DOWN_KEY : String = "thumbs_down";

private let DEFINITION_EXAMPLE_KEY : String = "example";

private let DEFINITION_WORD_KEY : String = "word";

class Definition: NSObject {
    
    var word : String = "";
    
    var definition : String = "";
    
    var ID : Int = 0;
    
    var example : String = "";
    
    var thumbsUp : Int = 0;
    
    var thumbsDown : Int = 0;   
    
    class func definitionFromJSON(defDict: NSDictionary) -> Definition
    {
        var newDef : Definition = Definition();
        
        //Word
        newDef.word = defDict[DEFINITION_WORD_KEY] as String;
        //Definition
        newDef.definition = defDict[DEFINITION_DEF_KEY] as String;
        
        //Thumbs ups and down
        newDef.thumbsDown = defDict[DEFINITION_THUMBS_DOWN_KEY] as Int;
        newDef.thumbsUp = defDict[DEFINITION_THUMBS_UP_KEY] as Int;
        
        //Add example
        newDef.example = defDict[DEFINITION_EXAMPLE_KEY] as String;
        
        /*for (key, value) in defDict {
            println("\n KEY IS : \(key) ->\n  VALUE  ");
            println("\(value)");
        }*/
        
        return newDef;
    }
    
}
