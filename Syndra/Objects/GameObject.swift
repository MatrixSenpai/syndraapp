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
    @NSManaged var time: Date
    @NSManaged var season: Int
    @NSManaged var split: Int
    @NSManaged var week: Int
    @NSManaged var day: Int
}
