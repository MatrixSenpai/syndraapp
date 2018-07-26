//
//  MyTeamsViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 7/21/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Spring
import Neon

class MyTeamsViewController: MenuInterfacingViewController, UIScrollViewDelegate {

    override var prefersStatusBarHidden: Bool { return true }
    
    var velocity: CGFloat = 0
    
    let headerView: UIView
    let bg: UIImageView

    let icon: UIImageView
    
    let name: UILabel
    let myT: UILabel
    
    let scrollView: UIScrollView
    
    let nextGames: MyTeamItemView
    let stats: MyTeamItemView
    let roster: MyTeamItemView
    
    let left: UIButton
    
    override init() {
        bg = UIImageView()
        bg.layer.opacity = 0.25
        
        icon = UIImageView()
        
        headerView = UIView()
        headerView.addSubview(bg)
        headerView.addSubview(icon)
        
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = true
        
        nextGames = MyTeamItemView()
        nextGames.label.text = "Upcoming Games"
        nextGames.configureGames()
        scrollView.addSubview(nextGames)
        
        stats = MyTeamItemView()
        stats.label.text = "Team Statistics"
        stats.configureStats()
        scrollView.addSubview(stats)
        
        roster = MyTeamItemView()
        roster.label.text = "Team Roster"
        roster.configureRoster()
        scrollView.addSubview(roster)
        
        name = UILabel()
        name.font = .systemFont(ofSize: 23)
        headerView.addSubview(name)
        
        myT = UILabel()
        myT.text = "My Team"
        myT.font = .systemFont(ofSize: 18)
        headerView.addSubview(myT)
        
        left = UIButton()
        left.setTitle("\u{f0c9}", for: .normal)
        left.titleLabel?.font = FASOLID_UIFONT
        
        super.init()
        
        left.addTarget(self, action: #selector(MyTeamsViewController.openLeft), for: .touchUpInside)
        
        scrollView.delegate = self

        view.backgroundColor = .flatBlackDark
        
        theme(with: .tsm)
                
        view.addSubview(headerView)
        view.addSubview(scrollView)
        view.addSubview(left)
    }
    
    override func viewDidLayoutSubviews() {
        headerView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 200)
        bg.fillSuperview()
        
        icon.anchorInCorner(.bottomLeft, xPad: 10, yPad: 10, width: 100, height: 100)
        
        myT.alignAndFillWidth(align: .toTheRightCentered, relativeTo: icon, padding: 15, height: 20)
        name.align(.underCentered, relativeTo: myT, padding: 5, width: myT.width, height: 25)
        
        let w = view.width * 0.8
        let h = view.height - 280
        
        scrollView.contentSize = CGSize(width: ((w + 20) * 3) + 75, height: h)
        
        scrollView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 50, otherSize: view.height - 250)
        nextGames.anchorToEdge(.bottom, padding: 5, width: w, height: h)
        stats.align(.toTheRightCentered, relativeTo: nextGames, padding: 20, width: w, height: h)
        roster.align(.toTheRightCentered, relativeTo: stats, padding: 20, width: w, height: h)
        
        left.anchorInCorner(.topLeft, xPad: 5, yPad: 30, width: 50, height: 50)
    }
    
    func theme(with t: Theme) {
        var textColor: UIColor
        var teamName: String
        var headerImage: UIImage?
        var iconImage: UIImage?
        var backgroundColor: UIColor
        var itemsBackgroundColor: UIColor
        var shadowColor: UIColor
        
        switch t {
        case .tsm:
            textColor = .flatWhite
            headerImage = UIImage(named: "tsm_header")
            iconImage = UIImage(named: "TSM")
            teamName = "Team Solo Mid"
            backgroundColor = .flatBlackDark
            itemsBackgroundColor = .flatBlack
            shadowColor = .flatGray
            break
        case .opt:
            textColor = .flatWhite
            headerImage = UIImage(named: "opt_header")
            iconImage = UIImage(named: "OPT")
            teamName = "OpTic Gaming"
            backgroundColor = .flatLimeDark
            itemsBackgroundColor = .flatLime
            shadowColor = .clear
            break
        case .t100:
            textColor = .flatWhite
            headerImage = UIImage(named: "100_header")
            iconImage = UIImage(named: "100")
            teamName = "100 Thieves"
            backgroundColor = .flatRedDark
            itemsBackgroundColor = .flatRed
            shadowColor = .clear
        case .c9:
            textColor = .flatWhite
            headerImage = UIImage(named: "c9_header")
            iconImage = UIImage(named: "C9")
            teamName = "Cloud9"
            backgroundColor = .flatPowderBlueDark
            itemsBackgroundColor = .flatPowderBlue
            shadowColor = .clear
        case .cg:
            textColor = .flatBlack
            headerImage = UIImage(named: "cg_header")
            iconImage = UIImage(named: "CG")
            teamName = "Clutch Gaming"
            backgroundColor = .flatRedDark
            itemsBackgroundColor = .flatRed
            shadowColor = .clear
        case .clg:
            textColor = .flatWhite
            headerImage = UIImage(named: "clg_header")
            iconImage = UIImage(named: "CLG")
            teamName = "Counter Logic Gaming"
            backgroundColor = .flatSkyBlueDark
            itemsBackgroundColor = .flatSkyBlue
            shadowColor = .clear
        case .fq:
            textColor = .flatBlack
            headerImage = UIImage(named: "fq_header")
            iconImage = UIImage(named: "FQ")
            teamName = "FlyQuest"
            backgroundColor = .flatYellowDark
            itemsBackgroundColor = .flatYellow
            shadowColor = .clear
        case .fox:
            textColor = .flatWhite
            headerImage = UIImage(named: "fox_header")
            iconImage = UIImage(named: "FOX")
            teamName = "Echo Fox"
            backgroundColor = .flatOrangeDark
            itemsBackgroundColor = .flatOrange
            shadowColor = .clear
        case .ggs:
            textColor = .flatWhite
            headerImage = UIImage(named: "ggs_header")
            iconImage = UIImage(named: "GGS")
            teamName = "Golden Guardians"
            backgroundColor = .flatYellowDark
            itemsBackgroundColor = .flatYellow
            shadowColor = .clear
        case .tl:
            textColor = .flatWhite
            headerImage = UIImage(named: "tl_header")
            iconImage = UIImage(named: "TL")
            teamName = "Team Liquid"
            backgroundColor = .flatBlueDark
            itemsBackgroundColor = .flatBlue
            shadowColor = .clear
        }
        
        bg.image = headerImage
        name.text = teamName
        icon.image = iconImage
        name.textColor = textColor
        myT.textColor = textColor
        
        nextGames.theme(using: textColor, andBackground: itemsBackgroundColor, withShadowColor: shadowColor)
        stats.theme(using: textColor, andBackground: itemsBackgroundColor, withShadowColor: shadowColor)
        roster.theme(using: textColor, andBackground: itemsBackgroundColor, withShadowColor: shadowColor)
        
        view.backgroundColor = backgroundColor
    }

    func setContentOffset(_ scrollView: UIScrollView) {
        let stopOver = (scrollView.contentSize.width - 75) / 3
        var x = round((scrollView.contentOffset.x + (velocity * 150)) / stopOver) * stopOver
        
        x = max(0, min(x, scrollView.contentSize.width - scrollView.frame.width))
        
        scrollView.setContentOffset(CGPoint(x: x, y: scrollView.contentOffset.y), animated: true)
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        self.velocity = velocity.x
    }

    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        setContentOffset(scrollView)
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        guard !decelerate else { return }
        setContentOffset(scrollView)
    }
}

