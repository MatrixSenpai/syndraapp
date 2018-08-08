//
//  SplitGamesViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 7/25/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class SplitGamesViewController: MenuInterfacingViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let topView: UIView
    
    let competitionLabel: UILabel
    let menuButton: UIButton
    let rightButton: UIButton
    
    let weekBrowser: WeeksView
    
    let gamesView: UIScrollView
    
    let gameDayOne: DayView
    let gameDayTwo: DayView
    
    let bottomView: UIView
    let bottomLabel: UILabel
    let bottomSwitch: UISwitch
    
    override init() {
        topView = UIView()
        topView.backgroundColor = .flatBlack
        
        competitionLabel = UILabel()
        competitionLabel.text = "NA LCS"
        competitionLabel.textAlignment = .center
        competitionLabel.textColor = .flatWhite
        topView.addSubview(competitionLabel)
        
        menuButton = UIButton()
        menuButton.backgroundColor = .clear
        menuButton.titleLabel?.textColor = .flatWhite
        menuButton.setTitle("\u{f0c9}", for: .normal)
        menuButton.titleLabel?.font = FASOLID_UIFONT
        topView.addSubview(menuButton)
        
        rightButton = UIButton()
        rightButton.backgroundColor = .clear
        rightButton.titleLabel?.textColor = .flatWhite
        rightButton.setTitle("\u{f141}", for: .normal)
        rightButton.titleLabel?.font = FASOLID_UIFONT
        topView.addSubview(rightButton)
        
        weekBrowser = WeeksView()
        
        gamesView = UIScrollView()
        gamesView.isPagingEnabled = true
        gamesView.clipsToBounds = true
        
        gameDayOne = DayView()
        gamesView.addSubview(gameDayOne)
        
        gameDayTwo = DayView()
        gamesView.addSubview(gameDayTwo)
        
        bottomView = UIView()
        bottomView.backgroundColor = .flatBlack
        
        bottomLabel = UILabel()
        bottomLabel.text = "Notify Me When Today Starts"
        bottomLabel.textColor = .flatWhite
        bottomView.addSubview(bottomLabel)
        
        bottomSwitch = UISwitch()
        bottomView.addSubview(bottomSwitch)
        
        super.init()
        
        menuButton.addTarget(self, action: #selector(MenuInterfacingViewController.openLeft), for: .touchUpInside)
        
        view.backgroundColor = .flatBlackDark
        
        gameDayOne.parent = self
        gameDayTwo.parent = self
        
        view.addSubview(topView)
        view.addSubview(weekBrowser)
        
        view.addSubview(gamesView)
        view.addSubview(bottomView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        topView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 80)
        competitionLabel.anchorAndFillEdge(.bottom, xPad: 0, yPad: 10, otherSize: 22)
        menuButton.anchorInCorner(.bottomLeft, xPad: 5, yPad: 5, width: 50, height: 50)
        rightButton.anchorInCorner(.bottomRight, xPad: 5, yPad: 5, width: 50, height: 50)

        weekBrowser.alignAndFillWidth(align: .underCentered, relativeTo: topView, padding: 0, height: 40)
        
        bottomView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 100)
        bottomLabel.anchorInCorner(.topLeft, xPad: 10, yPad: 25, width: 250, height: 22)
        bottomSwitch.anchorInCorner(.topRight, xPad: 10, yPad: 25, width: 50, height: 22)
        
        gamesView.alignBetweenVertical(align: .underCentered, primaryView: weekBrowser, secondaryView: bottomView, padding: 15, width: view.width * 0.95)
        gamesView.contentSize = CGSize(width: ((view.width * 0.8) * 2) + 75, height: gamesView.height - 50)

        gameDayOne.anchorToEdge(.bottom, padding: 15, width: view.width * 0.8, height: gamesView.height - 50)
        gameDayOne.roundAll()
        gameDayTwo.align(.toTheRightCentered, relativeTo: gameDayOne, padding: 20, width: view.width * 0.8, height: gamesView.height - 50)
        gameDayTwo.roundAll()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        weekBrowser.initialWeekOffset = 9
    }
    
    func gameWasSelected() {
        let feedback = UIImpactFeedbackGenerator(style: .light)
        feedback.impactOccurred()

        let c = GameDetailViewController()
        c.parentVC = self
        self.present(c, animated: true, completion: nil)
    }
    
    func returnToView() {
        self.dismiss(animated: true, completion: nil)
    }
}
