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
    
    override var description: String {
        var r = ""
        
        r += "\(self.type().toString()) Split (ID: \(objectId ?? "<null>"))\n"
        r += "Season (parent): \(season.shortDescription)"
        r += "Start: \(start.string(format: .iso8601Auto))\n"
        r += "Weeks: 9"
        
        return r
    }
    
    var shortDescription: String {
        return objectId ?? "<null>"
    }
    
    var count: Int {
        return weeks.count
    }
        
    @NSManaged var split: Int
    @NSManaged var season: Season
    @NSManaged var weeks: Array<Week>
    @NSManaged var start: Date
    
    public func type() -> SplitType {
        return SplitType(rawValue: self.split - 1)!
    }
    
    subscript(_ week: Int) -> Week {
        do {
            let w = weeks[week]
            try w.fetchIfNeeded()
            return w
        } catch let e {
            print(e.localizedDescription)
        }
        return Week()
    }
    
    subscript(_ week: Int, _ day: Int) -> Day {
        do {
            let w = weeks[week]
            try w.fetchIfNeeded()
            let d = w.days[day]
            try d.fetchIfNeeded()
            return d
        } catch let e {
            print(e.localizedDescription)
        }
        return Day()
    }
    
    subscript(_ week: Int, _ day: Int, _ game: Int) -> Game {
        do {
            let d = self[week, day]
            let g = d.games[game]
            try g.fetchIfNeeded()
            
            try g.blueSide.fetchIfNeeded()
            try g.redSide.fetchIfNeeded()
            
            return g
        } catch let e {
            print(e.localizedDescription)
        }
        
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
