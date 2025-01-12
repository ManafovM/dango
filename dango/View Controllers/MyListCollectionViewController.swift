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
    
    func search(by videoIds: [Int]) {
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
