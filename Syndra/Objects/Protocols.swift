//
//  Protocols.swift
//  Syndra
//
//  Created by Mason Phillips on 7/13/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import Foundation

// MARK: - GamesCommunicator Protocols
protocol GameListener {
    func getGames(games: Split)
    func nextGame(is: PFGame)
}

protocol UpdateListener {
    func didFinish()
}

