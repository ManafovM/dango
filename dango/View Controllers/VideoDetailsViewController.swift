//
//  VideoDetailsViewController.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/01.
//

import UIKit
import CoreMedia

class VideoDetailsViewController: BaseViewController, UIScrollViewDelegate {
    var videoRequestTask: Task<Void, Never>? = nil
    deinit { videoRequestTask?.cancel() }
    
    let topImageView: VideoDetailsTopImageView
    let scrollView = UIScrollView()
    let videoInfoView: VideoInfoView
    var castCollectionViewController: CastCollectionViewController!
    var castCollectionView: UICollectionView!
    var relatedVideosCollectionView: UICollectionView!
    var relatedVideosHeightConstraint: NSLayoutConstraint!
    
    let video: Video!
    var relatedVideos = [Video]()
    
    init?(coder: NSCoder, video: Video) {
        self.video = video
        self.topImageView = VideoDetailsTopImageView(frame: .zero)
        self.videoInfoView = VideoInfoView(frame: .zero, video: video)
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateEpisode), name: Settings.watchHistoryUpdatedNotification, object: nil)
        
        setupView()
        fetchRelatedVideos()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        if videoInfoView.audioPlayer.rate != 0.0 {
            videoInfoView.audioPlayer.pause()
        }
    }
    
    func setupView() {
        setupTopImageView()
        setupScrollView()
        setupVideoInfoView()
        setupCastCollectionView()
        setupRelatedVideosView()
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
    
    func setupVideoInfoView() {
        videoInfoView.delegate = self
        scrollView.addSubview(videoInfoView)
        videoInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoInfoView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topImageView.frame.height * 0.7),
            videoInfoView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            videoInfoView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            videoInfoView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
        
        videoInfoView.activitiesButtonsView.delegate = self
    }
    
    func setupCastCollectionView() {
        castCollectionViewController = CastCollectionViewController(cast: video.cast)
        castCollectionView = castCollectionViewController.collectionView
        castCollectionView.isScrollEnabled = false
        scrollView.addSubview(castCollectionView)
        
        castCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            castCollectionView.topAnchor.constraint(equalTo: videoInfoView.bottomAnchor),
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
        relatedVideosHeightConstraint = relatedVideosCollectionView.heightAnchor.constraint(equalToConstant: calculateHeightOfRelatedVideosCollectionView())
        NSLayoutConstraint.activate([
            relatedVideosCollectionView.topAnchor.constraint(equalTo: castCollectionView.bottomAnchor, constant: 16),
            relatedVideosCollectionView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            relatedVideosCollectionView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            relatedVideosCollectionView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            relatedVideosCollectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            relatedVideosHeightConstraint
        ])
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yOffset = scrollView.contentOffset.y + (navigationController?.navigationBar.frame.height ?? 56)
        topImageView.updateFrameForOffset(yOffset, parentFrameWidth: view.frame.width)
    }
    
    func calculateHeightOfCastCollectionView() -> CGFloat {
        let cellHeight = 36
        let castCount = video.cast.count
        let spacing = 6
        let headerHeight = 36
        return CGFloat(castCount * cellHeight + (castCount - 1) * spacing + headerHeight)
    }
    
    func calculateHeightOfRelatedVideosCollectionView() -> CGFloat {
        let cellHeight = Int(view.frame.width * 0.5 / 16 * 9)
        let relatedVideosCount = max(1, Int(ceil(Double(relatedVideosCollectionView.numberOfItems(inSection: 0)) / 2)))
        let spacing = 12
        let headerHeight = 36
        return CGFloat(relatedVideosCount * cellHeight + (relatedVideosCount - 1) * spacing + headerHeight)
    }
    
    @objc
    func updateEpisode() {
        videoInfoView.currentEpisodeNum = Settings.shared.watchHistory.first(where: { $0.videoId == video.id })?.currentEpisodeNum ?? 0
        videoInfoView.updatePlayButtonTitle()
        videoInfoView.updateVideoPlayer()
    }
}

extension VideoDetailsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.5 / 16 * 9))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = NSCollectionLayoutSpacing.fixed(12)
        
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
    
    func fetchRelatedVideos() {
        videoRequestTask?.cancel()
        videoRequestTask = Task {
            if let video = try? await VideosByIdsRequest(ids: [video.id]).send() {
                self.relatedVideos = video.first?.relatedVideos ?? []
            }
            self.relatedVideosCollectionView.reloadSections(IndexSet(integer: 0))
            self.relatedVideosHeightConstraint.constant = calculateHeightOfRelatedVideosCollectionView()
            
            videoRequestTask = nil
        }
    }
}

extension VideoDetailsViewController: VideoInfoViewDelegate {
    func playTapped(_ view: VideoInfoView) {
        present(view.playerViewController, animated: true) {
            view.audioPlayer.pause()
            view.videoPlayer.play()
            
            if let watchHistory = Settings.shared.watchHistory.first(where: { $0.videoId == self.video.id }),
               let timestamp = watchHistory.episodesTimestamps[watchHistory.currentEpisodeNum] {
                let seekTime = CMTime(seconds: Double(timestamp), preferredTimescale: 600)
                view.videoPlayer.seek(to: seekTime)
            }
        }
    }
    
    func episodesTapped() {
        let controller = EpisodeCollectionViewController(episodes: video.episodes.sorted(by: <))
        controller.title = video.title

        navigationController?.pushViewController(controller, animated: true)
    }
}

extension VideoDetailsViewController: VideoDetailsButtonsViewDelegate {
    func shareButtonTapped(_ view: VideoDetailsButtonsView) {
        let activityController = UIActivityViewController(activityItems: [self.video.title], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = view.shareButton
        present(activityController, animated: true, completion: nil)
    }
}
