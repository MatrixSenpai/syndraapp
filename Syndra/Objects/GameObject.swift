//
//  GameObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Parse
import SwiftDate
import GCDKit

class Game: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Game"
    }
    
    @NSManaged var blueSide: Team
    @NSManaged var redSide : Team
    @NSManaged var gameOfDay: Int
    @NSManaged var parent: Day
    @NSManaged var gameTime: Date
    @NSManaged var state: Int
    
    func gameState() -> GameState {
        return GameState(rawValue: state)!
    }
    
    static func nextGame(local: Bool) -> Game {
        do {
            let today = DateInRegion()
            
            let gq = Game.query()!
            if(local) { gq.fromLocalDatastore() }
            gq.whereKey("gameTime", greaterThanOrEqualTo: today.absoluteDate)
            gq.order(byAscending: "gameTime")
            
            guard let g = try gq.getFirstObject() as? Game else { fatalError("static Game::nextGame failed to cast game back to type") }
            return g
            
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }
    
    func gameAfter(local: Bool) -> Game {
        do {
            let t = self.gameTime + 1.hour
            
            let gq = Game.query()!
            if(local) { gq.fromLocalDatastore() }
            gq.whereKey("gameTime", greaterThanOrEqualTo: t)
            gq.order(byAscending: "gameTime")
            
            guard let g = try gq.getFirstObject() as? Game else { fatalError("Game::gameAfter failed to cast game back to type") }
            return g
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }
}
