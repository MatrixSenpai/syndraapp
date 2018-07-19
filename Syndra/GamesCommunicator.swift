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
                
                let wq = currentSplit.weeks.query()
                
                let weeks = try wq.findObjects()

                print("Got \(weeks.count) weeks")
                
                GCDBlock.async(.main, closure: {
                    self.progress?.didChange(to: 4)
                })
                
                var i = 1
                for w in weeks {
                    GCDBlock.async(.main, closure: {
                        self.progress?.updateProgress(week: i)
                        i += 1
                    })
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
                
                guard let season = config["season"] as? Int, season == 7 else {
                    throw GamesVerificationError.SeasonNotMatch
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
            default: break
            }
        }
    }
    
    public func nextGame() {
        GCDBlock.async(.background) {
            do {
                let today = DateInRegion()
                
                let gq = Game.query()!
                gq.fromLocalDatastore()
                gq.whereKey("gameTime", greaterThanOrEqualTo: today.absoluteDate)
                
                guard let g = try gq.getFirstObject() as? Game else { fatalError("GC::nextGame failed to cast game back to type") }
                
                let dq = Day.query()!
                dq.fromLocalDatastore()
                dq.whereKey("objectId", equalTo: g.day)
                
                guard let d = try dq.getFirstObject() as? Day else { fatalError("GC::nextGame failed to cast day back to type") }
                
                let wq = Week.query()!
                wq.fromLocalDatastore()
                wq.whereKey("objectId", equalTo: d.week)
                
                guard let w = try dq.getFirstObject() as? Week else { fatalError("GC::nextGame failed to cast week back to type") }
                
                GCDBlock.async(.main, closure: {
                    self.listener?.nextGame(is: g, week: w.week, ofDay: d.day)
                })
                
            } catch let e {
                print(e.localizedDescription)
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
                sq.whereKey("season", equalTo: s)
                
                guard let season = try sq.getFirstObject() as? Season else { fatalError("GC::gamesFor failed to cast season back to type") }
                
                let split: Split = ((p == 1) ? season.spring : season.summer)
                try split.fetchIfNeeded()
                
                let wq = split.weeks.query()
                if(current) { wq.fromLocalDatastore() }
                
                let weeks = try wq.findObjects()
                for w in weeks {
                    try w.fetchIfNeeded()
                    
                    let dq = w.days.query()
                    if(current) { dq.fromLocalDatastore() }
                    
                    let days = try dq.findObjects()
                    for d in days {
                        try d.fetchIfNeeded()
                        
                        let gq = d.games.query()
                        if(current) { gq.fromLocalDatastore() }
                        
                        let games = try gq.findObjects()
                        for g in games {
                            try g.fetchIfNeeded()
                        }
                    }
                }
                
            } catch let e {
                print(e.localizedDescription)
            }
        }
    }

    private func isDataAvailable() -> Bool {
        return Defaults[.dataLoaded]
    }
}

enum GamesVerificationError: Error {
    case SeasonNotMatch
    case SplitNotMatch
    case WeekCountNotMatch
    case DayCountNotMatch
    case GameCountNotMatch
}
