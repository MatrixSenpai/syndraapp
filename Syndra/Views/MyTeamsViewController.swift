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

class MyTeamsViewController: UIViewController {

    override var prefersStatusBarHidden: Bool { return true }
    
    let triangleView: SpringView
    
    let iconView: SpringImageView
    let team: SpringLabel
    let myTeam: SpringLabel
    
    var upcoming: UILabel
    var tt: UILabel
    
    var positions: Array<Member> = []
    
    init() {
        triangleView = SpringView()
        triangleView.backgroundColor = .flatOrange
        
        iconView = SpringImageView(image: UIImage(named: "FOX"))
        iconView.backgroundColor = .flatWhite
        iconView.layer.cornerRadius = 20
        triangleView.addSubview(iconView)
        
        team = SpringLabel()
        team.text = "My Team"
        team.textColor = .flatWhite
        team.font = UIFont.systemFont(ofSize: 25)
        triangleView.addSubview(team)
        
        myTeam = SpringLabel()
        myTeam.text = "Echo Fox"
        myTeam.textAlignment = .center
        myTeam.textColor = .flatWhite
        myTeam.font = UIFont.systemFont(ofSize: 35)
        triangleView.addSubview(myTeam)
        
        triangleView.animation = "slideDown"
        triangleView.y = -200
        triangleView.duration = 1.0
        triangleView.curve = "easeIn"
        
        upcoming = UILabel()
        upcoming.text = "Upcoming Games"
        upcoming.textColor = .flatWhite
        
        super.init(nibName: nil, bundle: nil)
        
        for _ in 0..<5 {
            let r = Member()
            positions.append(r)
            view.addSubview(r)
        }
        
        view.backgroundColor = .flatBlack
        
        view.addSubview(triangleView)
    }
    
    override func viewDidLayoutSubviews() {
        triangleView.anchorToEdge(.top, padding: 0, width: view.width, height: 200)
        
        iconView.anchorInCorner(.bottomLeft, xPad: 15, yPad: 15, width: 70, height: 70)
        myTeam.alignAndFillWidth(align: .toTheRightCentered, relativeTo: iconView, padding: 10, height: 70)
        
        team.alignAndFillWidth(align: .aboveMatchingLeft, relativeTo: iconView, padding: 20, height: 30)
        
        view.groupAgainstEdge(group: .vertical, views: positions, againstEdge: .bottom, padding: 10, width: view.width * 0.8, height: 100)
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        triangleView.animate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class Member: UIView {
    let position: UIImageView
    let name: UILabel
    let profile: UIImageView
    
    init() {
        position = UIImageView(image: UIImage(named: "Mid_icon"))
        name = UILabel()
        profile = UIImageView(image: UIImage(named: "TSM"))
        
        name.text = "Bjergsen"
        
        super.init(frame: CGRect())
        
        addSubview(position)
        addSubview(name)
        addSubview(profile)
        
        backgroundColor = .flatRedDark
    }
    
    override func layoutSubviews() {
        position.anchorToEdge(.left, padding: 10, width: 70, height: 70)
        
        profile.anchorToEdge(.right, padding: 10, width: 70, height: 70)
        
        name.alignBetweenHorizontal(align: .toTheRightCentered, primaryView: position, secondaryView: profile, padding: 15, height: 21)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
