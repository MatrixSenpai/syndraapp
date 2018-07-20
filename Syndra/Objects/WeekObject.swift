//
//  WeekObject.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import Parse

class Week: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Week"
    }
    
    var count: Int {
        return days.count
    }
    
    var gameCount: Int {
        var r = 0
        do {
            try days.forEach({ (d) in
                try d.fetchIfNeeded()
                r += d.games.count
            })
        } catch let e { print(e.localizedDescription) }
        return r
    }
    
    @NSManaged var week: Int
    @NSManaged var parent: Split
    @NSManaged var days: Array<Day>
    @NSManaged var start: Date
    
    func closest() {
        
    }
    
    subscript(_ day: Int, _ game: Int) -> Game {
        return days[day].games[game]
    }
}
