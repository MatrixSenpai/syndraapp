//
//  teamOverlayView.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon

class teamOverlayView: UIView {
    
    var teamOne: UIImageView
    var teamTwo: UIImageView
    
    override init(frame: CGRect) {
        teamOne = UIImageView()
        teamTwo = UIImageView()
        
        super.init(frame: frame)
        
        addSubview(teamOne)
        addSubview(teamTwo)
    }
    
    init(one: UIImage?, two: UIImage?) {
        teamOne = UIImageView(image: one)
        teamTwo = UIImageView(image: two)
        
        super.init(frame: CGRect())
        
        addSubview(teamOne)
        addSubview(teamTwo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        teamOne.fillSuperview()
        teamTwo.fillSuperview()

        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: width, y: 0.0))
        path.addLine(to: CGPoint(x: 0.0, y: height))
        path.close()
        
        let maskOne = CAShapeLayer()
        maskOne.frame = bounds
        maskOne.path = path.cgPath
        teamOne.layer.mask = maskOne
        
        let ptwo = UIBezierPath()
        ptwo.move(to: CGPoint(x: width, y: height))
        ptwo.addLine(to: CGPoint(x: width, y: 0.0))
        ptwo.addLine(to: CGPoint(x: 0.0, y: height))
        ptwo.close()
        
        let maskTwo = CAShapeLayer()
        maskTwo.frame = bounds
        maskTwo.path = ptwo.cgPath
        teamTwo.layer.mask = maskTwo
    }

}
