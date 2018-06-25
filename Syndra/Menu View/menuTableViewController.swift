//
//  menuTableViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import SCLAlertView

class menuTableViewController: UITableViewController {
    
    let topLevel: Array<(String, String)> = [
        ("\u{f133}", "Season 8 Schedule"),
        ("\u{f2eb}", "Teams & Standings"),
        ("\u{f017}", "Other Seasons"),
        ("\u{f478}", "Player Statistics"),
        ("\u{f085}", "Settings")
    ]
    
    var gamesController    : gamesViewController!
    var pastGamesController: pastSeasonsViewController!
    var standingsController: MenuInterfacingViewController!
    var settingsController : UINavigationController!
    
    var seasons: Array<Int> = []
    var currentSeason: Int = 0
    var splits: Array<SplitType> = []
    
    var leftButton: UIBarButtonItem {
        let leftButton = UIBarButtonItem(title: "\u{f060}", style: .plain, target: self, action: #selector(menuTableViewController.returnUpLevel))
        leftButton.setTitleTextAttributes(FASOLID_ATTR, for: .normal)
        
        return leftButton
    }
    
    var location: Level = .Top

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if standingsController == nil { standingsController = MenuInterfacingViewController() }
        if pastGamesController == nil { pastGamesController = pastSeasonsViewController() }
        if settingsController  == nil { settingsController  = UINavigationController(rootViewController: MenuInterfacingViewController()) }

        seasons = GamesCommunicator.sharedInstance.availableSeasons()
        
        tableView.separatorStyle = .none
        tableView.register(menuTableViewCell.self, forCellReuseIdentifier: "menuCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch location {
        case .Top: return topLevel.count
        case .Seasons: return seasons.count
        case .Splits: return splits.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuTableViewCell

        var icon: String!
        var text: String!
        
        switch location {
        case .Seasons:
            icon = "\u{f073}"
            text = "Season \(seasons[indexPath.row])"
            break
        case .Splits:
            icon = "\u{f253}"
            text = "\(splits[indexPath.row].toString()) 201\(currentSeason)"
        case .Top: fallthrough
        default:
            icon = topLevel[indexPath.row].0
            text = topLevel[indexPath.row].1
            break
        }
        
        cell.iconLabel.text = icon
        cell.descLabel.text = text

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch location {
        case .Top:
            switch indexPath.row {
            case 0:
                if mm_drawerController.centerViewController != gamesController {
                    mm_drawerController.centerViewController = gamesController
                    
                }
                GamesCommunicator.sharedInstance.listener = gamesController
                GamesCommunicator.sharedInstance.getGamesFor(season: 8, split: 1)
                mm_drawerController.closeDrawer(animated: true, completion: nil)
                
            case 1:
                SCLAlertView().showInfo("Hey there!", subTitle: "Looks like this menu option isn't ready yet :(")
                break
                
            case 2:
                navigationItem.leftBarButtonItem = leftButton
                
                location = .Seasons
                tableView.reloadData()
                break
                
            case 3:
                SCLAlertView().showInfo("Hey there!", subTitle: "Looks like this menu option isn't ready yet :(")
                break
                
            case 4:
                if mm_drawerController.centerViewController != settingsController {
                    mm_drawerController.centerViewController = settingsController
                }
                mm_drawerController.closeDrawer(animated: true, completion: nil)
            default:
                SCLAlertView().showError("Oops!", subTitle: "This should never happen. Report it to the developer and tell him he's shit")
                break
            }
            break
        case .Seasons:
            navigationItem.leftBarButtonItem = leftButton
            
            let cell = tableView.cellForRow(at: indexPath) as! menuTableViewCell
            let t = cell.descLabel.text
            let s = String(t!.split(separator: " ").last!)
            let si = Int(s)
            
            splits = GamesCommunicator.sharedInstance.splitsFor(season: si!)
            currentSeason = si!
            location = .Splits
            tableView.reloadData()
            
            break
        case .Splits:
            let cell = tableView.cellForRow(at: indexPath) as! menuTableViewCell
            let t = cell.descLabel.text
            let s = String(t!.split(separator: " ").first!)
            let si = SplitType.from(string: s)

            GamesCommunicator.sharedInstance.listener = pastGamesController
            GamesCommunicator.sharedInstance.getGamesFor(season: currentSeason, split: si.rawValue)
            location = .Top
            
            mm_drawerController.centerViewController = pastGamesController
            mm_drawerController.closeDrawer(animated: true) { (_) in
                self.tableView.reloadData()
            }
            
            break
        }
    }
    
    @objc
    func returnUpLevel() {
        switch location {
        case .Splits:
            location = .Seasons
            currentSeason = 0
            tableView.reloadData()
        case .Seasons:
            location = .Top
            currentSeason = 0
            tableView.reloadData()
            
            navigationItem.leftBarButtonItem = nil
        case .Top: fallthrough
        default: break
        }
    }
}

enum Level: Int {
    case Top = 0
    case Seasons = 1
    case Splits = 2
}

struct Location {
    var level: Level
    
}
