//
//  todayGameViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 7/7/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon
import SwiftDate
import Parse
import GCDKit

class todayGameViewController: UIViewController, GameListener {
    var game: Game!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let todayGame: NextGame
    
    let todayLabel: UILabel
    let allGames: UIButton
    
    let laterLabel: UILabel
    
    let ngone: LaterGame
    let ngtwo: LaterGame
    
    init() {        
        todayGame = NextGame()
        
        todayLabel = UILabel()
        todayLabel.textColor = .flatWhite
        todayLabel.text = "Next Game"
        todayLabel.font = UIFont.systemFont(ofSize: 30)
        
        allGames = UIButton()
        allGames.setTitle("See All Games \u{f356}", for: .normal)
        allGames.setTitleColor(.flatWhite, for: .normal)
        allGames.backgroundColor = .flatGray
        allGames.titleLabel?.font = FASOLID_UIFONT
        allGames.layer.cornerRadius = 15
        
        laterLabel = UILabel()
        laterLabel.text = "Later"
        laterLabel.textColor = .flatWhite
        laterLabel.font = UIFont.systemFont(ofSize: 25)
        
        ngone = LaterGame()
        ngtwo = LaterGame()
        
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(todayGame)
        view.addSubview(todayLabel)
        view.addSubview(allGames)
        
        view.addSubview(laterLabel)
        
        view.addSubview(ngone)
        view.addSubview(ngtwo)
        
        allGames.addTarget(self, action: #selector(todayGameViewController.moveToGames), for: .touchUpInside)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatBlack
    }
    
    override func viewDidAppear(_ animated: Bool) {
        GamesCommunicator.sharedInstance.listener = self
        //GamesCommunicator.sharedInstance.nextGame(current: true)
    }
    
    func nextGame(is g: Game, week: Int, ofDay: Int) {
        todayGame.configure(with: g)
        
        GCDBlock.async(.background) {
            let ng = g.gameAfter(local: true)
            let nng = ng.gameAfter(local: true)

            GCDBlock.async(.main, closure: {
                self.ngone.configure(with: ng)
                self.ngtwo.configure(with: nng)
            })
        }
    }
    
    func gamesFound(split s: Split) {
        // Unused
    }
    
    func weekMatched(w: Week) {
        // Unused
    }

    override func viewWillLayoutSubviews() {
        todayLabel.anchorAndFillEdge(.top, xPad: 20, yPad: 60, otherSize: 32)
        
        todayGame.align(.underCentered, relativeTo: todayLabel, padding: 20, width: view.width * 0.85, height: view.height * 0.35)
        
        allGames.anchorAndFillEdge(.bottom, xPad: 20, yPad: 40, otherSize: 50)
        
        laterLabel.alignAndFillWidth(align: .underCentered, relativeTo: todayGame, padding: 30, height: 27)
        
        ngone.align(.underCentered, relativeTo: laterLabel, padding: 25, width: view.width * 0.85, height: 70)
        ngtwo.align(.underCentered, relativeTo: ngone, padding: 15, width: view.width * 0.85, height: 70)
    }
    
    @objc
    func moveToGames() {
        WindowManager.sharedInstance.move(to: .games)
    }
}
