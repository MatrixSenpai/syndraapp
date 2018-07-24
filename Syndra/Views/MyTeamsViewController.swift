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

class MyTeamsViewController: UIViewController, UIScrollViewDelegate {

    override var prefersStatusBarHidden: Bool { return true }
    
    var velocity: CGFloat = 0
    
    let headerView: UIView
    let bg = UIImageView(image: UIImage(named: "tsm_header"))

    let icon: UIImageView = UIImageView(image: UIImage(named: "TSM"))
    
    let scrollView: UIScrollView
    
    let nextGames: MyTeamItemView
    let stats: MyTeamItemView
    let roster: MyTeamItemView
    
    init() {
        bg.layer.opacity = 0.5
        
        headerView = UIView()
        headerView.addSubview(bg)
        headerView.addSubview(icon)
        
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.clipsToBounds = false
        
        nextGames = MyTeamItemView()
        nextGames.label.text = "Upcoming Games"
        scrollView.addSubview(nextGames)
        
        stats = MyTeamItemView()
        stats.label.text = "Team Statistics"
        scrollView.addSubview(stats)
        
        roster = MyTeamItemView()
        roster.label.text = "Team Roster"
        scrollView.addSubview(roster)
        
        super.init(nibName: nil, bundle: nil)
        
        scrollView.delegate = self

        view.addSubview(headerView)
        view.addSubview(scrollView)
    }
    
    override func viewDidLayoutSubviews() {
        headerView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 200)
        bg.fillSuperview()
        
        icon.anchorInCenter(width: 70, height: 70)
        
        let w = view.width * 0.8
        let h = view.height - 280
        
        scrollView.contentSize = CGSize(width: ((w + 20) * 3) + 75, height: h)
        
        scrollView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 50, otherSize: view.height - 250)
        nextGames.anchorToEdge(.bottom, padding: 5, width: w, height: h)
        stats.align(.toTheRightCentered, relativeTo: nextGames, padding: 20, width: w, height: h)
        roster.align(.toTheRightCentered, relativeTo: stats, padding: 20, width: w, height: h)
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
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

class MyTeamItemView: RoundedView {
    let label: UILabel
    
    init() {
        label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22)
        label.textColor = .flatWhite
        
        super.init(frame: CGRect())
        
        self.backgroundColor = .flatBlack
        addSubview(label)
        
        roundAll()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        label.anchorInCorner(.topLeft, xPad: 15, yPad: 15, width: self.width, height: 24)
    }
}
