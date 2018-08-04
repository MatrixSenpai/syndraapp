//
//  RosterItemView.swift
//  Syndra
//
//  Created by Mason Phillips on 8/4/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class RosterItemView: SyndraView {

    let blueSide: SyndraLabel
    let bicon   : UIImageView
    
    let redSide : SyndraLabel
    let ricon   : UIImageView
    
    var position: RosterPosition
    let icon    : UIImageView
    
    override init() {
        blueSide = SyndraLabel()
        bicon = UIImageView(image: UIImage(named: "summ-noicon"))
        redSide = SyndraLabel(.right)
        ricon = UIImageView(image: UIImage(named: "summ-noicon"))
        position = .none
        icon = UIImageView()
        icon.backgroundColor = .flatBlackDark
        
        super.init()
        
        addSubview(blueSide)
        addSubview(bicon)
        addSubview(redSide)
        addSubview(ricon)
        addSubview(icon)
    }
    
    convenience init(left l: String, right r: String, position p: RosterPosition) {
        self.init()
        
        position = p
        
        blueSide.text = l
        redSide.text = r
        
        icon.image = p.iconForPosition()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        blueSide.anchorAndFillEdge(.left, xPad: 0, yPad: 0, otherSize: width / 2)
        blueSide.leftInset = 15.0
        
        redSide.anchorAndFillEdge(.right, xPad: 0, yPad: 0, otherSize: width / 2)
        redSide.rightInset = 15.0
        
        icon.anchorInCenter(width: 50, height: 50)
        
        bicon.align(.toTheLeftCentered, relativeTo: icon, padding: 2, width: 30, height: 30)
        ricon.align(.toTheRightCentered, relativeTo: icon, padding: 2, width: 30, height: 30)
        
        layer.addBorder(edge: .top, color: .flatWhite, thickness: ((position == .top) ? 1.0 : 0.5))
        layer.addBorder(edge: .bottom, color: .flatWhite, thickness: ((position == .supp) ? 1.0 : 0.5))
        
        blueSide.layer.addBorder(edge: .right, color: .flatWhite, thickness: 1.0)
    }
}
