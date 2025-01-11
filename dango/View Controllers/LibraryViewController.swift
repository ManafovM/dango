//
//  LibraryViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/11.
//

import UIKit

class LibraryViewController: BaseViewController {
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    var watchHistoryCollectionViewController: WatchHistoryCollectionViewController!
    var watchHistoryView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStackView()
        setupWatchHistoryView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        watchHistoryView.reloadSections(IndexSet(integer: 0))
    }
    
    func setupStackView() {
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.topAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupWatchHistoryView() {
        watchHistoryCollectionViewController = WatchHistoryCollectionViewController()
        addChild(watchHistoryCollectionViewController)
        
        watchHistoryView = watchHistoryCollectionViewController.collectionView
        stackView.addArrangedSubview(watchHistoryView)
        
        watchHistoryCollectionViewController.didMove(toParent: self)
    }
}
