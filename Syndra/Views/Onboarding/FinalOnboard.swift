//
//  FinalOnboard.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class FinalOnboard: OnboardChild {

    let head: SyndraLabel
    
    let done: UIButton
    
    override init() {
        head = SyndraLabel(.center, size: 25)
        head.text = "Final Configuration"
        
        done = UIButton()
        done.titleLabel?.textColor = .flatWhite
        done.backgroundColor = .flatSkyBlue
        done.layer.cornerRadius = 16
        done.setTitle("Done", for: .normal)
        
        super.init()
        
        done.addTarget(self, action: #selector(FinalOnboard.doneWalkthrough), for: .touchUpInside)
        
        view.addSubview(head)
        view.addSubview(done)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        head.anchorAndFillEdge(.top, xPad: 0, yPad: 200, otherSize: 27)
        done.anchorAndFillEdge(.bottom, xPad: 60, yPad: 80, otherSize: 50)
    }

    @objc
    func doneWalkthrough() {
        (parent as! OnboardMaster).handleDone()
    }
}
