//
//  Storage.swift
//  Urban Slangs
//
//  Created by Daniel Bolivar herrera on 19/01/2015.
//  Copyright (c) 2015 Xquare. All rights reserved.
//

import UIKit

private let STORAGE_STARRED_WORDS : String = "starred";

private let STORAGE_HISTORY_WORDS : String = "history";

private let _singletonSharedInstance = Storage();

class Storage: NSObject {
   
    class var sharedInstance : Storage {
        //Ensure there is only one instance of this class
        return _singletonSharedInstance
    }
    
    class func addHistoryWordEntry(_ wordEntry: Definition)
    {
        var historyArr = self.getHistoryArray();
        //Remove it if it was there
        if let index = historyArr.index(of: wordEntry) {
            historyArr.remove(at: index);
        }
        historyArr.insert(wordEntry, at: 0)
        self.saveHistoryArray(historyArr)
    }
    
    class func addStarredWordEntry(_ def: Definition)
    {
        var starredArr = self.getStarredArray();
        starredArr.insert(def, at: 0)
        self.saveStarredArray(starredArr)
    }
    
    class func removeStarredWordEntry(_ wordEntry: Definition)
    {
        var starredArr = self.getStarredArray();
        //Set if the word is starred
        for i in 0 ..< starredArr.count {
            let def = starredArr[i]
            if (def.isEqualToDefinition(wordEntry)) {
                //The word is there, delete it
                starredArr.remove(at: i);
                self.saveStarredArray(starredArr)
                break;
            }
        }
    }
    
    class func saveStarredArray(_ starredArray: Array<Definition>)
    {
        let path : String = self.getStarredArrayPath()
        
        if NSKeyedArchiver.archiveRootObject(starredArray, toFile: path) {
            print("Success saving starred words file")
        } else {
            print("Unable to write starred words file")
        }
    }
    
    class func getHistoryArrayPath() -> String
    {
        // Create a filepath for archiving.
        let libraryDirectories : NSArray = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as NSArray
        // Get document directory from that list
        let libraryDirectory:String = libraryDirectories.object(at: 0) as! String
        // append with the .archive file name
        return libraryDirectory + "/historyWords.archive"
    }
    
    class func getStarredArrayPath() -> String
    {
        // Create a filepath for archiving.
        let libraryDirectories : NSArray = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true) as NSArray
        // Get document directory from that list
        let libraryDirectory:String = libraryDirectories.object(at: 0) as! String
        // append with the .archive file name
        return libraryDirectory + "/starredWords.archive"
    }
    
    class func getStarredArray() -> Array<Definition>
    {
        let starredArray  = NSKeyedUnarchiver.unarchiveObject(withFile: self.getStarredArrayPath()) as! Array<Definition>?
        
        if starredArray != nil {
            return starredArray!
        } else {
            return Array();
        }
    }
    
    class func saveHistoryArray(_ historyArray: Array<Definition>)
    {
        let path : String = getHistoryArrayPath()
        
        if NSKeyedArchiver.archiveRootObject(historyArray, toFile: path) {
            print("Success saving history words file")
        } else {
            print("Unable to write history words file")
        }
    }
    
    class func getHistoryArray() -> Array<Definition>
    {
        let historyArray  = NSKeyedUnarchiver.unarchiveObject(withFile: self.getHistoryArrayPath()) as! Array<Definition>?
        
        if historyArray != nil {
            return historyArray!
        } else {
            return Array();
        }
    }
    
}
