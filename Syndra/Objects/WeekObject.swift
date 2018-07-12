//
//  WeekObject.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import SwiftDate

struct Week {
    let week: Int
    let days: Dictionary<Int, Day>
    let weekStart: DateInRegion
    
    var count: Int {
        var c: Int = 0
        for d in days {
            c += d.value.count
        }
        
        return c
    }
    
    init() {
        week = 0
        days = [:]
        weekStart = DateInRegion()
    }
    
    init(week w: Int, days d: Dictionary<Int, Day>) {
        week = w
        days = d
        weekStart = d[0]!.dayStart
    }
    
    func dates() -> String {
        let done = days[0]!
        let dtwo = days[1]!
        
        let dos: String = done.dayStart.string(custom: "MMMM dd")
        var dts: String = ""
        
        if done.dayStart.month != dtwo.dayStart.month {
            dts = dtwo.dayStart.string(custom: "MMMM dd")
        } else {
            dts = dtwo.dayStart.string(custom: "dd")
        }
        
        return "\(dos) - \(dts)"
    }
    
    func gamesCount() -> Int {
        var r = 0
        for (_, v) in days {
            r += v.count
        }
        
        return r
    }
    
    func firstGame() -> Game {
        return days[0]!.firstGame()
    }
    
    subscript(_ i: Int) -> Day {
        get {
            return days[i]!
        }
    }
}
