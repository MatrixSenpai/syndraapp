//
//  gameFilterViewController.swift
//  Syndra
//
//  Created by Mason Phillips on 6/8/18.
//  Copyright © 2018 Mason Phillips. All rights reserved.
//

import UIKit
import Neon

class gameFilterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        let later = UILabel()
        later.textAlignment = .left
        later.text = "This isn't ready yet :("
        view.addSubview(later)
        later.anchorInCenter(width: 300, height: 42)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
