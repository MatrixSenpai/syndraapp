//
//  GameDetailViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 7/31/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import MessageUI

class GameDetailViewController: UIViewController, MFMessageComposeViewControllerDelegate {

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var parentVC: SplitGamesViewController?
    
    let teamTimeView: TeamTimeView
    
    
    let rosterView: UIView
    let top : RosterItemView
    let jg  : RosterItemView
    let mid : RosterItemView
    let bot : RosterItemView
    let supp: RosterItemView
    
    let actionsView: UIView
    
    let backButton: SyndraButton
    let sheetButton: SyndraButton
    let messageButton: SyndraButton
    let notifyButton: SyndraButton
    
    init() {
        teamTimeView = TeamTimeView()        
        
        rosterView = UIView()
        rosterView.backgroundColor = .flatBlackDark
        
        top = RosterItemView(left: "Hauntzer", right: "Huni", position: .top)
        rosterView.addSubview(top)
        jg = RosterItemView(left: "Grig", right: "Dardoch", position: .jg)
        rosterView.addSubview(jg)
        mid = RosterItemView(left: "Bjergsen", right: "Damonte", position: .mid)
        rosterView.addSubview(mid)
        bot = RosterItemView(left: "Zven", right: "Lost", position: .bot)
        rosterView.addSubview(bot)
        supp = RosterItemView(left: "Mithy", right: "Smoothie", position: .supp)
        rosterView.addSubview(supp)
        
        actionsView = UIView()
        actionsView.backgroundColor = .flatBlack
        
        backButton = SyndraButton(faType: .solid, backgroundColor: nil, text: "\u{f355}")
        actionsView.addSubview(backButton)
        
        sheetButton = SyndraButton(faType: .solid, backgroundColor: nil, text: "\u{f14d}")
        actionsView.addSubview(sheetButton)
        
        messageButton = SyndraButton(faType: .solid, backgroundColor: nil, text: "\u{f27a}")
        actionsView.addSubview(messageButton)
        
        notifyButton = SyndraButton(faType: .solid, backgroundColor: nil, text: "\u{f0f3}")
        actionsView.addSubview(notifyButton)
        
        super.init(nibName: nil, bundle: nil)
        
        backButton.addTarget(self, action: #selector(GameDetailViewController.returnToParent), for: .touchUpInside)
        messageButton.addTarget(self, action: #selector(GameDetailViewController.sendMessage), for: .touchUpInside)
        
        view.addSubview(teamTimeView)
        view.addSubview(rosterView)
        view.addSubview(actionsView)
    }
    
    override func viewDidLayoutSubviews() {
        teamTimeView.anchorAndFillEdge(.top, xPad: 0, yPad: 0, otherSize: 200)
        
        actionsView.anchorAndFillEdge(.bottom, xPad: 0, yPad: 0, otherSize: 100)        
        actionsView.groupAgainstEdge(group: .horizontal, views: [backButton, messageButton, sheetButton, notifyButton], againstEdge: .top, padding: 15, width: 80, height: 30)
        
        rosterView.alignBetweenVertical(align: .underCentered, primaryView: teamTimeView, secondaryView: actionsView, padding: 0, width: view.width)
        rosterView.groupAndFill(group: .vertical, views: [top, jg, mid, bot, supp], padding: 0)
    }
    
    @objc
    func returnToParent() {
        parentVC?.returnToView()
    }
    
    @objc
    func sendMessage() {
        guard MFMessageComposeViewController.canSendText() else { return }
        
        let vc = MFMessageComposeViewController()
        vc.body = "syqen://game/8/2/zzzzzzz \nCheck out today's game!\nTSM vs FOX - 05 August at 1600"
        vc.messageComposeDelegate = self
        
        self.present(vc, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
