//
//  VideoDetailsViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

class VideoDetailsViewController: BaseViewController, UIScrollViewDelegate {
    let topImageView: VideoDetailsTopImageView
    let scrollView = UIScrollView()
    let videoDetailsView: VideoDetailsView
    
    let video: Video!
    
    @IBOutlet weak var closeButton: UIButton!
    
    init?(coder: NSCoder, video: Video) {
        self.video = video
        self.topImageView = VideoDetailsTopImageView(frame: .zero)
        self.videoDetailsView = VideoDetailsView(frame: .zero, video: video)
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
        setupTopImageView()
        setupScrollView()
        setupVideoDetailsView()
        
        view.bringSubviewToFront(closeButton)
    }
    
    func setupTopImageView() {
        let defaultHeight = view.frame.width * 9 / 16
        topImageView.defaultHeight = defaultHeight
        topImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: defaultHeight)
        topImageView.loadImage(from: video.thumbnailUrl)
        view.addSubview(topImageView)
    }
    
    func setupScrollView() {
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
    
    func setupVideoDetailsView() {
        scrollView.addSubview(videoDetailsView)
        videoDetailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoDetailsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topImageView.frame.height * 0.95),
            videoDetailsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            videoDetailsView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            videoDetailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            videoDetailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y
        topImageView.updateFrameForOffset(yOffset, parentFrameWidth: view.frame.width)
    }
    
    @IBAction func closeButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
