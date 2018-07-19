//
//  SeasonObject.swift
//  Syndra
//
//  Created by Mason Phillips on 7/19/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Parse

class Season: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Season"
    }
    
    @NSManaged var name: String
    @NSManaged var year: Int
    @NSManaged var start: Date
    @NSManaged var spring: Split
    @NSManaged var summer: Split
}
