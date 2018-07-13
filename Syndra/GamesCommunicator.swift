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

class GamesCommunicator {
    public static let sharedInstance: GamesCommunicator = GamesCommunicator()
    var listener: GameListener?
    var progress: UpdateListener?
    
    var games: Split!
    var seasons: Available!
    
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
                print(weeks.first!.start.string())

                print("Got \(weeks.count) weeks")
                
                for w in weeks {
                    let dq = w.days.query()
                    
                    let days = try dq.findObjects()
                    print(days.first!.start.string())
                    
                    print("Got \(days.count) days for week \(w.week)")
                    
                    for d in days {
                        let gq = d.games.query()
                        
                        let games = try gq.findObjects()
                        print(games.last!.gameTime.string())
                        
                        print("Got \(games.count) games for day \(d.day)")
                    }
                }
                
                try currentSplit.pin(withName: "currentSplit")
                
                Defaults[.dataLoaded] = true
                
//                let gg = currentSplit.nextGameAfterNow()
//                print(gg.gameTime.string())
                
                GCDBlock.async(.main, closure: {
                    self.progress?.didFinish()
                })
            } catch let e {
                print("Error in GC::initialSetup (dispatch block) \(e.localizedDescription)")
            }
        }
    }

    private func isDataAvailable() -> Bool {
        return Defaults[.dataLoaded]
    }
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "available", ofType: "json") else { fatalError("Looks like we can't find the data file for seasons") }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try JSON(data: data)
            
            guard let latest = json["latest"]["file"].string else { fatalError("Couldn't parse filename") }
            getGamesFor(fileName: latest)
            
            guard let ss = Available(with: json["available"]) else { fatalError("Couldn't parse available data")}
            seasons = ss
        } catch let e {
            print("GamesCommunicator::loadData() \(e.localizedDescription)")
        }
    }
    
    private func getGamesFor(fileName f: String) {
        guard let path = Bundle.main.path(forResource: f, ofType: "json") else { fatalError("Requested path could not be loaded") }
        loadGames(using: URL(fileURLWithPath: path))
    }
    
    func getGamesFor(season: Int, split: Int) {
        guard let path = Bundle.main.path(forResource: "s\(season)s\(split + 1)", ofType: "json") else { fatalError("Requested path could not be loaded") }
        
        loadGames(using: URL(fileURLWithPath: path))
    }
    
    private func loadGames(using path: URL) {
        do {
            let data = try Data(contentsOf: path)
            let json = try JSON(data: data)
            
            let split: Split = Split(fromJSON: json)
            
            listener?.getGames(games: split)
        } catch let e {
            print("GamesCommunicator::loadGames() failed with \(e.localizedDescription)")
        }
    }
    
    func availableSeasons() -> Array<Int> {
        guard seasons != nil else { return [0] }
        return seasons.seasons()
    }
    
    func splitsFor(season: Int) -> Array<SplitType> {
        return seasons.splits(for: season)
    }
    
    func nextGame() -> (Game, Int, Int) {
        return self.games.nextGame()
    }
}

protocol GameListener {
    func getGames(games: Split)
}

protocol UpdateListener {
    func didFinish()
}

struct Available {
    let data: Array<SS>
    
    init?(with j: JSON) {
        guard let j = j.dictionary else { return nil }
        
        var d: [SS] = []
        
        for (_, v) in j {
            let s = v["season"].int!
            let t = v["split"].int!
            
            let u = SS(season: s, split: t)
            d.append(u)
        }
        
        data = d
    }
    
    func seasons() -> Array<Int> {
        var r: Array<Int> = []
        for d in data {
            if !r.contains(d.season) { r.append(d.season) }
        }
        
        return r
    }
    
    func splits(for s: Int) -> Array<SplitType> {
        var r: Array<SplitType> = []
        
        for d in data {
            if d.season == s {
                r.append(d.split)
            }
        }
        
        return r
    }
}

struct SS {
    let season: Int
    let split: SplitType
    
    init(season se: Int, split sp: Int) {
        season = se
        split = SplitType(rawValue: sp - 1)!
    }
}
