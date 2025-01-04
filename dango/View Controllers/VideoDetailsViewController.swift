//
//  VideoDetailsViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit

class VideoDetailsViewController: BaseViewController, UIScrollViewDelegate {
    var videoRequestTask: Task<Void, Never>? = nil
    deinit { videoRequestTask?.cancel() }
    
    let topImageView: VideoDetailsTopImageView
    let scrollView = UIScrollView()
    let videoDetailsView: VideoDetailsView
    var castCollectionViewController: CastCollectionViewController!
    var castCollectionView: UICollectionView!
    var relatedVideosCollectionView: UICollectionView!
    
    let video: Video!
    var relatedVideos = [Video]()
    
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        update()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if videoDetailsView.audioPlayer.rate != 0.0 {
            videoDetailsView.audioPlayer.pause()
        }
    }
    
    func setupView() {
        setupBackBarButton()
        setupTopImageView()
        setupScrollView()
        setupVideoDetailsView()
        setupCastCollectionView()
        setupRelatedVideosView()
    }
    
    func setupBackBarButton() {
        let backBarButton = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        backBarButton.tintColor = .white
        navigationItem.backBarButtonItem = backBarButton
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
            videoDetailsView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topImageView.frame.height * 0.7),
            videoDetailsView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            videoDetailsView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            videoDetailsView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    func setupCastCollectionView() {
        let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: CastCollectionViewController.self))
        castCollectionViewController = storyBoard.instantiateViewController(identifier: "CastCollectionViewController") { coder in
            CastCollectionViewController(coder: coder, cast: self.video.cast)
        }
        
        castCollectionView = castCollectionViewController.collectionView
        castCollectionView.isScrollEnabled = false
        scrollView.addSubview(castCollectionView)
        
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            castCollectionView.topAnchor.constraint(equalTo: videoDetailsView.bottomAnchor),
            castCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            castCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            castCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            castCollectionView.heightAnchor.constraint(equalToConstant: calculateHeightOfCastCollectionView())
        ])
    }
    
    func setupRelatedVideosView() {
        relatedVideosCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        relatedVideosCollectionView.backgroundColor = Color.darkBackground.value
        relatedVideosCollectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        relatedVideosCollectionView.register(NamedSectionHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeaderView.identifier)
        relatedVideosCollectionView.delegate = self
        relatedVideosCollectionView.dataSource = self
        relatedVideosCollectionView.isScrollEnabled = false
        scrollView.addSubview(relatedVideosCollectionView)
        
        relatedVideosCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            relatedVideosCollectionView.topAnchor.constraint(equalTo: castCollectionView.bottomAnchor, constant: 16),
            relatedVideosCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            relatedVideosCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            relatedVideosCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            relatedVideosCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            relatedVideosCollectionView.heightAnchor.constraint(equalToConstant: 400)
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + (navigationController?.navigationBar.frame.height ?? 56)
        topImageView.updateFrameForOffset(yOffset, parentFrameWidth: view.frame.width)
    }
    
    func calculateHeightOfCastCollectionView() -> CGFloat {
        let cellHeight = 36
        let castCount = self.video.cast.count
        let spacing = 6
        let headerHeight = 36
        return CGFloat(castCount * cellHeight + (castCount - 1) * spacing + headerHeight)
    }
}

extension VideoDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.92), heightDimension: .fractionalWidth(0.5 / 16 * 9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(36))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 16)
        section.interGroupSpacing = 12
        section.boundarySupplementaryItems = [sectionHeader]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = relatedVideos[indexPath.item]
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: VideoDetailsViewController.self))
        let controller = storyboard.instantiateViewController(identifier: "VideoDetailsViewController") { coder in
            VideoDetailsViewController(coder: coder, video: item)
        }
        
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: NamedSectionHeaderView.identifier, for: indexPath) as! NamedSectionHeaderView
        header.nameLabel.text = "こちらもオススメ"
        return header
    }
    
    func update() {
        videoRequestTask?.cancel()
        videoRequestTask = Task {
            if let video = try? await VideoByIdRequest(id: video.id).send() {
                self.relatedVideos = video[0].relatedVideos ?? []
            }
            self.relatedVideosCollectionView.reloadSections(IndexSet(integer: 0))
            
            videoRequestTask = nil
        }
    }
}
