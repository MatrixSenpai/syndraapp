//
//  Enums.swift
//  Syndra
//
//  Created by Mason Phillips on 8/4/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

enum RosterPosition {
    case top, jg, mid, bot, supp, none
    
    func iconForPosition() -> UIImage? {
        switch self {
        case .top : return UIImage(named: "top")
        case .jg  : return UIImage(named: "jg")
        case .mid : return UIImage(named: "mid")
        case .bot : return UIImage(named: "bot")
        case .supp: return UIImage(named: "supp")
        case .none: return nil
        }
    }
}

enum GameState: Int {
    case notPlayed   = 0
    case blueVictory = 1
    case redVictory  = 2
}
