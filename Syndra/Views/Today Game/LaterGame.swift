//
//  LaterGame.swift
//  Syndra
//
//  Created by Mason Phillips on 7/19/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Parse
import GCDKit

class LaterGame: UIView {
    
    var game: Game!
    
    let blueIcon: PFImageView = PFImageView()
    let blueTeam: UILabel = UILabel()
    
    let redIcon: PFImageView = PFImageView()
    let redTeam: UILabel = UILabel()
    
    let time: UILabel = UILabel()
    
    init() {
        blueTeam.lineBreakMode = .byWordWrapping
        blueTeam.numberOfLines = 0
        blueTeam.textColor = .flatWhite
        
        redTeam.lineBreakMode = .byWordWrapping
        redTeam.numberOfLines = 0
        redTeam.textColor = .flatWhite
        redTeam.textAlignment = .right
        
        time.text = "Loading..."
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
    
    func configure(with g: Game) {
        game = g
        
        GCDBlock.async(.background) {
            do {
                try g.blueSide.fetchIfNeeded()
                try g.redSide.fetchIfNeeded()
                
                GCDBlock.async(.main, closure: {
                    self.blueIcon.file = g.blueSide.icon
                    self.blueIcon.loadInBackground()
                    
                    self.redIcon.file = g.redSide.icon
                    self.redIcon.loadInBackground()
                    
                    self.blueTeam.text = g.blueSide.abbreviation
                    self.redTeam.text = g.redSide.abbreviation
                })
            } catch let e {
                print("NextGame::configure failed to fetch blue/red side with error: \(e.localizedDescription)")
            }
        }
        
        time.text = g.gameTime.string(custom: "hh:mm a")
    }
    
    override func layoutSubviews() {
        blueIcon.anchorToEdge(.left, padding: 15, width: 50, height: 50)
        blueTeam.align(.toTheRightCentered, relativeTo: blueIcon, padding: 5, width: width * 0.4, height: 42)
        
        redIcon.anchorToEdge(.right, padding: 15, width: 50, height: 50)
        redTeam.align(.toTheLeftCentered, relativeTo: redIcon, padding: 5, width: width * 0.4, height: 42)
        
        time.anchorInCenter(width: 70, height: 21)
    }
}
