//
//  VideoDetailsViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

class VideoDetailsViewController: UIViewController {
    var imageRequestTask: Task<Void, Never>? = nil
    deinit { imageRequestTask?.cancel() }
    
    @IBOutlet weak var topImage: UIImageView!
    
    let video: Video!
    
    init?(coder: NSCoder, video: Video) {
        self.video = video
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageRequestTask = Task {
            if let image = try? await ImageRequest(imagePath: video.thumbnailUrl).send() {
                self.topImage.image = image
            }
            imageRequestTask = nil
        }
    }
    
    @IBAction func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
