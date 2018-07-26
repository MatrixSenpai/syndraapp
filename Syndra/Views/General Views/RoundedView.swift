//
//  RoundedView.swift
//  Syndra
//
//  Created by Mason Phillips on 7/23/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class RoundedView: UIView {
    
    var shadowColor: UIColor?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    private func round() {
        layer.cornerRadius = 5
        layer.shadowColor = self.shadowColor?.cgColor ?? UIColor.clear.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 3
        layer.shadowOffset = .zero
    }
    
    func roundBottom() {
        layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        round()
        layoutSubviews()
    }
    
    func roundTop() {
        layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        round()
        layoutSubviews()
    }
    
    func roundAll() {
        round()
        layoutSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

}
