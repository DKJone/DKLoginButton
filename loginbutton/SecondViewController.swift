//
//  SecondViewController.swift
//  SubmitTransition
//
//  Created by Takuya Okamoto on 2015/08/07.
//  Copyright (c) 2015年 Uniface. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet weak var button: DKTransitionButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let bg = UIImageView(image: UIImage(named: "Home"))
        bg.frame = self.view.frame
        button.backgroundColor = UIColor(red: 1, green: 0, blue: 128.0 / 255.0, alpha: 1)
        self.view.addSubview(bg)
        self.view.bringSubview(toFront: button)

    }

    @IBAction func onTapScreen() {
        button.moveToCenterExpand(0) {
            self.dismiss(animated: false, completion: nil)
        }

    }

}
