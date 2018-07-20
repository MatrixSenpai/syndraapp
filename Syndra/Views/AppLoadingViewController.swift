//
//  AppLoadingViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 7/12/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon
import StepProgressView
import GCDKit

class AppLoadingViewController: UIViewController, UpdateListener {

    var bg: UIImageView!
    
    var viewTitle: UILabel!
    
    var loader: StepProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .flatBlack

        viewTitle = UILabel()
        viewTitle.text = "Now Loading..."
        viewTitle.textColor = .flatWhite
        viewTitle.font = UIFont.systemFont(ofSize: 28)
        
        loader = StepProgressView()
        loader.steps = ["Updating Local Games...", "Becoming Faker", "Fetching Current Season/Split", "Beating Bjergsen", "Fetching All Games", "Winning Worlds"]
        loader.currentStep = 0
        loader.firstStepShape = .downTriangle
        loader.lastStepShape = .triangle
        loader.stepShape = .rhombus
        loader.pastStepFillColor = .flatBlue
        loader.currentStepFillColor = .flatRed
        
        //bg = UIImageView(image: UIImage(named: "loading-back"))
        
        //view.addSubview(bg)
        view.addSubview(viewTitle)
        view.addSubview(loader)
        
        GamesCommunicator.sharedInstance.progress = self
        GamesCommunicator.sharedInstance.initialSetup()
    }
    
    override func viewDidLayoutSubviews() {
        //bg.fillSuperview()
        viewTitle.anchorToEdge(.top, padding: 160, width: view.width, height: viewTitle.intrinsicContentSize.height)
        loader.alignAndFillHeight(align: .underCentered, relativeTo: viewTitle, padding: 40, width: view.width * 0.8, offset: 20)
    }

    func didStart() {
        loader.currentStep = 0
    }
    
    func updateProgress(week: Int) {
        loader.details[4] = "Week \(week)/9"
    }
    
    func didChange(to step: Int) {
        loader.currentStep = step
    }
    
    func didFinish(update u: Bool) {
        if(!u) { WindowManager.sharedInstance.move(to: .today); return }
        loader.currentStep = 5
        loader.details[5] = "Done! Prepare..."
        
        GCDBlock.async(.background) {
            sleep(2)
            
            GCDBlock.async(.main, closure: {
                WindowManager.sharedInstance.move(to: .today)
            })
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
