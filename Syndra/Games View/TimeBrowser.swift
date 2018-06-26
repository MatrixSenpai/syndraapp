//
//  TimeBrowser.swift
//  Syndra
//
//  Created by Mason Phillips on 6/25/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import PMSuperButton
import Neon

class TimeBrowser: UIView {
    var parent: TimeListener?
    
    let one  : PMSuperButton = PMSuperButton()
    let two  : PMSuperButton = PMSuperButton()
    let three: PMSuperButton = PMSuperButton()
    let four : PMSuperButton = PMSuperButton()
    let five : PMSuperButton = PMSuperButton()
    let six  : PMSuperButton = PMSuperButton()
    let seven: PMSuperButton = PMSuperButton()
    let eight: PMSuperButton = PMSuperButton()
    let nine : PMSuperButton = PMSuperButton()
    
    var buttons: [Frameable] {
        return [one, two, three, four, five, six, seven, eight, nine]
    }
    
    init() {
        super.init(frame: CGRect())
        
        var i: Int = 0
        for b in buttons {
            guard let p = b as? PMSuperButton else { fatalError("Could not cast button back to its original type???") }
            
            p.setTitle("\(i + 1)", for: .normal)
            p.tag = i
            p.layer.cornerRadius = 10
            p.clipsToBounds = true
            p.backgroundColor = .flatForestGreen
            p.titleLabel?.textColor = .flatWhite
            p.addTarget(self, action: #selector(TimeBrowser.goTo(sender:)), for: .touchUpInside)
            
            addSubview(p)
            
            i += 1
        }

        let pan = UIPanGestureRecognizer(target: self, action: #selector(TimeBrowser.handleScroll(recognizer:)))
        addGestureRecognizer(pan)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: frame, andColors: [.flatSkyBlue, .flatRedDark])
        
        groupAgainstEdge(group: .horizontal, views: buttons, againstEdge: .top, padding: 5, width: 35, height: 40)
    }
    
    @objc
    func goTo(sender: PMSuperButton) {
        let index = IndexPath(row: 0, section: sender.tag)
        parent?.tableView.scrollToRow(at: index, at: .top, animated: true)
    }
    
    @objc
    func handleScroll(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self)

        for b in buttons {
            guard let b = b as? PMSuperButton else { fatalError("Could not cast back to original type??") }
            
            if b.point(inside: translation, with: nil) {
                let t = b.tag
                
                let i = IndexPath(row: 0, section: t)
                
                self.parent?.scrollTo(row: i, at: .top, animated: false)
            }
        }
    }
}

protocol TimeListener {
    var tableView: UITableView { get set }
    
    func scrollTo(row: IndexPath, at: UITableView.ScrollPosition, animated: Bool)
}
