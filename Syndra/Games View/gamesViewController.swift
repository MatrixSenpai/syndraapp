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

class gamesViewController: MenuInterfacingViewController, GameListener, UITableViewDelegate, UITableViewDataSource {
    let headerView: FeaturedGameView = FeaturedGameView()
    let tableView: UITableView = UITableView()
    
    var games: Split!

    override func viewDidLoad() {
        super.viewDidLoad()
        GamesCommunicator.sharedInstance.listener = self
        
        headerView.backgroundColor = .flatBlack
        tableView.backgroundColor = .flatBlack

        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.register(scheduleItemTableViewCell.self, forCellReuseIdentifier: "teamCell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "headerCell")
        
        view.addSubview(headerView)
        view.addSubview(tableView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        headerView.anchorToEdge(.top, padding: 0, width: view.width, height: ((UIDevice.modelName == "iPhone X") ? 140 : 100))
        
        tableView.alignAndFill(align: .underCentered, relativeTo: headerView, padding: 0, offset: 0)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
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
        
        let next = games.nextGame()
        headerView.configure(game: next.0, week: next.1, day: next.2)
        
        let r = ((next.2 == 0) ? next.0.gameOfDay + 2 : next.0.gameOfDay + 7)
        
        let index = IndexPath(row: r, section: next.1)
        tableView.scrollToRow(at: index, at: UITableView.ScrollPosition.top, animated: true)
        
        tableView.reloadData()
    }
}
