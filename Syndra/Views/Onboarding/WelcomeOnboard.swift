//
//  WelcomeOnboard.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class WelcomeOnboard: OnboardChild {
    
    let head: SyndraLabel
    let name: SyndraLabel
    let body: SyndraLabel
    
    override init() {
        head = SyndraLabel(.center, size: 25)
        head.text = "Welcome to Syqen"
        
        name = SyndraLabel(.center, size: 14)
        name.text = "(sigh-ken)"
        
        body = SyndraLabel(.center)
        body.multiline()
        body.text = fetchString(forKey: "onboard_welcome")
        
        super.init()
        
        view.addSubview(head)
        view.addSubview(name)
        view.addSubview(body)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        head.anchorAndFillEdge(.top, xPad: 0, yPad: 200, otherSize: 27)
        name.alignAndFillWidth(align: .underCentered, relativeTo: head, padding: 10, height: 16)
        body.alignAndFillWidth(align: .underCentered, relativeTo: name, padding: 30, height: 100)
    }
}
