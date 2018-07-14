//
//  scheduleItemSectionHeaderView.swift
//  Syndra
//
//  Created by Mason Phillips on 6/20/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class scheduleItemSectionHeaderView: UIView {

    let week: UILabel = UILabel()
    let dates: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        week.textColor = .flatWhite
        addSubview(week)
        
        dates.textColor = .flatWhite
        dates.textAlignment = .right
        addSubview(dates)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureDates(week w: String, dates d: String) {
        week.text = w
        dates.text = d
    }
    
    override func layoutSubviews() {
        backgroundColor = UIColor(gradientStyle: .leftToRight, withFrame: frame, andColors: [.flatSkyBlue, .flatRed])
        
        week.anchorAndFillEdge(.left, xPad: 5, yPad: 0, otherSize: width * 0.4)
        dates.anchorAndFillEdge(.right, xPad: 5, yPad: 0, otherSize: width * 0.4)
    }
}
