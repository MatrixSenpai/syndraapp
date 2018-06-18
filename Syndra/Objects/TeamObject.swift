//
//  TeamObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import SwiftyJSON

class Team {
    var name: String
    var abbreviation: String
    var iconName: String
    
    init() {
        name = ""
        abbreviation = ""
        iconName = ""
    }
    
    init(with n: String, usingAbbrev a: String, andIcon i: String) {
        name = n
        abbreviation = a
        iconName = i
    }

    func icon() -> UIImage? {
        return UIImage(named: iconName)
    }
    
    func equal(to n: String) -> Bool {
        if name == n { return true }
        if abbreviation == n { return true }
        return false
    }
}

struct NALCS {
    public static let access: NALCS = NALCS()
    static let TL  = Team(with: "Team Liquid", usingAbbrev: "TL", andIcon: "TL")
    static let THV = Team(with: "100 Thieves", usingAbbrev: "100", andIcon: "100")
    static let TSM = Team(with: "Team Solo Mid", usingAbbrev: "TSM", andIcon: "TSM")
    static let C9  = Team(with: "Cloud9", usingAbbrev: "C9", andIcon: "C9")
    static let CLG = Team(with: "Counter Logic Gaming", usingAbbrev: "CLG", andIcon: "CLG")
    static let CG  = Team(with: "Clutch Gaming", usingAbbrev: "CG", andIcon: "CG")
    static let FOX = Team(with: "Echo Fox", usingAbbrev: "FOX", andIcon: "FOX")
    static let FQ  = Team(with: "FlyQuest", usingAbbrev: "FQ", andIcon: "FQ")
    static let GGS = Team(with: "Golden Guardians", usingAbbrev: "GGS", andIcon: "GGS")
    static let OTG = Team(with: "OpTic Gaming", usingAbbrev: "OTG", andIcon: "OTG")

    private let teams: Array<Team> = [NALCS.TL, NALCS.THV, NALCS.TSM, NALCS.C9, NALCS.CLG, NALCS.CG, NALCS.FOX, NALCS.FQ, NALCS.GGS, NALCS.OTG]
    
    public func find(using n: String) -> Team {
        for t in teams {
            if t.equal(to: n) { return t }
        }
        
        return Team() // This will never happen, just adding so it shuts up
    }
}
