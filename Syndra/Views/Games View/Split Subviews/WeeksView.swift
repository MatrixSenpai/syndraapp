//
//  WeeksView.swift
//  Syndra
//
//  Created by Mason Phillips on 8/7/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class WeeksView: SyndraView {
    let scrollView: UIScrollView
    
    var weeks: Array<SyndraLabel>
    
    var parent: SplitGamesViewController?
    var initialWeekOffset: Int? {
        didSet {
            guard weeks.first!.frame != CGRect(x: 0, y: 0, width: 0, height: 0) else { return }
            setActiveWeek(offset: initialWeekOffset!)
        }
    }
    
    override init() {
        scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        
        weeks = []
        for i in 0..<9 {
            let l = SyndraLabel(.center, size: 15)
            l.text = "Week \(i + 1)"
            l.backgroundColor = .flatGray
            l.layer.masksToBounds = true
            
            weeks.append(l)
            scrollView.addSubview(l)
        }
        
        super.init()
        
        backgroundColor = .flatBlack
        
        addSubview(scrollView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        weeks.forEach { (l) in
            l.layer.cornerRadius = 15
        }
        
        scrollView.fillSuperview()
        scrollView.contentSize = CGSize(width: (95 * 9) + 10, height: 40)
        scrollView.groupAgainstEdge(group: .horizontal, views: weeks, againstEdge: .left, padding: 15, width: 80, height: 30)
        
        layer.addBorder(edge: .top, color: .flatPowderBlueDark, thickness: 0.2)
        layer.addBorder(edge: .bottom, color: .flatPowderBlueDark, thickness: 0.2)
        
        guard initialWeekOffset != nil else { return }
        setActiveWeek(offset: initialWeekOffset!)
    }
    
    func setActiveWeek(offset: Int) {
        let i = offset - 1
        let l = weeks[i]
        
        weeks.forEach { (ll) in
            ll.backgroundColor = .flatGray
        }
        
        l.backgroundColor = .flatWhiteDark
        
        let rect = CGRect(x: ((95 * i) + (10 / i)), y: 5, width: 80, height: 30)
        
        scrollView.scrollRectToVisible(rect, animated: true)
    }
}
