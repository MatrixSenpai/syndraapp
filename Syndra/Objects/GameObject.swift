//
//  GameObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class Game {
    let blue: Team
    let red : Team
    let time: String
    
    init(blueSide b: Team, redSide r: Team, time t: String) {
        blue = b
        red = r
        time = t
    }
}

struct NALCS {
    static let TL  = Team(name: "Team Liquid", usingAbbreviation: "TL", andIcon: "TL")
    static let OTG = Team(name: "OpTic Gaming", usingAbbreviation: "OTG", andIcon: "OTG")
    static let C9  = Team(name: "Cloud 9", usingAbbreviation: "C9", andIcon: "C9")
    static let FQ  = Team(name: "FlyQuest", usingAbbreviation: "FQ", andIcon: "FQ")
    static let TSM = Team(name: "Team Solo Mid", usingAbbreviation: "TSM", andIcon: "TSM")
    static let CG  = Team(name: "Clutch Gaming", usingAbbreviation: "CG", andIcon: "CG")
    static let TH  = Team(name: "100 Thieves", usingAbbreviation: "100", andIcon: "100")
    static let GGS = Team(name: "Golden Guardians", usingAbbreviation: "GGS", andIcon: "GGS")
    static let FOX = Team(name: "Echo Fox", usingAbbreviation: "FOX", andIcon: "FOX")
    static let CLG = Team(name: "Counter Logic Gaming", usingAbbreviation: "CLG", andIcon: "CLG")
}
