//
//  MenuInterfacingController.swift
//  Syndra
//
//  Created by Mason Phillips on 6/10/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import MMDrawerController

class MenuInterfacingViewController: UIViewController {
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var leftButton: MMDrawerBarButtonItem {
        let b = MMDrawerBarButtonItem(title: "\u{f0c9}", style: .plain, target: self, action: #selector(self.openLeft))
        b.setTitleTextAttributes(FALIGHT_ATTR, for: .normal)
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc internal func openLeft() {
        if(mm_drawerController.openSide == .left) { mm_drawerController.closeDrawer(animated: true, completion: nil); return }
        mm_drawerController.open(.left, animated: true, completion: nil)
    }
    
    @objc internal func openRight() {
        if(mm_drawerController.openSide == .right) { mm_drawerController.closeDrawer(animated: true, completion: nil); return }
        mm_drawerController.open(.right, animated: true, completion: nil)
    }
}

class MenuInterfacingTableViewController: UITableViewController {
    var leftButton: MMDrawerBarButtonItem {
        let b = MMDrawerBarButtonItem(title: "\u{f0c9}", style: .plain, target: self, action: #selector(self.openLeft))
        b.setTitleTextAttributes(FALIGHT_ATTR, for: .normal)
        return b
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc private func openLeft() {
        if(mm_drawerController.openSide == .left) { mm_drawerController.closeDrawer(animated: true, completion: nil); return }
        mm_drawerController.open(.left, animated: true, completion: nil)
    }
    
    @objc internal func openRight() {
        if(mm_drawerController.openSide == .right) { mm_drawerController.closeDrawer(animated: true, completion: nil); return }
        mm_drawerController.open(.right, animated: true, completion: nil)
    }
}
