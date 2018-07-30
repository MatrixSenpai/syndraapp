//
//  OnboardMaster.swift
//  Syndra
//
//  Created by Mason Phillips on 7/29/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import arek

class OnboardMaster: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var pages: Array<OnboardChild> {
        let npage = OnboardChild(showButton: true)
        npage.titleLabel.text = "Allow Notifications"
        npage.descriptionLabel.text = fetchString(forKey: "allow_notif_string")
        npage.actionButton.addTarget(self, action: #selector(OnboardMaster.presentNotification), for: .touchUpInside)
        npage.actionButton.setTitle("Allow Notifications", for: .normal)
        
        return [npage]
    }

    init() {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        delegate = self
        dataSource = self
        
        view.backgroundColor = .flatBlack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardChild else { fatalError() }
        guard let index: Int = pages.firstIndex(of: vc) else { return nil }
        let previous = index - 1
        guard previous >= 0 else { return nil }
        
        return pages[previous]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardChild else { fatalError() }
        guard let index: Int = pages.firstIndex(of: vc) else { return nil }
        let next = index + 1
        guard next <= pages.count else { WindowManager.sharedInstance.move(to: .games); return nil }

        return pages[next]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 1
    }
    
    @objc
    func presentNotification() {
        let permission = ArekNotifications()
        
        permission.manage { (status) in
            print(status.rawValue)
        }
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class OnboardChild: UIViewController {
    let titleLabel: UILabel
    let descriptionLabel: UILabel
    
    let actionButton: UIButton
    let buttonIsVisible: Bool
    
    init(showButton: Bool) {
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.textColor = .flatWhite
        titleLabel.textAlignment = .center
        
        descriptionLabel = UILabel()
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .flatWhite
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        
        actionButton = UIButton()
        actionButton.backgroundColor = .flatSkyBlue
        actionButton.layer.cornerRadius = 10
        buttonIsVisible = showButton
        
        super.init(nibName: nil, bundle: nil)
        
        view.backgroundColor = .flatBlack
        
        view.addSubview(titleLabel)
        view.addSubview(descriptionLabel)
        if(showButton) { view.addSubview(actionButton) }
    }
    
    override func viewDidLayoutSubviews() {
        if(buttonIsVisible) {
            actionButton.anchorAndFillEdge(.bottom, xPad: 50, yPad: 100, otherSize: 40)
            
            descriptionLabel.alignAndFillWidth(align: .aboveCentered, relativeTo: actionButton, padding: 50, height: 100)
        } else {
            descriptionLabel.anchorAndFillEdge(.bottom, xPad: 20, yPad: 100, otherSize: 100)
        }
        
        titleLabel.alignAndFillWidth(align: .aboveCentered, relativeTo: descriptionLabel, padding: 30, height: 22)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
