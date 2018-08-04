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
    
    let weekBrowser: UIView
    let prevWeek: UILabel
    let currentWeek: UILabel
    let nextWeek: UILabel
    
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
        
        weekBrowser = UIView()
        weekBrowser.backgroundColor = .flatBlack
        
        prevWeek = UILabel()
        prevWeek.text = "Week 4"
        prevWeek.textAlignment = .center
        prevWeek.font = .systemFont(ofSize: 15)
        prevWeek.backgroundColor = .flatWhiteDark
        prevWeek.layer.masksToBounds = true
        weekBrowser.addSubview(prevWeek)
        
        currentWeek = UILabel()
        currentWeek.text = "Week 5"
        currentWeek.textAlignment = .center
        currentWeek.font = .systemFont(ofSize: 15)
        currentWeek.backgroundColor = .flatWhite
        currentWeek.layer.masksToBounds = true
        weekBrowser.addSubview(currentWeek)

        nextWeek = UILabel()
        nextWeek.text = "Week 6"
        nextWeek.textAlignment = .center
        nextWeek.font = .systemFont(ofSize: 15)
        nextWeek.backgroundColor = .flatWhiteDark
        nextWeek.layer.masksToBounds = true
        weekBrowser.addSubview(nextWeek)
        
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
        weekBrowser.layer.addBorder(edge: .top, color: .flatPowderBlueDark, thickness: 0.2)
        weekBrowser.layer.addBorder(edge: .bottom, color: .flatPowderBlueDark, thickness: 0.2)

        currentWeek.anchorInCenter(width: 80, height: 30)
        currentWeek.layer.borderColor = UIColor.flatSkyBlue.cgColor
        currentWeek.layer.borderWidth = 0.5
        currentWeek.layer.cornerRadius = 15
        
        prevWeek.align(.toTheLeftCentered, relativeTo: currentWeek, padding: 15, width: 80, height: 30)
        prevWeek.layer.cornerRadius = 15
        
        nextWeek.align(.toTheRightCentered, relativeTo: currentWeek, padding: 15, width: 80, height: 30)
        nextWeek.layer.cornerRadius = 15
        
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

        // Do any additional setup after loading the view.
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

class DayView: RoundedView {
    let label: UILabel
    
    var parent: SplitGamesViewController?
    
    var games: Array<gameView> = []
    
    init() {
        label = UILabel()
        label.text = "Day 1"
        label.textColor = .flatWhite
        
        for _ in 0..<5 {
            let g = gameView()
            games.append(g)
        }
        
        super.init(frame: CGRect())
        
        for g in games {
            addSubview(g)
        }
        
        self.addSubview(label)
        
        backgroundColor = .flatBlack
    }
    
    func handleSelection() {
        parent?.gameWasSelected()
    }
    
    override func layoutSubviews() {
        label.anchorAndFillEdge(.top, xPad: 15, yPad: 15, otherSize: 22)

        groupAgainstEdge(group: .vertical, views: games, againstEdge: .bottom, padding: 0, width: width, height: (height - 45) / 5)
    }
}

class gameView: UIView {
    let blue: SyndraLabel
    let bicon: UIImageView
    let time: SyndraLabel
    let red: SyndraLabel
    let ricon: UIImageView
    
    let activate: UITapGestureRecognizer
    
    init() {
        blue = SyndraLabel()
        blue.backgroundColor = UIColor.flatSkyBlue.withAlphaComponent(0.5)
        blue.text = "TSM"
        blue.leftInset = 5.0
        
        bicon = UIImageView(image: UIImage(named: "TSM"))
        
        time = SyndraLabel(.center)
        time.text = "1600"
        time.backgroundColor = .clear
        time.layer.borderColor = UIColor.flatWhite.cgColor
        time.layer.borderWidth = 1
        
        red = SyndraLabel(.right)
        red.backgroundColor = UIColor.flatRed.withAlphaComponent(0.5)
        red.text = "FOX"
        red.rightInset = 5.0
        
        ricon = UIImageView(image: UIImage(named: "FOX"))
        
        activate = UITapGestureRecognizer()
        activate.numberOfTapsRequired = 1
        activate.numberOfTouchesRequired = 1
        
        super.init(frame: CGRect())
        
        activate.addTarget(self, action: #selector(gameView.handleTap(sender:)))
        addGestureRecognizer(activate)
        
        addSubview(blue)
        addSubview(bicon)
        addSubview(time)
        addSubview(ricon)
        addSubview(red)
    }
    
    override func layoutSubviews() {
        time.anchorInCenter(width: 50, height: height)
        bicon.align(.toTheLeftCentered, relativeTo: time, padding: 5, width: 40, height: 40)
        ricon.align(.toTheRightCentered, relativeTo: time, padding: 5, width: 40, height: 40)
        
        blue.alignAndFillWidth(align: .toTheLeftCentered, relativeTo: time, padding: 0, height: height)
        red.alignAndFillWidth(align: .toTheRightCentered, relativeTo: time, padding: 0, height: height)
        
        
        blue.layer.addBorder(edge: .top, color: .flatWhite, thickness: 1)
        blue.layer.addBorder(edge: .bottom, color: .flatWhite, thickness: 1)

        red.layer.addBorder(edge: .top, color: .flatWhite, thickness: 1)
        red.layer.addBorder(edge: .bottom, color: .flatWhite, thickness: 1)
    }
    
    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        (superview as! DayView).handleSelection()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

@available(iOS 9.0, *)
class ForceGestureRecognizer: UIGestureRecognizer {
    
    var forceValue: CGFloat = 0
    var maxValue: CGFloat!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        handleForceWithTouches(touches: touches)
        state = .began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        handleForceWithTouches(touches: touches)
        state = .changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesEnded(touches, with: event)
        handleForceWithTouches(touches: touches)
        state = .ended
    }
    
    func handleForceWithTouches(touches: Set<UITouch>) {
        
        //only do something is one touch is received
        if touches.count != 1 {
            state = .failed
            return
        }
        
        //check if touch is valid, otherwise set state to failed and return
        guard let touch = touches.first else {
            state = .failed
            return
        }
        
        //if everything is ok, set our variables.
        forceValue = touch.force
        maxValue = touch.maximumPossibleForce
    }
    
    //This is called when our state is set to .ended.
    public override func reset() {
        super.reset()
        print("reset")
        forceValue = 0.0
    }
}
