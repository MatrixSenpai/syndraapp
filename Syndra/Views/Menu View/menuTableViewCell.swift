//
//  menuTableViewCell.swift
//  Syndra
//
//  Created by Mason Phillips on 6/25/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class menuTableViewCell: UITableViewCell {

    let iconLabel: UILabel = UILabel()
    let descLabel: UILabel = UILabel()
    
    var isActive: Bool = false
    private var activeLayer: CALayer = CALayer()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconLabel.font = FAREGULAR_UIFONT
        addSubview(iconLabel)
        addSubview(descLabel)
        
        backgroundColor = .flatBlack
        
        iconLabel.textColor = .flatSkyBlue
        descLabel.textColor = .flatRed
        
        activeLayer.backgroundColor = UIColor.flatGreen.cgColor
        activeLayer.frame = CGRect(x: 0, y: 0, width: 5, height: 85)
        activeLayer.isHidden = true
        
        layer.addSublayer(activeLayer)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        iconLabel.anchorToEdge(.left, padding: 15, width: 25, height: 21)
        descLabel.alignAndFillWidth(align: .toTheRightCentered, relativeTo: iconLabel, padding: 10, height: 21)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        activeLayer.isHidden = !selected
        isActive = selected
    }

}
