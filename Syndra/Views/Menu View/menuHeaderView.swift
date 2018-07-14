//
//  menuHeaderView.swift
//  Syndra
//
//  Created by Mason Phillips on 6/26/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Toucan

class menuHeaderView: UIView {

    let backgroundImage: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
//        let i = Toucan(image: UIImage(named: "summer18")!).resize(CGSize(width: 200, height: 200), fitMode: .crop)
        backgroundImage.image = UIImage(named: "summer18")
        
        addSubview(backgroundImage)
        
    }
    
    override func layoutSubviews() {
        backgroundImage.fillSuperview()
    }
 
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
