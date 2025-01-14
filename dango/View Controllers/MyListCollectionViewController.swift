//
//  MyListCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/12.
//

import UIKit

class MyListCollectionViewController: SearchResultsCollectionViewController {
    var videosRequestTask: Task<Void, Never>? = nil
    deinit { videosRequestTask?.cancel() }
    
    var videoIds: [Int] {
        Settings.shared.myList.map { $0.id }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateMyList), name: Settings.myListUpdatedNotification, object: nil)
        
        search()
    }
    
    func search() {
        if videoIds.isEmpty {
            model.videos = []
            updateCollectionView()
        } else {
            videosRequestTask?.cancel()
            videosRequestTask = Task {
                if let videos = try? await VideosByIdsRequest(ids: videoIds).send() {
                    self.model.videos = videos
                } else {
                    self.model.videos = []
                }
                self.updateCollectionView()
                
                videosRequestTask = nil
            }
        }
    }
    
    @objc
    func updateMyList() {
        search()
    }
}
