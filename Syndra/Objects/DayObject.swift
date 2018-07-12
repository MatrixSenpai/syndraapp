//
//  DayObject.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import SwiftDate

struct Day {
    let day: Int
    let games: Dictionary<Int, Game>
    let dayStart: DateInRegion
    
    var count: Int {
        return games.count
    }
    
    init() {
        day = 0
        games = [:]
        dayStart = DateInRegion()
    }
    
    init(day d: Int, games g: Dictionary<Int, Game>, startsAt s: DateInRegion) {
        day = d
        games = g
        dayStart = s
    }
    
    func firstGame() -> Game {
        return games[0]!
    }
    
    func time() -> String {
        return dayStart.string(format: DateFormat.custom("EEEE, MMMM dd"))
    }
    
    subscript(_ i: Int) -> Game {
        get {
            return games[i]!
        }
    }
}
