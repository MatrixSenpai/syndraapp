//
//  SplitObject.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import Parse

class Split: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Split"
    }
    
    @NSManaged var split: Int
    @NSManaged var season: Season
    @NSManaged var weeks: PFRelation<Week>
    @NSManaged var start: Date
    
    public func type() -> SplitType {
        return SplitType(rawValue: self.split - 1)!
    }
    
    subscript(_ week: Int) -> Week {
        return Week()
    }
    
    subscript(_ week: Int, _ day: Int) -> Day {
        return Day()
    }
    
    subscript(_ week: Int, _ day: Int, _ game: Int) -> Game {
        return Game()
    }
}

enum SplitType: Int {
    case spring = 0
    case summer = 1
    
    func toString() -> String {
        return ((self == .spring) ? "Spring" : "Summer")
    }
    
    static func from(string s: String) -> SplitType {
        let s = s.lowercased()
        let i = (s == "spring") ? 0 : 1
        
        return SplitType(rawValue: i)!
    }
}
