//
//  scheduleItemTableViewCell.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon
import ChameleonFramework

class scheduleItemTableViewCell: UITableViewCell {
    
    var teamIcons: teamOverlayView
    var teamOne: UILabel
    var teamOneView: UIView
    var teamTwo: UILabel
    var teamTwoView: UIView
    
    var teamsView: UIView
    
    var time: UILabel
    var timeView: UIView
    
    var gameHeader: UILabel
    var gameHeaderView: UIView
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        teamsView = UIView()
        
        teamOne = UILabel()
        teamOne.numberOfLines = 0
        teamOne.lineBreakMode = .byWordWrapping
        teamOne.textColor = UIColor.flatSkyBlue.darken(byPercentage: 0.5)
        
        teamOneView = UIView()
        teamOneView.addSubview(teamOne)

        teamsView.addSubview(teamOneView)
        
        teamTwo = UILabel()
        teamTwo.textAlignment = .right
        teamTwo.numberOfLines = 0
        teamTwo.lineBreakMode = .byWordWrapping
        teamTwo.textColor = UIColor.flatRed.darken(byPercentage: 0.5)
        
        teamTwoView = UIView()
        teamTwoView.addSubview(teamTwo)

        teamsView.addSubview(teamTwoView)
        
        teamIcons = teamOverlayView(frame: CGRect())
        teamsView.addSubview(teamIcons)
        
        timeView = UIView()
        timeView.backgroundColor = .flatNavyBlue
        
        time = UILabel()
        time.textColor = .flatWhite
        time.textAlignment = .center
        timeView.addSubview(time)
        
        gameHeaderView = UIView()
        gameHeaderView.backgroundColor = .flatNavyBlueDark
        
        gameHeader = UILabel()
        gameHeader.textAlignment = .center
        gameHeader.textColor = .flatWhite
        gameHeaderView.addSubview(gameHeader)
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        teamOneView.backgroundColor = GradientColor(.leftToRight, frame: frame, colors: [.flatSkyBlue, .flatWhite])
        teamTwoView.backgroundColor = GradientColor(.leftToRight, frame: frame, colors: [.flatWhite, .flatRed])

        addSubview(teamsView)
        addSubview(timeView)
        addSubview(gameHeaderView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(game: Game) {
//        teamOne.text = game.blueSide.name
//        teamTwo.text = game.redSide.name
//        
//        teamIcons.teamOne.image = game.blueSide.icon()
//        teamIcons.teamTwo.image = game.redSide.icon()
//        
//        gameHeader.text = "Game \(game.gameOfDay + 1)"
//        
//        var gtime = game.time()
//        if game.gameOfDay != 0 { gtime += " (approx)"}
//        time.text = gtime

        layoutSubviews()
    }
    
    override func layoutSubviews() {
        gameHeaderView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 50)
        gameHeader.fillSuperview()
        
        teamsView.alignAndFillWidth(align: .underCentered, relativeTo: gameHeaderView, padding: 0, height: 150)
        
        teamOneView.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: (width / 2) + 75)
        teamTwoView.anchorAndFillEdge(.right, xPad: 0, yPad: 0, otherSize: (width / 2) + 75)
        
        let w = teamsView.width
        let h = teamsView.height
        
        let redSidePath = UIBezierPath()
        redSidePath.move(to: CGPoint(x: 150, y: 0))
        redSidePath.addLine(to: CGPoint(x: 0, y: h))
        redSidePath.addLine(to: CGPoint(x: w, y: h))
        redSidePath.addLine(to: CGPoint(x: w, y: 0))
        redSidePath.close()
        
        let redSideShape = CAShapeLayer()
        redSideShape.frame = teamTwoView.bounds
        redSideShape.path = redSidePath.cgPath
        
        teamTwoView.layer.mask = redSideShape

        teamIcons.anchorInCenter(width: 100, height: 100)
        teamOne.anchorToEdge(.left, padding: 10, width: 80, height: teamOneView.height)
        teamTwo.anchorToEdge(.right, padding: 10, width: 80, height: teamTwoView.height)
        
        timeView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 50)
        time.fillSuperview()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
}
