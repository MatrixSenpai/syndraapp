//
//  AppLoadingViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon
import NVActivityIndicatorView

class AppLoadingViewController: UIViewController, UpdateListener {

    var bg: UIImageView {
        return UIImageView(image: UIImage(named: "loading-back"))
    }
    
    let loader: NVActivityIndicatorView = NVActivityIndicatorView(frame: CGRect(), type: .lineScalePulseOut, color: .flatRed, padding: 20)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loader.startAnimating()
        view.addSubview(bg)
        view.addSubview(loader)
        
        GamesCommunicator.sharedInstance.progress = self
        GamesCommunicator.sharedInstance.initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        bg.fillSuperview()
        loader.anchorInCenter(width: 200, height: 200)
    }

    func didFinish() {
        (UIApplication.shared.delegate as! AppDelegate).showActual()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
