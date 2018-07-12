//
//  todayGameViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 7/7/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon
import SwiftDate

class todayGameViewController: UIViewController {

//    let game: Game
    
    let todayGame: NextGame
    
    let todayLabel: UILabel
    let allGames: UIButton
    
    let laterLabel: UILabel
    
    let ngone: LaterGame
    let ngtwo: LaterGame
    
    init() {
        //game = GamesCommunicator.sharedInstance.nextGame().0
        
        let b = Team(with: "Team Solo Mid", usingAbbrev: "TSM", andIcon: "TSM")
        let r = Team(with: "FlyQuest", usingAbbrev: "FQ", andIcon: "FQ")
        let g = Game(GoD: 1, blue: b, red: r, andTime: DateInRegion())
        
        todayGame = NextGame(g)
        
        todayLabel = UILabel()
        todayLabel.textColor = .flatWhite
        todayLabel.text = "Now Playing"
        todayLabel.font = UIFont.systemFont(ofSize: 30)
        
        allGames = UIButton()
        allGames.setTitle("See All Games \u{f356}", for: .normal)
        allGames.setTitleColor(.flatWhite, for: .normal)
        allGames.backgroundColor = .flatSkyBlue
        allGames.titleLabel?.font = FASOLID_UIFONT
        allGames.layer.cornerRadius = 15
        
        laterLabel = UILabel()
        laterLabel.text = "Later Today"
        laterLabel.textColor = .flatWhite
        laterLabel.font = UIFont.systemFont(ofSize: 25)
        
        ngone = LaterGame(g)
        ngtwo = LaterGame(g)
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(todayGame)
        view.addSubview(todayLabel)
        view.addSubview(allGames)
        
        view.addSubview(laterLabel)
        
        view.addSubview(ngone)
        view.addSubview(ngtwo)
        
        allGames.addTarget(self, action: #selector(todayGameViewController.moveToGames), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    override func viewWillLayoutSubviews() {
        todayLabel.anchorAndFillEdge(.top, xPad: 20, yPad: 60, otherSize: 32)
        
        todayGame.align(.underCentered, relativeTo: todayLabel, padding: 20, width: view.width * 0.85, height: view.height * 0.35)
        
        allGames.anchorAndFillEdge(.bottom, xPad: 20, yPad: 40, otherSize: 50)
        
        laterLabel.alignAndFillWidth(align: .underCentered, relativeTo: todayGame, padding: 30, height: 27)
        
        ngone.align(.underCentered, relativeTo: laterLabel, padding: 25, width: view.width * 0.85, height: 70)
        ngtwo.align(.underCentered, relativeTo: ngone, padding: 15, width: view.width * 0.85, height: 70)
    }
    
    @objc
    func moveToGames() {
        WindowManager.sharedInstance.move(to: .games)
    }
}

class NextGame: UIView {
    let game: Game
    
    let blueIcon: UIImageView = UIImageView()
    let blueTeam: UILabel = UILabel()
    
    let redIcon: UIImageView = UIImageView()
    let redTeam: UILabel = UILabel()
    
    let time: UILabel = UILabel()
    let fullTime: UILabel = UILabel()
    let inTime: UILabel = UILabel()
    
    init(_ g: Game) {
        game = g
        
        blueIcon.image = g.blueSide.icon()
        blueIcon.layer.cornerRadius = 20
        blueIcon.backgroundColor = .flatSkyBlueDark
        
        blueTeam.text = g.blueSide.name
        blueTeam.lineBreakMode = .byWordWrapping
        blueTeam.numberOfLines = 0
        blueTeam.textColor = .flatWhite
        
        redIcon.image = g.redSide.icon()
        redIcon.layer.cornerRadius = 20
        redIcon.backgroundColor = .flatRedDark
        
        redTeam.text = g.redSide.name
        redTeam.lineBreakMode = .byWordWrapping
        redTeam.numberOfLines = 0
        redTeam.textColor = .flatWhite
        redTeam.textAlignment = .right
        
        time.text = "Today"
        time.font = UIFont.systemFont(ofSize: 26)
        time.textColor = .flatWhite
        
        fullTime.text = "July 7th, 5:00 PM"
        fullTime.font = UIFont.systemFont(ofSize: 21)
        fullTime.textColor = .flatWhite
        
        inTime.text = "2 hours from now"
        inTime.font = UIFont.systemFont(ofSize: 15)
        inTime.textColor = .flatWhite
        
        super.init(frame: CGRect())
        
        addSubview(blueIcon)
        addSubview(redIcon)
        addSubview(blueTeam)
        addSubview(redTeam)
        
        addSubview(time)
        addSubview(fullTime)
        addSubview(inTime)
    
        backgroundColor = .flatGreen
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        blueIcon.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: 70, height: 70)
        blueTeam.align(.underMatchingLeft, relativeTo: blueIcon, padding: 10, width: width * 0.3, height: 42)
        
        redIcon.anchorInCorner(.topRight, xPad: 15, yPad: 15, width: 70, height: 70)
        redTeam.align(.underMatchingRight, relativeTo: redIcon, padding: 10, width: width * 0.3, height: 42)
        
        inTime.anchorAndFillEdge(.bottom, xPad: 20, yPad: 20, otherSize: 17)
        fullTime.align(.aboveCentered, relativeTo: inTime, padding: 10, width: inTime.width, height: 23)
        time.align(.aboveCentered, relativeTo: fullTime, padding: 10, width: inTime.width, height: 28)
        
        layer.cornerRadius = 15
    }
}

class LaterGame: UIView {
    let game: Game
    
    let blueIcon: UIImageView = UIImageView()
    let blueTeam: UILabel = UILabel()
    
    let redIcon: UIImageView = UIImageView()
    let redTeam: UILabel = UILabel()
    
    let time: UILabel = UILabel()
    
    init(_ g: Game) {
        game = g
        
        blueIcon.image = g.blueSide.icon()
        
        blueTeam.text = g.blueSide.abbreviation
        blueTeam.lineBreakMode = .byWordWrapping
        blueTeam.numberOfLines = 0
        blueTeam.textColor = .flatWhite
        
        redIcon.image = g.redSide.icon()
        
        redTeam.text = g.redSide.abbreviation
        redTeam.lineBreakMode = .byWordWrapping
        redTeam.numberOfLines = 0
        redTeam.textColor = .flatWhite
        redTeam.textAlignment = .right
        
        time.text = "7:00 PM"
        time.font = UIFont.systemFont(ofSize: 15)
        time.textColor = .flatWhite
        time.textAlignment = .center
        
        super.init(frame: CGRect())
    
        addSubview(blueIcon)
        addSubview(blueTeam)
        addSubview(redIcon)
        addSubview(redTeam)
        
        addSubview(time)
     
        backgroundColor = .flatGreenDark
        layer.cornerRadius = 15
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        blueIcon.anchorToEdge(.left, padding: 15, width: 50, height: 50)
        blueTeam.align(.toTheRightCentered, relativeTo: blueIcon, padding: 5, width: width * 0.4, height: 42)
        
        redIcon.anchorToEdge(.right, padding: 15, width: 50, height: 50)
        redTeam.align(.toTheLeftCentered, relativeTo: redIcon, padding: 5, width: width * 0.4, height: 42)
        
        time.anchorInCenter(width: 70, height: 21)
    }
}