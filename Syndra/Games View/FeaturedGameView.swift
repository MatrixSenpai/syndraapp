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
    
    let week: UIView = UIView()
    let wl: UILabel = UILabel()
    let dl: UILabel = UILabel()

    init() {
        super.init(frame: CGRect())
        addSubview(blueSide)
        addSubview(redSide)
        
        week.addSubview(wl)
        wl.text = "Week 1"
        wl.textAlignment = .center
        wl.textColor = .flatWhite
        wl.font = UIFont.systemFont(ofSize: 17)
        
        week.addSubview(dl)
        dl.text = "Day 2"
        dl.textAlignment = .center
        dl.textColor = .flatWhite
        dl.font = UIFont.systemFont(ofSize: 14)
        
        week.backgroundColor = .flatGray
        //addSubview(week)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        blueSide.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: 160)
        redSide.anchorAndFillEdge(.right, xPad: 0, yPad: 0, otherSize: 160)
        
        week.anchorInCenter(width: 130, height: 140)
        
        
        let wshape = CAShapeLayer()
        wshape.frame = week.frame
        wshape.path = wpath.cgPath
        //week.layer.mask = wshape
        
        wl.anchorToEdge(.top, padding: 50, width: 70, height: 18)
        dl.align(.underCentered, relativeTo: wl, padding: 3, width: 50, height: 18)
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
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func draw(_ rect: CGRect) {
        path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 130, y: 0))
        path.addLine(to: CGPoint(x: 100, y: 140))
        path.addLine(to: CGPoint(x: 30, y: 140))
        path.close()
        
        UIColor.flatGray.setFill()
        path.fill()
    }
}
