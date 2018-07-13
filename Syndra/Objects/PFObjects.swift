//
//  PFObjects.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import Parse

class PFSeason: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Season"
    }
    
    @NSManaged var name: String
    @NSManaged var year: Int
    @NSManaged var start: Date
    @NSManaged var spring: PFSplit
    @NSManaged var summer: PFSplit
}

class PFSplit: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Split"
    }
    
    @NSManaged var split: Int
    @NSManaged var season: PFSeason
    @NSManaged var weeks: PFRelation<PFWeek>
    @NSManaged var start: Date
    
    public func type() -> SplitType {
        return SplitType(rawValue: self.split - 1)!
    }
}

class PFWeek: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Week"
    }
    
    @NSManaged var week: Int
    @NSManaged var split: PFSplit
    @NSManaged var days: PFRelation<PFObject>
    @NSManaged var start: Date
}

class PFDay: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Day"
    }
    
    @NSManaged var day: Int
    @NSManaged var week: PFWeek
    @NSManaged var games: PFRelation<PFObject>
    @NSManaged var start: Date
}

class PFGame: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Game"
    }
    
    @NSManaged var blueSide: PFTeam
    @NSManaged var redSide : PFTeam
    @NSManaged var gameOfDay: Int
    @NSManaged var day: PFDay
    @NSManaged var gameTime: Date
    @NSManaged var state: Int
    
    func gameState() -> GameState {
        return GameState(rawValue: state)!
    }
}

class PFTeam: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Team"
    }
}

enum GameState: Int {
    case notPlayed = 0
    case blueSideWin = 1
    case redSideWin = 2
}
