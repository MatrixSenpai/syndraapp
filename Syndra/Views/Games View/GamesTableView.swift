//
//  GamesTableView.swift
//  Syndra
//
//  Created by Mason Phillips on 7/19/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import TableFlip

class GamesTableView: UITableView, UITableViewDataSource {
    var week: Week!

    init() {
        super.init(frame: CGRect(), style: .plain)
        
        dataSource = self
        separatorStyle = .none
        register(scheduleItemTableViewCell.self, forCellReuseIdentifier: "gameCell")
        rowHeight = 250
    }

    func configure(with w: Week) {
        week = w
        reloadData()
        
        animate(animation: TableViewAnimation.Cell.left(duration: 0.9))
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return (section == 0) ? "Day 1" : "Day 2"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard week != nil else { return 0 }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "gameCell", for: indexPath) as! scheduleItemTableViewCell
        guard week != nil else { return cell }
        
        let row = ((indexPath.row <= 4) ? indexPath.row : indexPath.row - 5)
        
        cell.configure(game: week![indexPath.section, row])
        
        return cell
    }
}
