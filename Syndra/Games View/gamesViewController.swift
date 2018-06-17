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

class gamesViewController: MenuInterfacingTableViewController, GameListener {
    
    var games: Split!
    var loadingView: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50), type: .pacman, color: .red, padding: 20)
    
    override init(style: UITableView.Style) {
        super.init(style: style)
        
        GamesCommunicator.sharedInstance.listener = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        refreshControl = UIRefreshControl()
        refreshControl?.addTarget(self, action: #selector(gamesViewController.handleRefresh), for: .valueChanged)
        
        GamesCommunicator.sharedInstance.listener = self
        
        tableView.register(scheduleItemTableViewCell.self, forCellReuseIdentifier: "teamCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if games == nil || games.count > 0 {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
            loadingView.stopAnimating()
            
            return 1
        } else {
            tableView.backgroundView = loadingView
            loadingView.startAnimating()
            tableView.separatorStyle = .none
            
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Week \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard games != nil else { return 0 }
        return games.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! scheduleItemTableViewCell

        guard games.count != 0 else { return cell }
        
        cell.configure(game: games[0][0][indexPath.row])
        
        return cell
    }
    
    @objc
    func handleRefresh() {
        tableView.reloadData()
        
        refreshControl?.endRefreshing()
    }
    
    func getGames(games g: Split) {
        self.games = g
        
        self.tableView.reloadData()
    }
}
