//
//  OnboardMaster.swift
//  Syndra
//
//  Created by Mason Phillips on 7/29/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit

class OnboardMaster: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    let pageControl: UIPageControl
    
    let left: UIButton
    let right: UIButton
    
    var pages: Array<OnboardChild> {
        let w = WelcomeOnboard()
        w.index = 0
        let a = AboutOnboard()
        a.index = 1
        let t = TeamOnboard()
        t.index = 2
        let n = NotifOnboard()
        n.index = 3
        let f = FinalOnboard()
        f.index = 4
        
        return [w, a, t, n, f]
    }

    init() {
        pageControl = UIPageControl()
        pageControl.tintColor = .flatGray
        pageControl.currentPageIndicatorTintColor = .flatWhite
        pageControl.currentPage = 0
        
        left = UIButton()
        left.titleLabel?.font = FASOLID_UIFONT
        left.setTitleColor(.flatWhite, for: .normal)
        left.setTitle("\u{f33a}", for: .normal)
        
        right = UIButton()
        right.titleLabel?.font = FASOLID_UIFONT
        right.setTitleColor(.flatWhite, for: .normal)
        right.setTitle("\u{f33b}", for: .normal)
        
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        
        pageControl.numberOfPages = pages.count
        view.addSubview(pageControl)
        
        left.addTarget(self, action: #selector(OnboardMaster.handleLeft), for: .touchUpInside)
        view.addSubview(left)

        right.addTarget(self, action: #selector(OnboardMaster.handleRight), for: .touchUpInside)
        view.addSubview(right)
        
        delegate = self
        dataSource = self
        
        view.backgroundColor = .flatBlack
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let first = pages.first {
            setViewControllers([first], direction: .forward, animated: true, completion: nil)
            left.isHidden = true
        }
    }
    override func viewDidLayoutSubviews() {
        pageControl.anchorToEdge(.bottom, padding: 30, width: view.width, height: 50)
        
        left.anchorInCorner(.bottomLeft, xPad: 0, yPad: 80, width: 50, height: 50)
        right.anchorInCorner(.bottomRight, xPad: 0, yPad: 80, width: 50, height: 50)
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vc = pendingViewControllers.first as? OnboardChild else { fatalError() }
        guard let index = vc.index else { return }
        
        pageControl.currentPage = index
        
        left.isHidden = false
        right.isHidden = false
        
        if(index == 0) { left.isHidden = true }
        if(index == (pages.count - 1)) { right.isHidden = true }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardChild else { fatalError() }
        let index = vc.index!
        let previous = index - 1
        guard previous >= 0 else { return nil }
        
        return pages[previous]
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let vc = viewController as? OnboardChild else { fatalError() }
        let index = vc.index!
        let next = index + 1
        guard next < pages.count else { return nil }
        
        return pages[next]
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pages.count
    }
    
    @objc
    func handleLeft() {
        let i = pageControl.currentPage
        moveToPage(i - 1)
    }
    @objc
    func handleRight() {
        let i = pageControl.currentPage
        moveToPage(i + 1)
    }
    
    func moveToPage(_ index: Int) {
        let vc = pages[index]
        let cindex = pageControl.currentPage
        
        let direction: NavigationDirection = ((cindex < index) ? .forward : .reverse)
        
        setViewControllers([vc], direction: direction, animated: true, completion: nil)
        
        left.isHidden = false
        right.isHidden = false
        
        if(index == 0) { left.isHidden = true }
        if(index == (pages.count - 1)) { right.isHidden = true }

        pageControl.currentPage = index
    }
    
    func handleDone() {
        WindowManager.sharedInstance.move(to: .team)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

class OnboardChild: UIViewController {
    
    var index: Int!
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
