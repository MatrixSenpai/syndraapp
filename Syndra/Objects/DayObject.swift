//
//  DayObject.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import SwiftDate
import Parse

class Day: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Day"
    }
    
    @NSManaged var day: Int
    @NSManaged var week: Week
    @NSManaged var games: PFRelation<Game>
    @NSManaged var start: Date
}
