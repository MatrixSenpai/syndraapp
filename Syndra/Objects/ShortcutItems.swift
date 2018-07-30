//
//  ShortcutItems.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

struct SyndraShortcutItems {
    static var TodayItem: UIApplicationShortcutItem {
        let si = UIApplicationShortcutIcon(type: .time)
        return UIApplicationShortcutItem(type: self.Titles.today.rawValue, localizedTitle: "Today", localizedSubtitle: "See upcoming games", icon: si, userInfo: nil)
    }
    
    static var allItems: Array<UIApplicationShortcutItem> {
        return [self.TodayItem]
    }
    
    enum Titles: String {
        case today = "syndraapp-today"
        
        static func getValue(from f: UIApplicationShortcutItem) -> SyndraShortcutItems.Titles {
            return SyndraShortcutItems.Titles(rawValue: f.type)!
        }
    }
}
