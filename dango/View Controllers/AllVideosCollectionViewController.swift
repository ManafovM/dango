//
//  AllVideosCollectionViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2025/01/09.
//

import Foundation

class AllVideosCollectionViewController: SearchResultsCollectionViewController {
    var allVideosRequestTask: Task<Void, Never>? = nil
    deinit { allVideosRequestTask?.cancel() }
    
    override func search(for searchTerm: String) {
        allVideosRequestTask?.cancel()
        allVideosRequestTask = Task {
            if let videos = try? await AllVideosRequest().send() {
                self.model.videos = videos
            } else {
                self.model.videos = []
            }
            self.updateCollectionView()
            
            allVideosRequestTask = nil
        }
    }
}
