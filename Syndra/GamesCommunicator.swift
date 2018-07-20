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
        if isDataAvailable() { progress?.didFinish(update: false); return }
        progress?.didStart()
        GCDBlock.async(.background) {
            do {
                try PFObject.unpinAllObjects()
                try PFObject.unpinAllObjects(withName: "currentSplit")
                GCDBlock.async(.main, closure: {
                    self.progress?.didChange(to: 1)
                })
                
                let config = try PFConfig.getConfig()

                guard let season = config["season"] as? Int else { print("GC::initialSetup could not cast season to Int"); return }
                guard let split  = config["split"]  as? Int else { print("CG::initialSetup could not cast split to Int");  return }
                
                print("Returned Season \(season), Split \(split)")
                
                if season != Defaults[.currentSeason] { Defaults[.currentSeason] = season }
                if split  != Defaults[.currentSplit]  { Defaults[.currentSplit]  = split  }
                
                assert((split == 1 || split == 2), "GC::initialSetup assertion failure, split (\(split) does not match expected 1 or 2")
                
                GCDBlock.async(.main, closure: {
                    self.progress?.didChange(to: 2)
                })
                
                let q = Season.query()!
                q.whereKey("year", equalTo: season)
                
                GCDBlock.async(.main, closure: {
                    self.progress?.didChange(to: 3)
                })
                
                guard let currentSeason = try q.getFirstObject() as? Season else { print("GC::initialSetup could not cast season to type"); return }
                
                let currentSplit: Split = ((split == 1) ? currentSeason.spring : currentSeason.summer)
                try currentSplit.fetchIfNeeded()
                try currentSplit.pin(withName: "currentSplit")

                let weeks = currentSplit.weeks
                print("Got \(weeks.count) weeks")
                
                GCDBlock.async(.main, closure: {
                    self.progress?.didChange(to: 4)
                })
                
                var i = 0
                for w in weeks {
                    i += 1
                    GCDBlock.async(.main, closure: {
                        self.progress?.updateProgress(week: i)
                    })
                    try w.fetchIfNeeded()
                    
                    let days = w.days
                    for d in days {
                        try d.fetchIfNeeded()
                        
                        let games = d.games
                        
                        _ = try games.map { try $0.fetchIfNeeded(); try $0.pin() }
                        try d.pin()
                    }
                    try w.pin()
                }
                
                Defaults[.dataLoaded] = true
                
                GCDBlock.async(.main, closure: {
                    self.progress?.didFinish(update: true)
                })
            } catch let e {
                print("Error in GC::initialSetup (dispatch block) \(e.localizedDescription)")
            }
        }
    }
    
    public func checkData() {
        GCDBlock.async(.background) {
            do {
                let config = try PFConfig.getConfig()
                
                guard let season = config["season"] as? Int, season == Defaults[.currentSeason] else {
                    throw GamesVerificationError.SeasonNotMatch
                }
                
                guard let split = config["split"] as? Int, split == Defaults[.currentSplit] else {
                    throw GamesVerificationError.SplitNotMatch
                }
                
                
            } catch let e {
                switch e {
                case is GamesVerificationError:
                    self.showDataNotMatch(with: e as! GamesVerificationError)
                default:
                    print(e.localizedDescription)
                    break
                }
            }
        }
    }
    
    func showDataNotMatch(with e: GamesVerificationError) {
        GCDBlock.async(.main) {
            switch e {
            case .SeasonNotMatch:
                WindowManager.sharedInstance.alert(title: "Games Need Update", message: fetchString(forKey: "season_not_match"))
                break
            case .SplitNotMatch:
                WindowManager.sharedInstance.alert(title: "Games Need Update", message: fetchString(forKey: "season_not_match"))
            default: break
            }
        }
    }
    
    public func gamesForCurrent() {
        self.gamesFor(season: Defaults[.currentSeason], split: Defaults[.currentSplit], current: true)
    }
    
    public func gamesFor(season s: Int, split p: Int, current: Bool) {
        assert((p == 1 || p == 2), "Split is illegal value: \(p) (Must be 1 or 2)")
        GCDBlock.async(.background) {
            do {
                let sq = Season.query()!
                if(current) { sq.fromLocalDatastore() }
                sq.whereKey("year", equalTo: s)
                
                guard let season = try sq.getFirstObject() as? Season else { fatalError("GC::gamesFor failed to cast season back to type") }
                
                let split: Split = ((p == 1) ? season.spring : season.summer)
                try split.fetchIfNeeded()

                try split.weeks.forEach({ (w) in
                    try w.fetchIfNeeded()
                    
                    try w.days.forEach({ (d) in
                        try d.fetchIfNeeded()
                        
                        _ = try d.games.map { try $0.fetchIfNeeded(); }
                    })
                })
                
                GCDBlock.async(.main, closure: {
                    self.listener?.gamesFound(split: split)
                })
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }
    
    public func closestWeek() {
        GCDBlock.async(.background) {
            do {
                let today = DateInRegion()
                
                let gq = Game.query()!
                gq.fromLocalDatastore()
                gq.whereKey("gameTime", greaterThanOrEqualTo: today.absoluteDate)
                gq.order(byAscending: "gameTime")
                
                let g = try gq.getFirstObject() as! Game
                let d = g.parent
                try d.fetchIfNeeded()
                let w = d.parent
                try w.fetchIfNeeded()
                
                for dd in w.days {
                    try dd.fetchIfNeeded()
                    
                    for gg in dd.games {
                        try gg.fetchIfNeeded()
                        try gg.blueSide.fetchIfNeeded()
                        try gg.redSide.fetchIfNeeded()
                    }
                }
                
                GCDBlock.async(.main, closure: {
                    self.listener?.weekMatched(w: w)
                })
            } catch let e {
                WindowManager.sharedInstance.alert(title: "Fetching Weeks", message: "An error occured during fetch, no data could be retrieved")
                print(e.localizedDescription)
            }
        }
    }
    
    public func weekMatching(w: Int, se: Int, s: Int) {
        GCDBlock.async(.background) {
            do {
                let wq = Week.query()!
                wq.fromLocalDatastore()
                
                wq.whereKey("week", equalTo: w)
                
                guard let w = try wq.getFirstObject() as? Week else { throw SyndraCast.CastBackWeek }
                
                try w.fetchIfNeeded()
                try w.days.forEach { (d) in
                    try d.fetchIfNeeded()
                    try d.games.forEach { (g) in
                        try g.fetchIfNeeded()
                        try g.blueSide.fetchIfNeeded()
                        try g.redSide.fetchIfNeeded()
                    }
                }
                
                GCDBlock.async(.main, closure: {
                    self.listener?.weekMatched(w: w)
                })
            } catch let e {
                GCDBlock.async(.main, closure: {
                    WindowManager.sharedInstance.alert(title: "Fetching Weeks", message: "An error occured during fetch, no data could be retrieved")
                })
                
                print(e.localizedDescription)
            }
        }
    }

    public func nextGame(current l: Bool) {
        GCDBlock.async(.background) {
            let g = Game.nextGame(local: l)
            
            do {
                let d = g.parent
                try d.fetchIfNeeded()
                
                let w = d.parent
                try w.fetchIfNeeded()
                
                GCDBlock.async(.main, closure: {
                    self.listener?.nextGame(is: g, week: w.week, ofDay: d.day)
                })
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }
    
    private func isDataAvailable() -> Bool {
        return Defaults[.dataLoaded]
    }
}

