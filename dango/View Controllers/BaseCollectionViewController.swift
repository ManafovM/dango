//
//  BaseCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/09.
//

import UIKit

class BaseCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = Color.darkBackground.value
    }
}
