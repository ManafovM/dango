//
//  LibraryViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/11.
//

import UIKit

class LibraryViewController: BaseViewController {
    var fetchVideosTask: Task<Void, Never>? = nil
    var videoRequestTasks: [Int: Task<Void, Never>] = [:]
    deinit {
        fetchVideosTask?.cancel()
        for task in videoRequestTasks.values {
            task.cancel()
        }
    }
    
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
            var videos = [Video?](repeating: nil, count: Settings.shared.watchHistory.count)
            
            await withTaskGroup(of: (Int, Video?).self) { group in
                for (index, element) in Settings.shared.watchHistory.enumerated() {
                    videoRequestTasks[element.videoId]?.cancel()
                    
                    group.addTask {
                        do {
                            let video = try await VideoByIdRequest(id: element.videoId).send()
                            return (index, video.first)
                        } catch {
                            print("Failed to fetch video for ID \(element.videoId): \(error)")
                            return (index, nil)
                        }
                    }
                }
                
                for await (index, video) in group {
                    if let video = video {
                        videos[index] = video
                    }
                }
            }
            
            let validVideos = videos.compactMap { $0 }
            
            watchHistoryCollectionViewController.videos = validVideos
            watchHistoryView.reloadSections(IndexSet(integer: 0))
            
            fetchVideosTask = nil
        }
    }
}
