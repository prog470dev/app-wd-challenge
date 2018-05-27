//
//  TechKeysUitil.swift
//  app-wd-challenge
//
//  Created by 清水大樹 on 2018/05/25.
//  Copyright © 2018 prog470dev. All rights reserved.
//

import Foundation

class TechKeyFinder {
    
    let techKeys:[String] = ["C言語", "C++", "Java", "Swift", "Kotlin", "Scala", "Go", "PHP", "Perl", "Ruby", "Python", "Rust", "Lisp", "Haskell"]
    
    func displayString (description: String) -> String{
        return shapTechKeys(keys: extractionKeys (description: description))
    }
    
    func extractionKeys (description: String) -> [String]{
        var retArray:[String] = []
        for var e in techKeys{
            if(description.lowercased().contains(e.lowercased())){
                retArray.append(e)
            }
        }
        print(retArray)
        return retArray
    }
    
    func shapTechKeys(keys: [String]) -> String{
        var ret = ""
        var longestString = ""
        
        for var e in keys{
            if(e.unicodeScalars.count > longestString.unicodeScalars.count/3){
                for _ in 0..<(e.unicodeScalars.count - longestString.unicodeScalars.count/3){
                    longestString += "   "
                }
            }
            ret += e + "\n"
        }
        ret = (" "+longestString+" \n") + ret + (" "+longestString+" \n")
        
        return ret
    }
    
}
