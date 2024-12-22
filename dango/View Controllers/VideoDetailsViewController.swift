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
    var relatedVideosCollectionView: UICollectionView!
    
    let video: Video!
    var relatedVideos = [Video]()
    
    @IBOutlet weak var closeButton: UIButton!
    
    init?(coder: NSCoder, video: Video) {
        self.video = video
        self.relatedVideos = [video]
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
        setupRelatedVideosView()
        
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
            videoDetailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            videoDetailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupRelatedVideosView() {
        relatedVideosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        relatedVideosCollectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        relatedVideosCollectionView.delegate = self
        relatedVideosCollectionView.dataSource = self
        relatedVideosCollectionView.isScrollEnabled = false
        scrollView.addSubview(relatedVideosCollectionView)
        
        relatedVideosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedVideosCollectionView.topAnchor.constraint(equalTo: videoDetailsView.bottomAnchor, constant: 16),
            relatedVideosCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            relatedVideosCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            relatedVideosCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            relatedVideosCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            relatedVideosCollectionView.heightAnchor.constraint(equalToConstant: 400)
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

extension VideoDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.5 / 16 * 9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        print("Item Size: \(itemSize), Group Size: \(groupSize)")
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 12
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(relatedVideos.count, 6)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as! VideoCollectionViewCell
        let video = relatedVideos[indexPath.item]
        cell.configureCell(video)
        return cell
    }
}
