//
//  LibraryViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/11.
//

import UIKit

class LibraryViewController: BaseViewController {
    let buttonsView = LibraryButtonsView()
    
    var watchHistoryCollectionViewController: WatchHistoryCollectionViewController!
    var watchHistoryView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupWatchHistoryView()
        setupLibraryButtonsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        watchHistoryView.reloadSections(IndexSet(integer: 0))
    }
    
    func setupWatchHistoryView() {
        watchHistoryCollectionViewController = WatchHistoryCollectionViewController()
        addChild(watchHistoryCollectionViewController)
        
        watchHistoryView = watchHistoryCollectionViewController.collectionView
        view.addSubview(watchHistoryView)
        watchHistoryView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            watchHistoryView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            watchHistoryView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            watchHistoryView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            watchHistoryView.heightAnchor.constraint(equalToConstant: calculateHeightOfWatchHistoryView())
        ])
        
        watchHistoryCollectionViewController.didMove(toParent: self)
    }
    
    func setupLibraryButtonsView() {
        view.addSubview(buttonsView)
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            buttonsView.topAnchor.constraint(equalTo: watchHistoryView.bottomAnchor),
            buttonsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            buttonsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
    
    func calculateHeightOfWatchHistoryView() -> CGFloat {
        let cellHeight = Int(view.frame.width * 0.5 / 16 * 9)
        let spacing = 4
        let headerHeight = 36
        return CGFloat(cellHeight + spacing + headerHeight)
    }
}
