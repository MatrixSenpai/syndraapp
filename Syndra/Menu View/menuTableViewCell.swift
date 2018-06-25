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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        iconLabel.font = FAREGULAR_UIFONT
        addSubview(iconLabel)
        addSubview(descLabel)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        iconLabel.anchorToEdge(.left, padding: 5, width: 25, height: 21)
        descLabel.alignAndFillWidth(align: .toTheRightCentered, relativeTo: iconLabel, padding: 10, height: 21)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
