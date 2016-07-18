//
//  Extensions.swift
//  CookieCrunch
//
//  Created by 소프트가족 on 2016. 5. 17..
//  Copyright © 2016년 Bloc. All rights reserved.
//

import Foundation

extension Dictionary {
    static func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            
            do {
                let data = try NSData(contentsOfFile: path, options: NSDataReadingOptions())
                
                let dictionaryData: AnyObject? = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                
                let dictionary = dictionaryData as? Dictionary<String, AnyObject>
                
                return dictionary

            } catch let caught as NSError {
                print(caught)
                return nil
            } catch let caught as exception {
                print(caught)
                return nil
            }
        }
        else {
            print("Could not find level file: \(filename)")
            return nil
        }
    }
}