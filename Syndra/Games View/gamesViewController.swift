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

class gamesViewController: MenuInterfacingTableViewController {
    
    var games: Array<Game>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(scheduleItemTableViewCell.self, forCellReuseIdentifier: "teamCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let q = Game.query()
        
        q?.findObjectsInBackground(block: { (results, error) in
            if error == nil {
                guard let gameObjects = results as? Array<Game> else { return }
                
                print("Got back \(gameObjects.count) games")
                
                for g in gameObjects {
                    do {
                        try g.blueSide.fetch()
                        try g.redSide.fetch()
                    } catch let e {
                        print("fetchTeams - " + e.localizedDescription)
                    }
                }
                
                self.games = gameObjects
                self.tableView.reloadData()
            } else {
                print("findGames - " + error!.localizedDescription)
            }
        })
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Week \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! scheduleItemTableViewCell

        guard let g = games else { return cell }
        
        cell.configure(game: g[indexPath.row])
        
        return cell
    }
}
