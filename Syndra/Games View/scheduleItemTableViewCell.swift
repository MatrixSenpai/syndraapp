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
    var time: UILabel
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        teamIcons = teamOverlayView(frame: CGRect())
        
        teamOne = UILabel()
        
        teamOneView = UIView()
        teamOneView.addSubview(teamOne)
        
        teamTwo = UILabel()
        teamTwo.textAlignment = .right
        
        teamTwoView = UIView()
        teamTwoView.addSubview(teamTwo)
        
        time = UILabel()
        time.textColor = .white
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(teamOneView)
        addSubview(teamTwoView)
        addSubview(teamIcons)
        addSubview(time)
        
        teamOneView.backgroundColor = GradientColor(.leftToRight, frame: frame, colors: [.flatSkyBlue, .flatWhite])
        teamTwoView.backgroundColor = GradientColor(.leftToRight, frame: frame, colors: [.flatWhite, .flatRed])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(game: Game) {
        /*teamOne.text = game.blueSide.abbreviation
        teamTwo.text = game.redSide.abbreviation
        
        teamIcons.teamOne.image = game.blueSide.icon()
        teamIcons.teamTwo.image = game.redSide.icon()
        
        //time.text = game.time
        */
        layoutSubviews()
    }
    
    override func layoutSubviews() {
        teamOneView.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: (width / 2) + 75)
        teamTwoView.anchorAndFillEdge(.right, xPad: 0, yPad: 0, otherSize: (width / 2) + 75)
        
        let redSidePath = UIBezierPath()
        redSidePath.move(to: CGPoint(x: width, y: height))
        redSidePath.addLine(to: CGPoint(x: 0, y: height))
        redSidePath.addLine(to: CGPoint(x: 150, y: 0))
        redSidePath.addLine(to: CGPoint(x: width, y: 0))
        redSidePath.close()
        
        let redSideShape = CAShapeLayer()
        redSideShape.frame = teamTwoView.bounds
        redSideShape.path = redSidePath.cgPath
        
        teamTwoView.layer.mask = redSideShape

        teamIcons.anchorInCenter(width: 100, height: 100)
        teamOne.anchorToEdge(.left, padding: 10, width: 50, height: 21)
        teamTwo.anchorToEdge(.right, padding: 10, width: 50, height: 21)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)
    }
    
}
