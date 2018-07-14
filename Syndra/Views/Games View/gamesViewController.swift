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

class gamesViewController: MenuInterfacingViewController, GameListener, TimeListener, UITableViewDelegate, UITableViewDataSource {
    let headerView: FeaturedGameView = FeaturedGameView()
    var tableView: UITableView = UITableView()
    let scrollView: TimeBrowser = TimeBrowser()
    
    let left : UIButton = UIButton()
    let right: UIButton = UIButton()
    let ngame: UIButton = UIButton()
    
    var games: Split!
    var nextGame: (Game, Int, Int)!
    
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
        ngame.addTarget(self, action: #selector(gamesViewController.showNextGame), for: .touchUpInside)

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(scheduleItemTableViewCell.self, forCellReuseIdentifier: "teamCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell")
        
        view.addSubview(headerView)
        view.addSubview(tableView)
        view.addSubview(scrollView)
        
        view.addSubview(left)
        view.addSubview(right)
        view.addSubview(ngame)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        GamesCommunicator.sharedInstance.listener = self
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.anchorToEdge(.top, padding: 0, width: view.width, height: ((UIDevice.modelName == "iPhone X") ? 140 : 100))
        
        scrollView.anchorToEdge(.bottom, padding: 0, width: view.width, height: 90)
        
        tableView.alignBetweenVertical(align: .underCentered, primaryView: headerView, secondaryView: scrollView, padding: 0, width: view.width)
        
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

    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard games != nil else { return nil }
        
        let h = scheduleItemSectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 30))
        
        let weekString = games[week: section]
        h.configureDates(week: "Week \(section + 1)", dates: weekString)
        
        return h
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard games != nil else { return nil }
        let weekString = "Week \(section + 1): " + games[week: section]
        return weekString
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard games != nil else { return 0 }
        return games.games(for: section) + 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ((indexPath.row != 0 && indexPath.row != 6) ? 250 : 25)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard games != nil else { return UITableViewCell() }
        if indexPath.row == 0 || indexPath.row == 6 {
            let day: Bool = (indexPath.row == 0)
            let cell = tableView.dequeueReusableCell(withIdentifier: "headerCell", for: indexPath)
            
            var dayString = ((day) ? "Day 1 - " : "Day 2 - ")
            dayString += games[week: indexPath.section, day: day]
            
            cell.textLabel?.text = dayString
            cell.textLabel?.textColor = .flatWhite
            
            cell.backgroundColor = ((day) ? .flatBlue : .flatRed)
            
            return cell
        } else {
            let index = ((indexPath.row <= 5) ? (indexPath.row - 1) : (indexPath.row - 7))
            let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! scheduleItemTableViewCell
            
            cell.configure(game: games[week: indexPath.section, game: index])
            
            return cell
        }
    }

    func getGames(games: Split) {
        self.games = games
        
        tableView.reloadData()
        
        nextGame = games.nextGame()
        showNextGame()
    }
    
    func nextGame(is: PFGame) {
        
    }
    
    @objc
    func showNextGame() {
        guard let next = nextGame else { return }
        
        headerView.configure(game: next.0, week: next.1, day: next.2)
        
        let r = ((next.2 == 0) ? next.0.gameOfDay + 1 : next.0.gameOfDay + 7)
        
        let index = IndexPath(row: r, section: next.1)
        scrollTo(row: index, at: UITableView.ScrollPosition.top, animated: true)
    }
    
    func scrollTo(row: IndexPath, at: UITableView.ScrollPosition, animated: Bool) {
        guard games != nil else { return }
        tableView.scrollToRow(at: row, at: at, animated: animated)
    }
}
