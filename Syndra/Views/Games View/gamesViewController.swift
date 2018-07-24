//
//  gamesViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import MMDrawerController
import Parse
import NVActivityIndicatorView
import TableFlip
import PMSuperButton
import Neon
import SwiftyUserDefaults

class gamesViewController: MenuInterfacingViewController, GameListener {
    let headerView: FeaturedGameView = FeaturedGameView()
    var tableView: GamesTableView = GamesTableView()
    let scrollView: TimeBrowser = TimeBrowser()
    
    var bg: NVActivityIndicatorView!
    
    let left : UIButton = UIButton()
    let right: UIButton = UIButton()
    let ngame: UIButton = UIButton()
    
    var split: Split!
    var nextGame: IndexPath?
    
    private var needsUpdate: Bool = true
    
    // MARK: - View Configuration
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.parent = self
        
        headerView.backgroundColor = .flatBlack
        tableView.backgroundColor = .flatBlack
        
        left.backgroundColor = .flatSkyBlueDark
        left.setTitle("\u{f073}", for: .normal)
        left.setTitle("\u{f343}", for: .selected)
        left.titleLabel?.font = FASOLID_UIFONT
        left.addTarget(self, action: #selector(gamesViewController.openLeft), for: .touchUpInside)
        
        right.backgroundColor = .flatRedDark
        right.setTitle("\u{f0b0}", for: .normal)
        right.titleLabel?.font = FASOLID_UIFONT
        right.addTarget(self, action: #selector(gamesViewController.openRight), for: .touchUpInside)
        
        ngame.backgroundColor = .flatRedDark
        ngame.setTitle("\u{f017}", for: .normal)
        ngame.titleLabel?.font = FASOLID_UIFONT
        //ngame.addTarget(self, action: #selector(gamesViewController.showNextGame), for: .touchUpInside)
        
        bg = NVActivityIndicatorView(frame: CGRect(x: tableView.center.x, y: tableView.center.y, width: 50, height: 50))
        bg.type = .lineScalePulseOutRapid
        bg.color = .flatWhite
        bg.startAnimating()
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(scrollView)
        
        view.addSubview(left)
        view.addSubview(right)
        view.addSubview(ngame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GamesCommunicator.sharedInstance.listener = self

        GamesCommunicator.sharedInstance.closestWeek()
        GamesCommunicator.sharedInstance.nextGame(current: true)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.anchorToEdge(.top, padding: 0, width: view.width, height: ((UIDevice.modelName == "iPhone X") ? 140 : 100))
        scrollView.alignAndFillWidth(align: .underCentered, relativeTo: headerView, padding: 0, height: 90)
        tableView.alignAndFill(align: .underCentered, relativeTo: scrollView, padding: 0)
        
        left.anchorInCorner(.bottomLeft, xPad: 0, yPad: 120, width: 50, height: 50)
        let leftMask = CAShapeLayer()
        leftMask.path = UIBezierPath(roundedRect: left.bounds, byRoundingCorners: [.topRight, .bottomRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        left.layer.mask = leftMask
        
        right.anchorInCorner(.bottomRight, xPad: 0, yPad: 120, width: 50, height: 50)
        let rightMask = CAShapeLayer()
        rightMask.path = UIBezierPath(roundedRect: right.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        right.layer.mask = rightMask
        
        ngame.align(.aboveCentered, relativeTo: right, padding: 10, width: 50, height: 50)
        let nMask = CAShapeLayer()
        nMask.path = UIBezierPath(roundedRect: right.bounds, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        ngame.layer.mask = nMask
    }
    
    // MARK: - Selection
    func gamesFound(split s: Split) {
        self.split = s
        GamesCommunicator.sharedInstance.nextGame(current: true)
    }

    func nextGame(is g: Game, week w: Int, ofDay d: Int) {
        headerView.configure(game: g, week: w, day: d)
        
        tableView.reloadData()
    }
    
    func weekMatched(w: Week) {
        tableView.configure(with: w)
        scrollView.setColor(for: w.week)
    }
    
    func get(week: Int) {
        GamesCommunicator.sharedInstance.weekMatching(w: week, se: Defaults[.currentSplit], s: Defaults[.currentSeason])
    }
    
    /*
    @objc
    func showNextGame() {
        guard let next = nextGame else { return }
        
        headerView.configure(game: next.0, week: next.1, day: next.2)
        
        let r = ((next.2 == 0) ? next.0.gameOfDay + 1 : next.0.gameOfDay + 7)
        
        let index = IndexPath(row: r, section: next.1)
        scrollTo(row: index, at: UITableView.ScrollPosition.top, animated: true)
    }*/
}
