//
//  LibraryViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/11.
//

import UIKit

class LibraryViewController: BaseViewController {
    var fetchVideosTask: Task<Void, Never>? = nil
    deinit { fetchVideosTask?.cancel() }
    
    let buttonsView = LibraryButtonsView()
    
    var watchHistoryCollectionViewController: WatchHistoryCollectionViewController!
    var watchHistoryView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchVideosForWatchHistory()
        setupWatchHistoryView()
        setupLibraryButtonsView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchVideosForWatchHistory()
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
        buttonsView.delegate = self
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
    
    func fetchVideosForWatchHistory() {
        fetchVideosTask?.cancel()
        fetchVideosTask = Task {
            let watchHistory = Settings.shared.watchHistory
            guard !watchHistory.isEmpty else { return }
            
            let watchHistoryDates = Dictionary(
                uniqueKeysWithValues: watchHistory.map { ($0.videoId, $0.lastWatchedDate) }
            )
            let videoIds = watchHistory.map { $0.videoId }
            
            if let newVideos = try? await VideosByIdsRequest(ids: videoIds).send() {
                let sortedVideos = newVideos.sorted {
                    guard let date1 = watchHistoryDates[$0.id], let date2 = watchHistoryDates[$1.id] else {
                        return false
                    }
                    return date1 > date2
                }
                
                watchHistoryCollectionViewController.videos = sortedVideos
                watchHistoryView.reloadSections(IndexSet(integer: 0))
            }
            
            fetchVideosTask = nil
        }
    }
}

extension LibraryViewController: LibraryButtonsViewDelegate {
    func myListTapped() {
        let myListController = MyListCollectionViewController()
        myListController.title = "マイリスト"
        
        let videoIds = Settings.shared.myList.map { $0.id }
        if !videoIds.isEmpty {
            myListController.search(by: videoIds)
        }
        
        navigationController?.pushViewController(myListController, animated: true)
    }
}
