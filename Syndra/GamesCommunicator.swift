//
//  GamesCommunicator.swift
//  Syndra
//
//  Created by Mason Phillips on 6/14/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation
import SwiftyJSON

class GamesCommunicator {
    public static let sharedInstance: GamesCommunicator = GamesCommunicator()
    var listener: GameListener?
    
    var games: Split!
    var seasons: Available!
    
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
            print(e.localizedDescription)
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
        return seasons.seasons()
    }
    
    func splitsFor(season: Int) -> Array<SplitType> {
        return seasons.splits(for: season)
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
