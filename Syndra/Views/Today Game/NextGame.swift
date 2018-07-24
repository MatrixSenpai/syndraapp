//
//  NextGame.swift
//  Syndra
//
//  Created by Mason Phillips on 7/19/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Parse
import GCDKit

class NextGame: UIView {
    var game: Game?
    
    let blueIcon: PFImageView = PFImageView()
    let blueTeam: UILabel = UILabel()
    
    let redIcon: PFImageView = PFImageView()
    let redTeam: UILabel = UILabel()
    
    let time: UILabel = UILabel()
    let fullTime: UILabel = UILabel()
    let inTime: UILabel = UILabel()
    
    init() {
        blueIcon.layer.cornerRadius = 20
        blueIcon.backgroundColor = .flatSkyBlueDark
        
        blueTeam.lineBreakMode = .byWordWrapping
        blueTeam.numberOfLines = 0
        blueTeam.textColor = .flatWhite
        
        redIcon.layer.cornerRadius = 20
        redIcon.backgroundColor = .flatRedDark
        
        redTeam.lineBreakMode = .byWordWrapping
        redTeam.numberOfLines = 0
        redTeam.textColor = .flatWhite
        redTeam.textAlignment = .right
        
        time.font = UIFont.systemFont(ofSize: 26)
        time.textColor = .flatWhite
        
        fullTime.font = UIFont.systemFont(ofSize: 21)
        fullTime.textColor = .flatWhite
        
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
        
        backgroundColor = .flatGray
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
                    
                    self.blueTeam.text = g.blueSide.name
                    self.redTeam.text = g.redSide.name
                })
            } catch let e {
                print("NextGame::configure failed to fetch blue/red side with error: \(e.localizedDescription)")
            }
        }
        
        let r = g.gameTime
        
        fullTime.text = r.string(custom: "EEEE, MMMM dd")
        
        if(r.isToday) {
            time.text = "Today"
            let compare = r.component(.hour, to: Date())!
            inTime.text = "In \(abs(compare)) hours"
        } else if(r.isTomorrow) {
            time.text = "Tomorrow"
            inTime.text = r.string(custom: "hh:mm a")
        } else {
            time.text = "This Weekend"
            inTime.text = r.string(custom: "hh:mm a")
        }
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
