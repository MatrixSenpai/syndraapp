//
//  GameObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import SwiftyJSON

class Game {
    var gameOfDay: Int
    var blueSide: String
    var redSide : String
    
    init(GoD g: Int, blue b: String, red r: String) {
        gameOfDay = g
        blueSide = b
        redSide = r
    }
}

struct Day {
    let day: Int
    let games: Dictionary<Int, Game>
    
    var count: Int {
        return games.count
    }
    
    init() {
        day = 0
        games = [:]
    }
    
    init(day d: Int, games g: Dictionary<Int, Game>) {
        day = d
        games = g
    }
    
    subscript(_ i: Int) -> Game {
        get {
            return games[i + 1]!
        }
    }
}

struct Week {
    let week: Int
    let days: Dictionary<Int, Day>
    
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
    }
    
    init(week w: Int, days d: Dictionary<Int, Day>) {
        week = w
        days = d
    }
    
    subscript(_ i: Int) -> Day {
        get {
            return days[i + 1]!
        }
    }
}

struct Split {
    let split: SplitType
    var weeks: Dictionary<Int, Week>
    
    var count: Int {
        var c: Int = 0
        for w in weeks {
            c += w.value.count
        }
        
        return c
    }
    
    init() {
        split = .spring
        weeks = [:]
    }
    
    init(fromJSON j: JSON) {
        split = SplitType(rawValue: j["split"].int!)!
        self.weeks = [:]
        
        guard let games = j["games"].dictionary else { fatalError("Could not parse 'game' key") }
        
        for (k, v) in games {
            var days: Dictionary<Int, Day> = [:]
            
            guard let weeks = v.dictionary else { fatalError("Couldn't parse days for week \(k)") }
            
            for (kk, vv) in weeks {
                var inGames: Dictionary<Int, Game> = [:]
                
                guard let games = vv.dictionary else { fatalError("Couldn't parse games for day W\(k):D\(kk)") }
                
                for (kkk, vvv) in games {
                    if kkk == "start" { continue }
                    guard let red = vvv["redSide"].string  else { fatalError("Couldn't parse redside for game W\(k):D\(kk):G\(kkk)") }
                    guard let blu = vvv["blueSide"].string else { fatalError("Couldn't parse bluside for game W\(k):D\(kk):G\(kkk)") }
                    
                    let g = Game(GoD: Int(kkk)!, blue: blu, red: red)
                    
                    inGames[Int(kkk)!] = g
                    
                }
                
                let d = Day(day: Int(kk)!, games: inGames)
                days[Int(kk)!] = d
            }
            
            self.weeks[Int(k)!] = Week(week: Int(k)!, days: days)
        }
    }
    
    subscript(_ i: Int) -> Week {
        get {
            return weeks[i + 1]!
        }
    }
}

enum SplitType: Int {
    case spring = 0
    case summer = 1
    
    func toString() -> String {
        return ((self == .spring) ? "Spring" : "Summer")
    }
}
