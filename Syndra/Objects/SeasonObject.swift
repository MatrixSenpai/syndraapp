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
    
    override var description: String {
        var r = ""
        
        r += "Season \(year) (ID: \(self.objectId ?? "<null>"))\n"
        r += "Spring Split: \(spring.shortDescription)\n"
        r += "Summer Split: \(summer.shortDescription)\n"
        
        return r
    }
    
    var shortDescription: String {
        return "Season \(year) (ID: \(self.objectId ?? "<null>"))\n"
    }
    
    @NSManaged var year: Int
    @NSManaged var spring: Split
    @NSManaged var summer: Split
    
    static func season(for y: Int) throws -> Season {
        let sq = Season.query()!
        sq.whereKey("year", equalTo: y)
        
        guard let season = try sq.getFirstObject() as? Season else {
            throw SyndraCast.CastBackSeason
        }
        
        return season
    }
}
