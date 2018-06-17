//
//  TeamObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import SwiftyJSON

class Team {
    var name: String
    var abbreviation: String
    var iconName: String
    
    init() {
        name = ""
        abbreviation = ""
        iconName = ""
    }

    func icon() -> UIImage? {
        return UIImage(named: iconName)
    }
}
