//
//  gameFilterViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon

class gameFilterViewController: UITableViewController {
    
    let rows: Array<String> = ["100 Thieves", "OpTic Gaming", "Golden Guardians", "FlyQuest", "Cloud9", "Clutch Gaming", "Counter Logic Gaming", "Team Solo Mid", "Echo Fox", "Team Liquid"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "selectCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "selectCell", for: indexPath)
        
        cell.textLabel?.text = rows[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let controller = mm_drawerController.centerViewController as? MyTeamsViewController else { return }
        
        let t: Theme
        switch indexPath.row {
        case 0: t = .t100
        case 1: t = .opt
        case 2: t = .ggs
        case 3: t = .fq
        case 4: t = .c9
        case 5: t = .cg
        case 6: t = .clg
        case 7: t = .tsm
        case 8: t = .fox
        case 9: t = .tl
        default: t = .tsm
        }
        
        controller.theme(with: t)
    }

}
