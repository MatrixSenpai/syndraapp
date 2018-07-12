//
//  PFObjects.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import Parse

class PFSeason: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Season"
    }
    
    @NSManaged var name: String
    @NSManaged var year: Int
    @NSManaged var start: Date
    @NSManaged var spring: PFSplit
    @NSManaged var summer: PFSplit
}

class PFSplit: PFObject, PFSubclassing {
    static func parseClassName() -> String {
        return "Split"
    }
    
    @NSManaged var split: Int
    @NSManaged var season: PFSeason
    @NSManaged var weeks: PFRelation<PFObject>
    @NSManaged var start: Date
    
    public func type() -> SplitType {
        return SplitType(rawValue: self.split - 1)!
    }
}
