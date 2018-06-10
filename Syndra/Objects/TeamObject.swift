//
//  TeamObject.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Parse

class Team: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Team"
    }
    
    override var description: String {
        return "\(self.name)(\(self.abbreviation)) - \(self.iconName).png"
    }
    
    @NSManaged var name: String
    @NSManaged var abbreviation: String
    @NSManaged var iconName: String

    func icon() -> UIImage? {
        return UIImage(named: iconName)
    }
}
