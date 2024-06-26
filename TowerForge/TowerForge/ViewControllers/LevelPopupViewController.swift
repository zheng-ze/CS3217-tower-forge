//
//  LevelPopupViewController.swift
//  TowerForge
//
//  Created by Vanessa Mae on 09/04/24.
//

import Foundation
import UIKit

protocol LevelPopupDelegate: AnyObject {
    func handleLevel(level: Int)
}

class LevelPopupViewController: UIViewController {

    var delegate: LevelPopupDelegate?

    @IBAction private func onLevelOnePressed(_ sender: Any) {
        self.delegate?.handleLevel(level: 1)
        self.dismiss(animated: true)
    }
    @IBAction private func onLevelTwoPressed(_ sender: Any) {
        self.delegate?.handleLevel(level: 2)
        self.dismiss(animated: true)
    }
    @IBAction private func onLevelThreePressed(_ sender: Any) {
        self.delegate?.handleLevel(level: 3)
        self.dismiss(animated: true)
    }

    @IBAction private func onClosePressed(_ sender: Any) {
        self.dismiss(animated: true)
    }

    static func showDialogBox(parentVC: UIViewController) {
        if let levelPopupViewController = UIStoryboard(name: "Main", bundle: nil)
            .instantiateViewController(withIdentifier: "LevelPopupViewController")
            as? LevelPopupViewController {
            levelPopupViewController.modalTransitionStyle = .crossDissolve
            levelPopupViewController.modalPresentationStyle = .fullScreen
            levelPopupViewController.delegate = parentVC as? LevelPopupDelegate
            parentVC.present(levelPopupViewController, animated: true)
        }
    }
}
