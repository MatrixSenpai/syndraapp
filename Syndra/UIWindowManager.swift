//
//  UIWindowManager.swift
//  Syndra
//
//  Created by Mason Phillips on 7/7/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import MMDrawerController

class WindowManager {
    static let sharedInstance: WindowManager = WindowManager()
    
    private let comms: GamesCommunicator = GamesCommunicator.sharedInstance
    private var loc  : ViewLocation = .today
    
    let root: UINavigationController = UINavigationController()
    
    private var menu: MMDrawerController {
        let r = gameFilterViewController()
        let s = menuTableViewController()
       
        let m = MMDrawerController(center: games, leftDrawerViewController: s, rightDrawerViewController: r)!
        m.openDrawerGestureModeMask = .custom
        m.closeDrawerGestureModeMask = .all
        m.maximumLeftDrawerWidth = 220

        return m
    }
    
    let today: todayGameViewController = todayGameViewController()
    let games: gamesViewController     = gamesViewController()
    
    init() {
        root.isNavigationBarHidden = true
    }
    
    func move(to v: ViewLocation) {
        switch v {
        case .today:
            root.pushViewController(today, animated: true)
            loc = .today
            break
        case .games:
            root.pushViewController(menu, animated: true)
            
            break
        }
    }
}

enum ViewLocation {
    case today, games
}
