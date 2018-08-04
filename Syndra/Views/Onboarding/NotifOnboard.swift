//
//  NotifOnboard.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import arek

class NotifOnboard: OnboardChild {

    let head: SyndraLabel
    let body: SyndraLabel
    
    let allow: UIButton
    let skip: UIButton
    
    override init() {
        head = SyndraLabel(.center, size: 25)
        head.text = "Permission Time!"
        
        body = SyndraLabel(.center)
        body.multiline()
        body.text = fetchString(forKey: "onboard_notif")
        
        allow = UIButton()
        allow.setTitle("Allow", for: .normal)
        allow.backgroundColor = .flatSkyBlue
        allow.titleLabel?.textColor = .flatWhite
        allow.layer.cornerRadius = 16
        
        skip = UIButton()
        skip.setTitle("Don't Allow", for: .normal)
        skip.backgroundColor = .flatRedDark
        skip.titleLabel?.textColor = .flatWhite
        skip.layer.cornerRadius = 16
        
        super.init()
        
        allow.addTarget(self, action: #selector(NotifOnboard.presentNotification), for: .touchUpInside)
        skip.addTarget(self, action: #selector(NotifOnboard.skipAllow), for: .touchUpInside)
        
        view.addSubview(head)
        view.addSubview(body)
        
        view.addSubview(allow)
        view.addSubview(skip)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        head.anchorAndFillEdge(.top, xPad: 0, yPad: 200, otherSize: 27)
        body.alignAndFillWidth(align: .underCentered, relativeTo: head, padding: 20, height: 100)
        
        allow.anchorInCorner(.bottomRight, xPad: 60, yPad: 80, width: 120, height: 50)
        skip.anchorInCorner(.bottomLeft, xPad: 60, yPad: 80, width: 120, height: 50)
    }

    @objc
    func presentNotification() {
        let permission = ArekNotifications()
        
        permission.manage { (status) in
            print(status.rawValue)
        }
    }
    
    @objc
    func skipAllow() {
        (parent as! OnboardMaster).handleRight()
    }
}
