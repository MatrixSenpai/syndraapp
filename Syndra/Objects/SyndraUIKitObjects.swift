//
//  SyndraUIKitObjects.swift
//  Syndra
//
//  Created by Mason Phillips on 7/30/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class SyndraLabel: UILabel {

    var topInset: CGFloat = 0.0
    var bottomInset: CGFloat = 0.0
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(width: size.width + leftInset + rightInset,
                      height: size.height + topInset + bottomInset)
    }
    
    init(_ position: NSTextAlignment?, size: CGFloat?) {
        super.init(frame: CGRect())
        
        textColor = .flatWhite
        textAlignment = position ?? .left
        font = .systemFont(ofSize: size ?? UIFont.systemFontSize)
    }
    
    convenience init() {
        self.init(nil)
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

    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: rect.inset(by: insets))
    }
    
}

class SyndraButton: UIButton {
    init(backgroundColor bg: UIColor?, text t: String) {
        super.init(frame: CGRect())
        
        titleLabel?.textColor = .flatWhite
        setTitle(t, for: .normal)
        backgroundColor = bg ?? .clear
    }
    
    convenience init(faType f: FAType, backgroundColor bg: UIColor?, text t: String) {
        self.init(backgroundColor: bg, text: t)
        
        let font: UIFont
        switch f {
        case .light : font = FALIGHT_UIFONT
        case .normal: font = FAREGULAR_UIFONT
        case .solid : font = FASOLID_UIFONT
        case .logo  : font = FABRANDS_UIFONT
        }
        
        titleLabel?.font = font
    }
    
    convenience init() {
        self.init(backgroundColor: nil, text: "")
    }
    
    func roundCorners() {
        layer.cornerRadius = height * 0.33
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

// Convenience...tired of using the "required" init
class SyndraView: UIView {
    init() {
        super.init(frame: CGRect())
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}

enum FAType {
    case light, normal, solid, logo
}
