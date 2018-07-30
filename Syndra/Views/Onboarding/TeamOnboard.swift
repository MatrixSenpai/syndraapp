//
//  TeamOnboard.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import McPicker

class TeamOnboard: OnboardChild {

    let head: SyndraLabel
    let team: SyndraLabel
    let icon: UIImageView
    
    let pick: UIButton
    
    override init() {
        head = SyndraLabel(.center, size: 25)
        head.text = "Choose Your Team"
        
        team = SyndraLabel(.center, size: 32)
        team.text = "No Team Yet..."
        
        icon = UIImageView()
        
        pick = UIButton()
        pick.setTitle("Pick a Team", for: .normal)
        pick.backgroundColor = .flatSkyBlue
        pick.layer.cornerRadius = 16
        pick.titleLabel?.textColor = .flatWhite
        
        super.init()
        
        pick.addTarget(self, action: #selector(TeamOnboard.showPicker), for: .touchUpInside)
        view.addSubview(pick)
        
        view.addSubview(team)
        view.addSubview(icon)
        view.addSubview(head)
    }
    
    @objc
    func showPicker() {
        McPicker.show(data: [["100 Thieves", "Cloud9", "Clutch Gaming", "Counter Logic Gaming", "Echo Fox", "FlyQuest", "Golden Guardians", "OpTic Gaming", "Team Liquid", "Team Solo Mid"]]) { [weak self] (selections: [Int: String]) in
            if let name =  selections[0] {
                self?.team.text = name
                
                let i: String
                switch name {
                case "100 Thieves": i = "100"
                case "Cloud9": i = "C9"
                case "Clutch Gaming": i = "CG"
                case "Counter Logic Gaming": i = "CLG"
                case "Echo Fox": i = "FOX"
                case "FlyQuest": i = "FQ"
                case "Golden Guardians": i = "GGS"
                case "OpTic Gaming": i = "OPT"
                case "Team Liquid": i = "TL"
                case "Team Solo Mid": i = "TSM"
                default: i = "TSM"
                }
                
                let ii = UIImage(named: i)
                self?.icon.image = ii
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        head.anchorAndFillEdge(.top, xPad: 0, yPad: 200, otherSize: 27)
        team.alignAndFillWidth(align: .underCentered, relativeTo: head, padding: 50, height: 34)
        icon.align(.underCentered, relativeTo: team, padding: 20, width: 120, height: 120)
        
        pick.anchorAndFillEdge(.bottom, xPad: 60, yPad: 80, otherSize: 50)
    }

}
