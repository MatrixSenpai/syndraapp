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
    
    func loadGames() {
        guard let path = Bundle.main.path(forResource: "Games", ofType: "json") else { fatalError("Games.json path could not be loaded") }
        
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path))
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
