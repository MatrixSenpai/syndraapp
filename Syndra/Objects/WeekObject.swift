//
//  WeekObject.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import Parse

class Week: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Week"
    }
    
    @NSManaged var week: Int
    @NSManaged var split: Split
    @NSManaged var days: PFRelation<Day>
    @NSManaged var start: Date
}
