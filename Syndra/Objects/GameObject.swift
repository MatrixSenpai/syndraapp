//
//  GameObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Parse

class Game: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Game"
    }
    
    @NSManaged var blueSide: Team
    @NSManaged var redSide : Team
    @NSManaged var gameOfDay: Int
    @NSManaged var day: Day
    @NSManaged var gameTime: Date
    @NSManaged var state: Int
    
    func gameState() -> GameState {
        return GameState(rawValue: state)!
    }
}