class MyTeamItemView: RoundedView {
    let label: UILabel
    
    var items: [Item]
    
    init() {
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        
        items = []
        
        super.init(frame: CGRect())
        
        addSubview(label)
        
        
        roundAll()
    }
    
    func theme(using textColor: UIColor, andBackground b: UIColor, withShadowColor s: UIColor) {
        for i in items {
            i.label.textColor = textColor
        }
        
        label.textColor = textColor
        backgroundColor = b
        shadowColor = s
    }
    
    func configureGames() {
        for i in 0..<5 {
            let r = Item()
            if (i == 0) { r.roundTop() }
            if (i == 4) { r.roundBottom() }

            var n: String = ""
            var c: String = ""
            
            switch i {
            case 0: n = "Cloud9"; c = "C9"; break
            case 1: n = "FlyQuest"; c = "FQ"; break
            case 2: n = "Golden Guardians"; c = "GGS"; break
            case 3: n = "Echo Fox"; c = "FOX"; break
            case 4: fallthrough
            default: break
            }
            
            r.label.text = n
            r.icon.image = UIImage(named: c)
            
            items.append(r)
            addSubview(r)
        }
    }
    
    func configureStats() {
        for i in 0..<5 {
            let r = Item()
            if (i == 0) { r.roundTop() }
            if (i == 4) { r.roundBottom() }
            
            var n: String = ""
            var c: String = ""
            
            switch i {
            case 0: n = "Wins: 5"; c = ""; break
            case 1: n = "Losses: 5"; c = ""; break
            default: break
            }
            
            r.label.text = n
            
            items.append(r)
            addSubview(r)
        }
    }
    
    func configureRoster() {
        for i in 0..<5 {
            let r = Item()
            if (i == 0) { r.roundTop() }
            if (i == 4) { r.roundBottom() }
            
            switch i {
            case 0:
                r.label.text = "Hauntzer"
                r.icon.image = UIImage(named: "top")
                break
            case 1:
                r.label.text = "Grig"
                r.icon.image = UIImage(named: "jg")
                break
            case 2:
                r.label.text = "Bjergsen"
                r.icon.image = UIImage(named: "mid")
                break
            case 3:
                r.label.text = "Zven"
                r.icon.image = UIImage(named: "bot")
                break
            case 4: fallthrough
            default:
                r.label.text = "Mithy"
                r.icon.image = UIImage(named: "supp")
            }
            
            items.append(r)
            addSubview(r)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: self.width, height: 24)
        
        groupInCenter(group: .vertical, views: items, padding: 0, width: width - 20, height: 80)
        //groupAgainstEdge(group: .vertical, views: items, againstEdge: .bottom, padding: 0, width: self.width - 20, height: 80)
    }
}

class Item: RoundedView {
    let label: UILabel
    let icon: UIImageView
    
    init() {
        label = UILabel()
        label.textColor = .flatWhite
        icon = UIImageView()
        
        super.init(frame: CGRect())
        
        shadowColor = .clear
        
        addSubview(label)
        addSubview(icon)
    }
    
    override func layoutSubviews() {
        label.anchorToEdge(.left, padding: 5, width: 200, height: 22)
        icon.anchorToEdge(.right, padding: 5, width: 50, height: 50)
    }
}

enum Theme {
    case opt, ggs, fq, c9, cg, clg, tsm, t100, fox, tl
}
