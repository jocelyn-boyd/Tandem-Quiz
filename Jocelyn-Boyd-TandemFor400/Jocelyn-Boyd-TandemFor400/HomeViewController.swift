//
//  HomeViewController.swift
//  Jocelyn-Boyd-TandemFor400
//
//  Created by Jocelyn Boyd on 10/30/20.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet var rulesButton: UIButton!
    @IBOutlet var startRoundButton: UIButton!
    var buttons = [UIButton]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cofigureViewController()
    }
    
    private func cofigureViewController() {
        let buttons = [rulesButton, startRoundButton].compactMap { $0 }
        for button in buttons {
            button.layer.cornerRadius = 20
        }
        self.buttons = buttons
    }
}
