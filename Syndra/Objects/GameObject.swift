//
//  GameObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import SwiftyJSON
import SwiftDate

struct Game {
    var gameOfDay: Int
    var blueSide: Team
    var redSide : Team
    var gameTime: DateInRegion
    
    init() {
        gameOfDay = 0
        blueSide = Team()
        redSide = Team()
        gameTime = DateInRegion()
    }
    
    init(GoD g: Int, blue b: Team, red r: Team, andTime t: DateInRegion) {
        gameOfDay = g
        blueSide = b
        redSide = r
        gameTime = t
    }
    
    func time() -> String {
        return gameTime.string(format: DateFormat.custom("MMMM dd, hh:mm a"))
    }
}

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
        
        return "\(dos) - \(dts) (Saturday/Sunday)"
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
                
                let st = games["start"]?.string
                let start = DateInRegion(string: st!, format: DateFormat.iso8601Auto)!
                
                for (kkk, vvv) in games {
                    if kkk == "start" { continue }
                    guard let red = vvv["redSide"].string  else { fatalError("Couldn't parse redside for game W\(k):D\(kk):G\(kkk)") }
                    guard let blu = vvv["blueSide"].string else { fatalError("Couldn't parse bluside for game W\(k):D\(kk):G\(kkk)") }
                    
                    let time = start + (Int(kkk)! - 1).hours
                    
                    let r = NALCS.access.find(using: red)
                    let b = NALCS.access.find(using: blu)
                    let g = Game(GoD: Int(kkk)!, blue: b, red: r, andTime: time)
                    
                    inGames[Int(kkk)!] = g
                }
                
                let d = Day(day: Int(kk)!, games: inGames, startsAt: start)
                days[Int(kk)!] = d
            }
            
            self.weeks[Int(k)!] = Week(week: Int(k)!, days: days)
        }
    }
    
    func nextGame() -> (Game, Int, Int) {
        // Return Int/Int will be week,day
        
        //let today = DateInRegion()
        
        let today = DateInRegion(string: "2018-06-23T16:00:00-0600", format: .iso8601Auto)!

        // Sort the data
        let wwww = weeks.sorted {
            return $0.key < $1.key
        }
        
        for w in wwww {
            if today.isEqual(to: w.value.weekStart) { return (w.value.firstGame(), w.key, 1) }
            
            // sort days
            let dddd = w.value.days.sorted {
                return $0.key < $1.key
            }
            
            for d in dddd {
                if today.isEqual(to: d.value.dayStart) { return (d.value.firstGame(), w.key, d.key) }
                
                // sort games
                let gggg = d.value.games.sorted { return $0.key < $1.key }
                
                for g in gggg {
                    // since data is sorted, this should stop at the first object matching
                    if today.isBefore(date: g.value.gameTime, orEqual: true, granularity: .hour) { return (g.value, w.key, d.key) }
                }
            }
        }

//        return (most, week, most.gameOfDay)
        fatalError("Game did not return")
    }
    
    subscript(week w: Int, game g: Int) -> Game {
        get {
            let week = weeks[w]!
            var d: Day!
            
            if g >= 0 && g <= 4 {
                d = week[0]
                return d[g]
            } else if g >= 5 && g <= 9 {
                d = week[1]
                return d[g-5]
            } else {
                fatalError("Got bad game value")
            }
        }
    }
    
    subscript(week w: Int, day d: Bool) -> String {
        get {
            let week = weeks[w]!

            return week[((d) ? 0 : 1)].time()
        }
    }
    
    subscript(week w: Int) -> String {
        get {
            let week = weeks[w]!
            
            return week.dates()
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
