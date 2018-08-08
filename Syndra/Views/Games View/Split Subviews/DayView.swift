//
//  DayView.swift
//  Syndra
//
//  Created by Mason Phillips on 8/7/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class DayView: RoundedView {
    let label: UILabel
    
    var parent: SplitGamesViewController?
    
    var games: Array<gameView> = []
    
    init() {
        label = UILabel()
        label.text = "Day 1"
        label.textColor = .flatWhite
        
        for _ in 0..<5 {
            let g = gameView()
            games.append(g)
        }
        
        super.init(frame: CGRect())
        
        for g in games {
            addSubview(g)
        }
        
        self.addSubview(label)
        
        backgroundColor = .flatBlack
    }
    
    func handleSelection() {
        parent?.gameWasSelected()
    }
    
    override func layoutSubviews() {
        label.anchorAndFillEdge(.top, xPad: 15, yPad: 15, otherSize: 22)
        
        groupAgainstEdge(group: .vertical, views: games, againstEdge: .bottom, padding: 0, width: width, height: (height - 45) / 5)
    }
}
