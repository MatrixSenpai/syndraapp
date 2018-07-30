//
//  SyndraLabel.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class SyndraLabel: UILabel {

    init(_ position: NSTextAlignment?, size: CGFloat?) {
        super.init(frame: CGRect())
        
        textColor = .flatWhite
        textAlignment = position ?? .left
        font = .systemFont(ofSize: size ?? UIFont.systemFontSize)
    }
    
    convenience init(_ position: NSTextAlignment?) {
        self.init(position, size: nil)
    }
    
    convenience init(withFA f: FAType, textPosition t: NSTextAlignment?, size s: CGFloat?) {
        self.init(t, size: s)
        
        switch f {
        case .light : font = FALIGHT_UIFONT
        case .normal: font = FAREGULAR_UIFONT
        case .solid : font = FASOLID_UIFONT
        case .logo  : font = FABRANDS_UIFONT
        }
    }
    
    public func multiline() {
        numberOfLines = 0
        lineBreakMode = .byWordWrapping
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

enum FAType {
    case light, normal, solid, logo
}
