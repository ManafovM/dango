//
//  BaseViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/11.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Color.darkBackground.value
        setupBackBarButton()
    }
    
    func setupBackBarButton() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButton.tintColor = .white
        navigationItem.backBarButtonItem = backBarButton
    }
}
