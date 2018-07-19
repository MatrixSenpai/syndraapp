//
//  UIWindowManager.swift
//  Syndra
//
//  Created by Mason Phillips on 7/7/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import MMDrawerController
import SCLAlertView
import GCDKit

class WindowManager {
    static let sharedInstance: WindowManager = WindowManager()
    
    private let comms: GamesCommunicator = GamesCommunicator.sharedInstance
    private var loc  : ViewLocation = .loading
    
    let root: UINavigationController
    
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
        let a = AppLoadingViewController()
        root = UINavigationController(rootViewController: a)
        root.isNavigationBarHidden = true
    }
    
    func move(to v: ViewLocation) {
        switch v {
        case .loading:
            root.popToRootViewController(animated: true)
            loc = .loading
        case .today:
            root.pushViewController(today, animated: true)
            loc = .today
            break
        case .games:
            root.pushViewController(menu, animated: true)
            loc = .games
            break
        }
    }
    
    func alert(title t: String, message m: String) {
        guard root.isViewLoaded && self.loc != .loading else {
            // Wait till that shit is visible
            GCDBlock.async(.background) {
                sleep(1)
                GCDBlock.async(.main, closure: {
                    self.alert(title: t, message: m)
                })
            }
            return
        }
        
        SCLAlertView().showInfo(t, subTitle: m)
    }
}

enum ViewLocation {
    case loading, today, games
}
