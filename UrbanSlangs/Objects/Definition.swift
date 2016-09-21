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

private let DEFINITION_ID_KEY : String = "ID";

class Definition: NSObject, NSCoding {
    
    var word : String = "";
    
    var definition : String = "";
    
    var ID : Int = 0;
    
    var example : String = "";
    
    var thumbsUp : Int = 0;
    
    var thumbsDown : Int = 0;   
    
    class func definitionFromJSON(_ defDict: NSDictionary) -> Definition
    {
        let newDef : Definition = Definition();
        
        //Word
        newDef.word = defDict[DEFINITION_WORD_KEY] as! String;
        //Definition
        newDef.definition = defDict[DEFINITION_DEF_KEY] as! String;
        
        //Thumbs ups and down
        newDef.thumbsDown = defDict[DEFINITION_THUMBS_DOWN_KEY] as! Int;
        newDef.thumbsUp = defDict[DEFINITION_THUMBS_UP_KEY] as! Int;
        
        //Add example
        newDef.example = defDict[DEFINITION_EXAMPLE_KEY] as! String;
        
        /*for (key, value) in defDict {
            println("\n KEY IS : \(key) ->\n  VALUE  ");
            println("\(value)");
        }*/
        
        return newDef;
    }
    
    func isEqualToDefinition(_ def: Definition?) -> Bool {
        
        if self.word == def?.word && self.definition == def?.definition && self.example == def?.example {
            return true;
        } else {
            return false;
        }
    }
    
    // MARK : NSCODING
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.definition, forKey: DEFINITION_DEF_KEY)
        aCoder.encode(self.word, forKey: DEFINITION_WORD_KEY)
        aCoder.encode(self.example, forKey: DEFINITION_EXAMPLE_KEY)
        
        aCoder.encode(self.ID, forKey:DEFINITION_ID_KEY)
        
        aCoder.encode(self.thumbsDown, forKey:DEFINITION_THUMBS_DOWN_KEY)
        aCoder.encode(self.thumbsUp, forKey:DEFINITION_THUMBS_UP_KEY)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        self.word = aDecoder.decodeObject(forKey: DEFINITION_WORD_KEY) as! String
        
        self.definition = aDecoder.decodeObject(forKey: DEFINITION_DEF_KEY) as! String
        self.example = aDecoder.decodeObject(forKey: DEFINITION_EXAMPLE_KEY) as! String
        
        self.ID = aDecoder.decodeInteger(forKey: DEFINITION_ID_KEY)
        
        self.thumbsDown = aDecoder.decodeInteger(forKey: DEFINITION_THUMBS_DOWN_KEY)
        self.thumbsUp = aDecoder.decodeInteger(forKey: DEFINITION_THUMBS_UP_KEY)
    }
    
}
