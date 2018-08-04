//
//  TeamTimeView.swift
//  Syndra
//
//  Created by Mason Phillips on 8/4/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class TeamTimeView: SyndraView {
    
    let blueSideView: SyndraView
    let blueSide: SyndraLabel
    let bicon   : UIImageView
    let bstats  : SyndraLabel
    let bvictory: SyndraLabel
    
    let redSideView: SyndraView
    let redSide : SyndraLabel
    let ricon   : UIImageView
    let rstats  : SyndraLabel
    let rvictory: SyndraLabel
    
    let dtLabel : SyndraLabel
    
    var gameState: GameState
    
    override init() {
        blueSideView = SyndraView()
        blueSideView.backgroundColor = UIColor.flatSkyBlue.withAlphaComponent(0.3)
        
        blueSide = SyndraLabel(.right, size: 20)
        blueSide.text = "Team Solo Mid"
        blueSide.multiline()
        blueSideView.addSubview(blueSide)
        
        bicon = UIImageView(image: UIImage(named: "TSM"))
        blueSideView.addSubview(bicon)
        
        bstats = SyndraLabel(.center, size: 15)
        bstats.textColor = .flatWhiteDark
        bstats.text = "5W - 7L"
        blueSideView.addSubview(bstats)
        
        bvictory = SyndraLabel(.left, size: 14)
        bvictory.text = "Victory"
        blueSideView.addSubview(bvictory)
        
        redSideView = SyndraView()
        redSideView.backgroundColor = UIColor.flatRed.withAlphaComponent(0.3)
        
        redSide = SyndraLabel(.left, size: 20)
        redSide.text = "Echo Fox"
        redSide.multiline()
        redSideView.addSubview(redSide)
        
        ricon = UIImageView(image: UIImage(named: "FOX"))
        redSideView.addSubview(ricon)
        
        rstats = SyndraLabel(.center, size: 15)
        rstats.textColor = .flatWhiteDark
        rstats.text = "7W - 5L"
        redSideView.addSubview(rstats)
        
        rvictory = SyndraLabel(.right, size: 14)
        rvictory.text = "Defeat"
        redSideView.addSubview(rvictory)
        
        dtLabel = SyndraLabel(.center, size: 18)
        dtLabel.multiline()
        dtLabel.text = "5 August\n1600"
        
        gameState = .blueVictory
        
        super.init()
        
        backgroundColor = .flatBlack
        
        addSubview(blueSideView)
        addSubview(redSideView)
        
        addSubview(dtLabel)
    }
    
    convenience init(left: String, lstats: String, right: String, rwins: String, state: GameState, datetime: String) {
        self.init()
        
        blueSide.text = left
        bstats.text = lstats
        
        redSide.text = right
        rstats.text = rwins
        
        gameState = state
        
        dtLabel.text = datetime
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        groupAndFill(group: .horizontal, views: [blueSideView, redSideView], padding: 0)
        
        bicon.anchorInCorner(.topRight, xPad: 3, yPad: 35, width: 80, height: 80)
        blueSide.alignAndFillWidth(align: .toTheLeftCentered, relativeTo: bicon, padding: 2, height: 50)
        bstats.alignAndFillWidth(align: .underMatchingRight, relativeTo: bicon, padding: 2, height: 18)
        bvictory.anchorInCorner(.bottomLeft, xPad: 15, yPad: 15, width: blueSideView.width / 2, height: 16)
        
        ricon.anchorInCorner(.topLeft, xPad: 3, yPad: 35, width: 80, height: 80)
        redSide.alignAndFillWidth(align: .toTheRightCentered, relativeTo: ricon, padding: 2, height: 50)
        rstats.alignAndFillWidth(align: .underMatchingLeft, relativeTo: ricon, padding: 2, height: 18)
        rvictory.anchorInCorner(.bottomRight, xPad: 15, yPad: 15, width: redSideView.width / 2, height: 16)
        
        dtLabel.anchorToEdge(.bottom, padding: 10, width: 80, height: 50)
        
        switch gameState {
        case .blueVictory:
            blueSideView.backgroundColor = UIColor.flatSkyBlue
            bvictory.text = "Victory"
            rvictory.text = "Defeat"
        case .redVictory:
            redSideView.backgroundColor = UIColor.flatRed
            bvictory.text = "Defeat"
            rvictory.text = "Victory"
        case .notPlayed:
            bvictory.isHidden = true
            rvictory.isHidden = true
        }
    }
}
