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
    
    var games: Split!
    var seasons: Available!
    
    func initialSetup() {
        PFConfig.getInBackground { (config, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            
            guard let season = config?["season"] as? Int else {
                print("Could not get or cast season"); return
            }
            
            guard let split = config?["split"] as? Int else {
                print("Could not get or cast split"); return
            }
            
            print("Got Season \(season), Split \(split)")
            
            if season != Defaults[.currentSeason] {
                Defaults[.currentSeason] = season
            }
            
            if split != Defaults[.currentSplit] {
                Defaults[.currentSplit] = split
            }
            
            GCDBlock.async(.main, closure: {
                self.beginGameFetch()
            })
        }
    }
    
    private func beginGameFetch() {
        let q = PFSeason.query()
        
        q?.whereKey("year", equalTo: Defaults[.currentSeason])
        
        q?.findObjectsInBackground(block: { (results, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            
            guard let season = results?.first as? PFSeason else { print("Could not cast to season in GC::beginGameFetch"); return }
            print(season.start.string())
            
            GCDBlock.async(.main, closure: {
                self.fetchSeasons(season)
            })
        })

    }
    
    private func fetchSeasons(_ s: PFSeason) {
        switch Defaults[.currentSplit] {
        case 1:
            break
        case 2:
            s.summer.fetchIfNeededInBackground { (split, error) in
                guard error == nil else { print("Could not fetch split in GC::fetchSeasons"); return }
                
                guard let s = split as? PFSplit else { print("Could not cast split in GC::fetchSeasons"); return }
                print(s.start.string())
                
                GCDBlock.async(.main, closure: {
                    self.fetchWeeks(s)
                })
            }
        default:
            print("Fuck the dev. GC::fetchSeasons")
        }
    }
    
    private func fetchWeeks(_ w: PFSplit) {
        
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
