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
    
    func loadData() {
        guard let path = Bundle.main.path(forResource: "available", ofType: "json") else { fatalError("Looks like we can't find the data file for seasons") }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
            let json = try JSON(data: data)
            
            guard let latest = json["latest"]["file"].string else { fatalError("Couldn't parse filename") }
            getGamesFor(fileName: latest)
        } catch let e {
            print(e.localizedDescription)
        }
    }
    
    private func getGamesFor(fileName f: String) {
        guard let path = Bundle.main.path(forResource: f, ofType: "json") else { fatalError("Requested path could not be loaded") }
        loadGames(using: URL(fileURLWithPath: path))
    }
    
    func getGamesFor(season: Int, split: Int) {
        guard let path = Bundle.main.path(forResource: "s\(season)s\(split)", ofType: "json") else { fatalError("Requested path could not be loaded") }
        
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
}

protocol GameListener {
    func getGames(games: Split)
}
