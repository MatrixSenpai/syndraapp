//
//  TeamObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class Team {
    let name: String
    let abbreviation: String
    let icon: UIImage?
    
    init(name n: String, usingAbbreviation a: String, andIcon i: String) {
        name = n
        abbreviation = a
        icon = UIImage(named: i)
    }
}
