//
//  FeaturedGameView.swift
//  Syndra
//
//  Created by Mason Phillips on 6/15/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon
import CoreGraphics
import Parse

class FeaturedGameView: UIView {
    
    let blueSide: blueSideView = blueSideView(frame: CGRect())
    let redSide: redSideView = redSideView(frame: CGRect())
    
    let week: weekView = weekView(frame: CGRect())

    init() {
        super.init(frame: CGRect())
        addSubview(blueSide)
        addSubview(redSide)
        addSubview(week)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        blueSide.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: 160)
        redSide.anchorAndFillEdge(.right, xPad: 0, yPad: 0, otherSize: 160)
        
        week.anchorInCenter(width: 150, height: 140)
    }
    
    func configure(game g: Game, week w: Int, day d: Int) {
        blueSide.reportTeams(team: g.blueSide)
        redSide.reportTeams(team: g.redSide)
        
        week.reportTime(week: w, day: d, game: g.gameOfDay)
    }
}

class blueSideView: UIView {
    var path: UIBezierPath!
    
    let icon: PFImageView = PFImageView()
    let team: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        team.font = UIFont.systemFont(ofSize: 13)
        team.textColor = .white
        
        addSubview(icon)
        addSubview(team)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.anchorInCorner(.bottomLeft, xPad: 5, yPad: 5, width: 70, height: 70)
        team.anchorInCorner(.bottomRight, xPad: 15, yPad: 5, width: 50, height: 30)
    }
    
    func reportTeams(team t: Team) {
        icon.file = t.icon
        icon.loadInBackground()
        team.text = t.abbreviation
        
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard let _ = UIGraphicsGetCurrentContext() else { print("Graphics context is invalid"); return }
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 90, y: 0))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.close()

        UIColor.flatSkyBlueDark.setFill()
        path.fill()
    }
}

class redSideView: UIView {
    var path: UIBezierPath!
    
    let icon: PFImageView = PFImageView()
    let team: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        team.font = UIFont.systemFont(ofSize: 13)
        team.textColor = .white
        team.textAlignment = .right
        
        addSubview(icon)
        addSubview(team)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        icon.anchorInCorner(.bottomRight, xPad: 5, yPad: 5, width: 70, height: 70)
        team.anchorInCorner(.bottomLeft, xPad: 15, yPad: 5, width: 50, height: 30)
    }
    
    func reportTeams(team t: Team) {
        icon.file = t.icon
        icon.loadInBackground()
        team.text = t.abbreviation
        
        layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        guard let _ = UIGraphicsGetCurrentContext() else { print("Graphics context is invalid"); return }
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: width, y: 0))
        path.addLine(to: CGPoint(x: 70, y: 0))
        path.close()

        UIColor.flatRedDark.setFill()
        path.fill()
    }
}

class weekView: UIView {
    var path: UIBezierPath!
    
    let week: UILabel = UILabel()
    let day : UILabel = UILabel()
    let game: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        week.textAlignment = .center
        week.textColor = .flatWhite
        week.font = UIFont.systemFont(ofSize: 17)
        addSubview(week)
        
        day.textAlignment = .center
        day.textColor = .flatWhite
        day.font = UIFont.systemFont(ofSize: 14)
        addSubview(day)
        
        game.textAlignment = .center
        game.textColor = .flatWhite
        game.font = UIFont.systemFont(ofSize: 13)
        addSubview(game)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    func reportTime(week w: Int, day d: Int, game g: Int) {
        week.text = "Week \(w + 1)"
        day.text = "Day \(d + 1)"
        game.text = "Game \(g + 1)"
    }
    
    override func draw(_ rect: CGRect) {
        guard let _ = UIGraphicsGetCurrentContext() else { print("Graphics context is invalid"); return }
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 30))
        path.addLine(to: CGPoint(x: width, y: 30))
        path.addLine(to: CGPoint(x: 105, y: height - 20))
        path.addLine(to: CGPoint(x: 45, y: height - 20))
        path.close()
        
        UIColor.flatGray.setFill()
        path.fill()
    }
    
    override func layoutSubviews() {
        week.anchorToEdge(.top, padding: 40, width: 70, height: 18)
        day.align(.underCentered, relativeTo: week, padding: 3, width: 50, height: 18)
        game.align(.underCentered, relativeTo: day, padding: 3, width: 50, height: 15)
    }
}
