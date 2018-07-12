//
//  menuTableViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import SCLAlertView
import TableFlip

class menuTableViewController: UITableViewController {
    
    let topLevel: Array<(String, String)> = [
        ("\u{f133}", "Season 8 Schedule"),
        ("\u{f2eb}", "Teams & Standings"),
        ("\u{f017}", "Other Seasons"),
        ("\u{f478}", "Player Statistics"),
        ("\u{f085}", "Settings")
    ]

    //let interface: UIWindowManager = UIWindowManager.sharedInstance
    
    var headerView: menuHeaderView {
        return menuHeaderView(frame: CGRect(x: 0, y: 0, width: view.width, height: 200))
    }
    
    var seasons: Array<Int> = []
    var currentSeason: Int = 0
    var splits: Array<SplitType> = []
    
    var location: Level = .Top

    override func viewDidLoad() {
        super.viewDidLoad()
        
        seasons = GamesCommunicator.sharedInstance.availableSeasons()
        
        tableView.backgroundColor = .flatBlack
        tableView.isScrollEnabled = false
        tableView.tableHeaderView = headerView
        
        tableView.separatorStyle = .none
        tableView.register(menuTableViewCell.self, forCellReuseIdentifier: "menuCell")
        
        clearsSelectionOnViewWillAppear = false
        
        let i = IndexPath(row: 0, section: 0)
        let c = tableView.cellForRow(at: i)
        c?.setSelected(true, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch location {
        case .Top: return topLevel.count
        case .Seasons: return seasons.count + 1
        case .Splits: return splits.count + 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! menuTableViewCell

        var icon: String!
        var text: String!
        
        switch location {
        case .Seasons:
            if indexPath.row == 0 {
                icon = "\u{f060}"
                text = "Back"
            } else {
                icon = "\u{f073}"
                text = "Season \(seasons[indexPath.row - 1])"
            }
            break
        case .Splits:
            if indexPath.row == 0 {
                icon = "\u{f060}"
                text = "Back"
            } else {
                icon = "\u{f253}"
                text = "\(splits[indexPath.row - 1].toString()) 201\(currentSeason)"
            }
            break
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
                //interface.switchToView(.games)
                
                let c = tableView.cellForRow(at: indexPath)
                c?.setSelected(true, animated: true)
                
                mm_drawerController.closeDrawer(animated: true, completion: nil)
                
            case 1:
                SCLAlertView().showInfo("Hey there!", subTitle: "Looks like this menu option isn't ready yet :(")
                break
                
            case 2:
                location = .Seasons
                seasons = GamesCommunicator.sharedInstance.availableSeasons()
                reload(with: nil)
                break
                
            case 3:
                SCLAlertView().showInfo("Hey there!", subTitle: "Looks like this menu option isn't ready yet :(")
                break
                
            case 4:
                SCLAlertView().showInfo("Hey there!", subTitle: "Looks like this menu option isn't ready yet :(")
            default:
                SCLAlertView().showError("Oops!", subTitle: "This should never happen. Report it to the developer and tell him he's shit")
                break
            }
            break
        case .Seasons:
            if indexPath.row == 0 {
                location = .Top
                reload(with: nil)
                return
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! menuTableViewCell
            let t = cell.descLabel.text
            let s = String(t!.split(separator: " ").last!)
            let si = Int(s)
            
            splits = GamesCommunicator.sharedInstance.splitsFor(season: si!)
            currentSeason = si!
            location = .Splits
            reload(with: nil)
            
            break
        case .Splits:
            /*
            if indexPath.row == 0 {
                location = .Seasons
                reload(with: nil)
                return
            }
            
            let cell = tableView.cellForRow(at: indexPath) as! menuTableViewCell
            let t = cell.descLabel.text
            let s = String(t!.split(separator: " ").first!)
            let si = SplitType.from(string: s)

            */
            SCLAlertView().showInfo("Hey there!", subTitle: "Looks like this menu option isn't ready yet :(")
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func reload(with a: TableViewAnimation.Cell?) {
        tableView.reloadData()
        tableView.animate(animation: a ?? TableViewAnimation.Cell.left(duration: 0.7))
    }
    
    @objc
    func returnUpLevel() {
        switch location {
        case .Splits:
            location = .Seasons
            currentSeason = 0
            reload(with: .right(duration: 0.7))
        case .Seasons:
            location = .Top
            currentSeason = 0
            reload(with: .right(duration: 0.7))
            
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
