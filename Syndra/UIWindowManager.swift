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
    private var loc  : ViewLocation = .team
    
    let menu: MMDrawerController
    
    let menuTable: menuTableViewController
    
    let today: todayGameViewController
    let games: SplitGamesViewController
    let team : MyTeamsViewController
    
    init() {
        today = todayGameViewController()
        games = SplitGamesViewController()
        team = MyTeamsViewController()
        
        menuTable = menuTableViewController()
        
        let right = gameFilterViewController()
        
        menu = MMDrawerController(center: team, leftDrawerViewController: menuTable, rightDrawerViewController: right)
        menu.openDrawerGestureModeMask = .all
        menu.closeDrawerGestureModeMask = .all
        menu.maximumLeftDrawerWidth = 220
    }
    
    
    func move(to v: ViewLocation) {
        switch v {
        case .team:
            menu.setCenterView(team, withCloseAnimation: true, completion: nil)
            loc = .team
        case .loading:
//            root.pushViewController(, animated: <#T##Bool#>)
            loc = .loading
        case .today:
            menu.setCenterView(today, withCloseAnimation: true, completion: nil)
            today.viewDidAppear(true)
            loc = .today
            break
        case .games:
            menu.setCenterView(games, withCloseAnimation: true, completion: nil)
            loc = .games
            break
        }
    }
    
    func alert(title t: String, message m: String) {
        guard menu.isViewLoaded && self.loc != .loading else {
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
    case loading, today, games, team
}
