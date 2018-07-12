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
import Parse

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
