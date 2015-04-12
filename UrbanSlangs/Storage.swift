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
    
    class func addHistoryWordEntry(wordEntry: Definition)
    {
        var historyArr = self.getHistoryArray();
        //Remove it if it was there
        if let index = find(historyArr, wordEntry) {
            historyArr.removeAtIndex(index);
        }
        historyArr.insert(wordEntry, atIndex: 0)
        self.saveHistoryArray(historyArr)
    }
    
    class func addStarredWordEntry(def: Definition)
    {
        var starredArr = self.getStarredArray();
        starredArr.insert(def, atIndex: 0)
        self.saveStarredArray(starredArr)
    }
    
    class func removeStarredWordEntry(wordEntry: Definition)
    {
        var starredArr = self.getStarredArray();
        //Set if the word is starred
        for var i = 0; i < 1000000; i++ {
            var def = starredArr[i]
            if (def.isEqualToDefinition(wordEntry)) {
                //The word is there, delete it
                starredArr.removeAtIndex(i);
                self.saveStarredArray(starredArr)
                break;
            }
        }
    }
    
    class func saveStarredArray(starredArray: Array<Definition>)
    {
        var path : String = self.getStarredArrayPath()
        
        if NSKeyedArchiver.archiveRootObject(starredArray, toFile: path) {
            println("Success saving starred words file")
        } else {
            println("Unable to write starred words file")
        }
    }
    
    class func getHistoryArrayPath() -> String
    {
        // Create a filepath for archiving.
        var libraryDirectories : NSArray = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        // Get document directory from that list
        var libraryDirectory:String = libraryDirectories.objectAtIndex(0) as! String
        // append with the .archive file name
        return libraryDirectory.stringByAppendingPathComponent("historyWords.archive")
    }
    
    class func getStarredArrayPath() -> String
    {
        // Create a filepath for archiving.
        var libraryDirectories : NSArray = NSSearchPathForDirectoriesInDomains(.LibraryDirectory, .UserDomainMask, true)
        // Get document directory from that list
        var libraryDirectory:String = libraryDirectories.objectAtIndex(0) as! String
        // append with the .archive file name
        return libraryDirectory.stringByAppendingPathComponent("starredWords.archive")
    }
    
    class func getStarredArray() -> Array<Definition>
    {
        var starredArray  = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getStarredArrayPath()) as! Array<Definition>?
        
        if starredArray != nil {
            return starredArray!
        } else {
            return Array();
        }
    }
    
    class func saveHistoryArray(historyArray: Array<Definition>)
    {
        var path : String = getHistoryArrayPath()
        
        if NSKeyedArchiver.archiveRootObject(historyArray, toFile: path) {
            println("Success saving history words file")
        } else {
            println("Unable to write history words file")
        }
    }
    
    class func getHistoryArray() -> Array<Definition>
    {
        var historyArray  = NSKeyedUnarchiver.unarchiveObjectWithFile(self.getHistoryArrayPath()) as! Array<Definition>?
        
        if historyArray != nil {
            return historyArray!
        } else {
            return Array();
        }
    }
    
}