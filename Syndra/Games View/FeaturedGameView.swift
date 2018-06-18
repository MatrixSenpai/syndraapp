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
}

class blueSideView: UIView {
    var path: UIBezierPath!
    
    let icon: UIImageView = UIImageView(image: UIImage(named: "TSM"))
    let team: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        team.text = "TSM"
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
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
    
    let icon: UIImageView = UIImageView(image: UIImage(named: "FQ"))
    let team: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        team.text = "FQ"
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        week.text = "Week 1"
        week.textAlignment = .center
        week.textColor = .flatWhite
        week.font = UIFont.systemFont(ofSize: 17)
        addSubview(week)
        
        day.text = "Day 2"
        day.textAlignment = .center
        day.textColor = .flatWhite
        day.font = UIFont.systemFont(ofSize: 14)
        addSubview(day)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
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
        week.anchorToEdge(.top, padding: 50, width: 70, height: 18)
        day.align(.underCentered, relativeTo: week, padding: 3, width: 50, height: 18)
    }
}
