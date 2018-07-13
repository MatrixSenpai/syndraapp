//
//  AppDelegate.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import FontBlaster
import Parse
import SuperDelegate
import SwiftDate
import AppVersionMonitor

// Global Font Awesome declarations
let FALIGHT_UIFONT  : UIFont = UIFont(name: "FontAwesome5ProLight", size: 20)!
let FAREGULAR_UIFONT: UIFont = UIFont(name: "FontAwesome5ProRegular", size: 20)!
let FASOLID_UIFONT  : UIFont = UIFont(name: "FontAwesome5ProSolid", size: 20)!
let FABRANDS_UIFONT : UIFont = UIFont(name: "FontAwesome5BrandsRegular", size: 20)!

let FALIGHT_ATTR     = [NSAttributedString.Key.font: FALIGHT_UIFONT]
let FAREGULAR_ATTR   = [NSAttributedString.Key.font: FAREGULAR_UIFONT]
let FASOLID_ATTR     = [NSAttributedString.Key.font: FASOLID_UIFONT]
let FABRANDS_ATTR    = [NSAttributedString.Key.font: FABRANDS_UIFONT]

@UIApplicationMain
class AppDelegate: SuperDelegate, ApplicationLaunched {
    let window: UIWindow = UIWindow()
    
    func setupApplication() {
        Parse.enableLocalDatastore()
        Parse.initialize(with: ParseClientConfiguration(block: { (config) in
            config.applicationId = "4ad2abb0-6608-4f2c-b036-b9902cf4fe35"
            config.clientKey = "spbSi2C50BsiIC16KXZPBUx6XjeszbSK"
            config.server = "https://parse.buddy.com/parse"
        }))
        
        PFSeason.registerSubclass()
        PFSplit.registerSubclass()
        
        FontBlaster.blast()
        AppVersionMonitor.sharedMonitor.startup()
        GamesCommunicator.sharedInstance.initialSetup()
        
        Date.setDefaultRegion(Region(tz: TimeZoneName.americaChicago, cal: CalendarName.gregorian, loc: LocaleName.englishUnitedStates))
    }
    
    func loadInterface(launchItem: LaunchItem) {
        setup(mainWindow: window)
        
        PFAnalytics.trackAppOpened(launchOptions: launchItem.launchOptions)
        
        print(AppVersionMonitor.sharedMonitor.state)
        
        window.makeKeyAndVisible()
    }
    
    func showActual() {
        WindowManager.sharedInstance.move(to: .today)
        
        window.rootViewController = WindowManager.sharedInstance.root
    }
}
