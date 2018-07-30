//
//  AboutOnboard.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class AboutOnboard: OnboardChild {

    let head: SyndraLabel
    let body: SyndraLabel
    
    override init() {
        head = SyndraLabel(.center, size: 25)
        head.text = "About Syqen"
        
        body = SyndraLabel(.center)
        body.multiline()
        body.text = fetchString(forKey: "onboard_about")
        
        super.init()
        view.addSubview(head)
        view.addSubview(body)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        head.anchorAndFillEdge(.top, xPad: 0, yPad: 200, otherSize: 27)
        body.alignAndFillWidth(align: .underCentered, relativeTo: head, padding: 30, height: 150)
    }
}
