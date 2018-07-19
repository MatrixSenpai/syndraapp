//
//  TeamObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Parse

class Team: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var abbreviation: String
    @NSManaged var icon: PFFile
    
    static func parseClassName() -> String {
        return "Team"
    }
}

enum GameState: Int {
    case notPlayed = 0
    case blueSideWin = 1
    case redSideWin = 2
}
