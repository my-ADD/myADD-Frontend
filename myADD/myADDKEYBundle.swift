//
//  myADDKEYBundle.swift
//  myADD
//
//
//

import Foundation

extension Bundle {
    
    var apiKey: String {
       
        guard let filePath = Bundle.main.path(forResource: "LoginPropertyList", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'LoginPropertyList.plist'.")
        }
        
        guard let value = plistDict.object(forKey: "APP_KEY") as? String else {
            fatalError("Couldn't find key 'APP_Key' in 'LoginPropertyList.plist'.")
        }
        
        
        return value
    }
}
