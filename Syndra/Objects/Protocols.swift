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
    func gamesFound(split s: Split)
    func nextGame(is: Game, week: Int, ofDay: Int)
}

protocol UpdateListener {
    func didFinish(update: Bool)
    func didStart()
    func didChange(to step: Int)
    func updateProgress(week: Int)
}

