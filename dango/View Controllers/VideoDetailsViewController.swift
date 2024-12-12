//
//  VideoDetailsViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

class VideoDetailsViewController: BaseViewController, UIScrollViewDelegate {
    var imageRequestTask: Task<Void, Never>? = nil
    deinit { imageRequestTask?.cancel() }
    
    let topImage = FadeEdgeImageView()
    var topImageHeight: CGFloat!
    let scrollView = UIScrollView()
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .systemThickMaterialDark))
    
    let video: Video!
    
    @IBOutlet weak var closeButton: UIButton!
    
    init?(coder: NSCoder, video: Video) {
        self.video = video
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    func setupView() {
        setupScrollView()
        setupTopImageView()
        
        view.bringSubviewToFront(closeButton)
    }
    
    func setupScrollView() {
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height * 2)
        scrollView.delegate = self
        view.addSubview(scrollView)
    }
    
    func setupTopImageView() {
        topImageHeight = view.frame.width * 9 / 16
        topImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: topImageHeight)
        topImage.contentMode = .scaleAspectFill
        topImage.clipsToBounds = true
        view.addSubview(topImage)
        
        loadTopImage()
        setupBlurEffectView()
    }
    
    func loadTopImage() {
        imageRequestTask = Task {
            if let image = try? await ImageRequest(imagePath: video.thumbnailUrl).send() {
                self.topImage.image = image
            }
            imageRequestTask = nil
        }
    }
    
    func setupBlurEffectView() {
        visualEffectView.frame = topImage.bounds
        visualEffectView.alpha = 0
        topImage.addSubview(visualEffectView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        
        if yOffset < 0 {
            topImage.frame = CGRect(
                x: yOffset / 2,
                y: yOffset,
                width: view.frame.width - yOffset,
                height: topImageHeight - yOffset
            )
        } else {
            let shrinkFactor = max(0, topImageHeight - yOffset)
            topImage.frame = CGRect(
                x: 0,
                y: 0,
                width: view.frame.width,
                height: shrinkFactor
            )
        }
        
        let blurAlpha = min(1.0, yOffset / topImageHeight)
        visualEffectView.alpha = blurAlpha
        visualEffectView.frame = topImage.bounds
    }
    
    @IBAction func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
