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

class gamesViewController: MenuInterfacingViewController, GameListener, UITableViewDelegate, UITableViewDataSource {
    let headerView: FeaturedGameView = FeaturedGameView()
    let tableView: UITableView = UITableView()
    let scrollView: TimeBrowser = TimeBrowser()
    
    let left : UIButton = UIButton()
    let right: UIButton = UIButton()
    let ngame: UIButton = UIButton()
    
    var games: Split!
    var nextGame: (Game, Int, Int)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GamesCommunicator.sharedInstance.listener = self
        
        scrollView.parent = self
        
        headerView.backgroundColor = .flatBlack
        tableView.backgroundColor = .flatBlack
        
        left.backgroundColor = .flatSkyBlueDark
        left.setTitle("\u{f073}", for: .normal)
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
        let h = scheduleItemSectionHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.width, height: 30))
        
        guard games != nil else { return nil }
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
        return 12
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
        nextGame = games.nextGame()
        
        tableView.reloadData()
        
        showNextGame()
    }
    
    @objc
    func showNextGame() {
        guard let next = nextGame else { return }
        
        headerView.configure(game: next.0, week: next.1, day: next.2)
        
        let r = ((next.2 == 0) ? next.0.gameOfDay + 1 : next.0.gameOfDay + 7)
        
        let index = IndexPath(row: r, section: next.1)
        tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.top, animated: true)
    }
}

class TimeBrowser: UIView {
    var parent: gamesViewController?
    
    let one  : PMSuperButton = PMSuperButton()
    let two  : PMSuperButton = PMSuperButton()
    let three: PMSuperButton = PMSuperButton()
    let four : PMSuperButton = PMSuperButton()
    let five : PMSuperButton = PMSuperButton()
    let six  : PMSuperButton = PMSuperButton()
    let seven: PMSuperButton = PMSuperButton()
    let eight: PMSuperButton = PMSuperButton()
    let nine : PMSuperButton = PMSuperButton()
    
    var buttons: [Frameable] {
        return [one, two, three, four, five, six, seven, eight, nine]
    }
    
    init() {
        super.init(frame: CGRect())
        
        var i: Int = 0
        for b in buttons {
            guard let p = b as? PMSuperButton else { fatalError("Could not cast button back to its original type???") }
            
            p.setTitle("\(i + 1)", for: .normal)
            p.tag = i
            p.layer.cornerRadius = 10
            p.clipsToBounds = true
            p.backgroundColor = .flatForestGreen
            p.titleLabel?.textColor = .flatWhite
            p.addTarget(self, action: #selector(TimeBrowser.goTo(sender:)), for: .touchUpInside)
            
            addSubview(p)
            
            i += 1
        }
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: frame, andColors: [.flatSkyBlue, .flatRedDark])
        
        groupAgainstEdge(group: .horizontal, views: buttons, againstEdge: .top, padding: 5, width: 35, height: 40)
    }
    
    @objc
    func goTo(sender: PMSuperButton) {
        let index = IndexPath(row: 0, section: sender.tag)
        parent?.tableView.scrollToRow(at: index, at: .top, animated: true)
    }
}
