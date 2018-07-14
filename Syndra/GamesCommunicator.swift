//
//  GamesCommunicator.swift
//  Syndra
//
//  Created by Mason Phillips on 6/14/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import SwiftyJSON
import SwiftyUserDefaults
import Parse
import GCDKit
import SwiftDate

class GamesCommunicator {
    public static let sharedInstance: GamesCommunicator = GamesCommunicator()

    var listener: GameListener?
    var progress: UpdateListener?
    
    
    
    func initialSetup() {
        if isDataAvailable() { progress?.didFinish(); return }
        GCDBlock.async(.background) {
            do {
                let config = try PFConfig.getConfig()

                guard let season = config["season"] as? Int else { print("GC::initialSetup could not cast season to Int"); return }
                guard let split  = config["split"]  as? Int else { print("CG::initialSetup could not cast split to Int");  return }
                
                print("Returned Season \(season), Split \(split)")
                
                if season != Defaults[.currentSeason] { Defaults[.currentSeason] = season }
                if split  != Defaults[.currentSplit]  { Defaults[.currentSplit]  = split  }
                
                assert((split == 1 || split == 2), "GC::initialSetup assertion failure, split (\(split) does not match expected 1 or 2")
                
                let q = PFSeason.query()!
                q.whereKey("year", equalTo: season)
                
                guard let currentSeason = try q.getFirstObject() as? PFSeason else { print("GC::initialSetup could not cast season to type"); return }
                
                let currentSplit: PFSplit = ((split == 1) ? currentSeason.spring : currentSeason.summer)
                
                try currentSplit.fetchIfNeeded()
                
                let wq = currentSplit.weeks.query()
                
                let weeks = try wq.findObjects()

                print("Got \(weeks.count) weeks")
                
                for w in weeks {
                    let dq = w.days.query()
                    
                    let days = try dq.findObjects()
                    
                    print("Got \(days.count) days for week \(w.week)")
                    
                    for d in days {
                        let gq = d.games.query()
                        
                        let games = try gq.findObjects()
                        
                        _ = try games.map { try $0.pin() }
                        
                        try d.pin()
                        
                        print("Got \(games.count) games for day \(d.day)")
                    }
                    
                    try w.pin()
                }
                
                try currentSplit.pin(withName: "currentSplit")
                
                Defaults[.dataLoaded] = true
                
                GCDBlock.async(.main, closure: {
                    self.nextGame()
                    //self.progress?.didFinish()
                })
            } catch let e {
                print("Error in GC::initialSetup (dispatch block) \(e.localizedDescription)")
            }
        }
    }
    
    public func nextGame() {
        let today = DateInRegion()
        let gq = PFGame.query()!
        
        gq.whereKey("gameTime", greaterThanOrEqualTo: today.absoluteDate)
        
        gq.getFirstObjectInBackground { (g, e) in
            guard e == nil else { print(e!.localizedDescription); return}
            guard let game = g as? PFGame else { print("GC::nextGame could not cast game to type"); return }
            
            self.listener?.nextGame(is: game)
        }
    }

    private func isDataAvailable() -> Bool {
        return Defaults[.dataLoaded]
    }
}

