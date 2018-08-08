//
//  GameView.swift
//  Syndra
//
//  Created by Mason Phillips on 8/7/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class gameView: SyndraView {
    let blue: SyndraLabel
    let bicon: UIImageView
    let time: SyndraLabel
    let red: SyndraLabel
    let ricon: UIImageView
    
    let activate: UITapGestureRecognizer
    
    override init() {
        blue = SyndraLabel()
        blue.backgroundColor = UIColor.flatSkyBlue.withAlphaComponent(0.5)
        blue.text = "TSM"
        blue.leftInset = 5.0
        
        bicon = UIImageView(image: UIImage(named: "TSM"))
        
        time = SyndraLabel(.center)
        time.text = "1600"
        time.backgroundColor = .clear
        time.layer.borderColor = UIColor.flatWhite.cgColor
        time.layer.borderWidth = 1
        
        red = SyndraLabel(.right)
        red.backgroundColor = UIColor.flatRed.withAlphaComponent(0.5)
        red.text = "FOX"
        red.rightInset = 5.0
        
        ricon = UIImageView(image: UIImage(named: "FOX"))
        
        activate = UITapGestureRecognizer()
        activate.numberOfTapsRequired = 1
        activate.numberOfTouchesRequired = 1
        
        super.init()
        
        activate.addTarget(self, action: #selector(gameView.handleTap(sender:)))
        addGestureRecognizer(activate)
        
        addSubview(blue)
        addSubview(bicon)
        addSubview(time)
        addSubview(ricon)
        addSubview(red)
    }
    
    override func layoutSubviews() {
        time.anchorInCenter(width: 50, height: height)
        bicon.align(.toTheLeftCentered, relativeTo: time, padding: 5, width: 40, height: 40)
        ricon.align(.toTheRightCentered, relativeTo: time, padding: 5, width: 40, height: 40)
        
        blue.alignAndFillWidth(align: .toTheLeftCentered, relativeTo: time, padding: 0, height: height)
        red.alignAndFillWidth(align: .toTheRightCentered, relativeTo: time, padding: 0, height: height)
        
        
        blue.layer.addBorder(edge: .top, color: .flatWhite, thickness: 1)
        blue.layer.addBorder(edge: .bottom, color: .flatWhite, thickness: 1)
        
        red.layer.addBorder(edge: .top, color: .flatWhite, thickness: 1)
        red.layer.addBorder(edge: .bottom, color: .flatWhite, thickness: 1)
    }
    
    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        (superview as! DayView).handleSelection()
    }
}
