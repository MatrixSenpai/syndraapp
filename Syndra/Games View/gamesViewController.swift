//
//  gamesViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 6/9/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class gamesViewController: UITableViewController {
    
    let games: Array<Game> = [
        Game(blueSide: NALCS.TH, redSide: NALCS.TL, time: "4:00 PM"),
        Game(blueSide: NALCS.TSM, redSide: NALCS.CLG, time: "5:00 PM"),
        Game(blueSide: NALCS.CG, redSide: NALCS.C9, time: "6:00 PM"),
        Game(blueSide: NALCS.FQ, redSide: NALCS.FOX, time: "7:00 PM"),
        Game(blueSide: NALCS.GGS, redSide: NALCS.OTG, time: "8:00 PM"),
        
        Game(blueSide: NALCS.TSM, redSide: NALCS.FQ, time: "2:00 PM"),
        Game(blueSide: NALCS.TL, redSide: NALCS.GGS, time: "3:00 PM"),
        Game(blueSide: NALCS.CLG, redSide: NALCS.TH, time: "4:00 PM"),
        Game(blueSide: NALCS.CG, redSide: NALCS.FOX, time: "5:00 PM"),
        Game(blueSide: NALCS.C9, redSide: NALCS.OTG, time: "6:00 PM")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(scheduleItemTableViewCell.self, forCellReuseIdentifier: "teamCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Week \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "teamCell", for: indexPath) as! scheduleItemTableViewCell

        cell.configure(game: games[indexPath.row])
        
        return cell
    }
}
