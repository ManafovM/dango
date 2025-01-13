//
//  VideoInfoView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/16.
//

import UIKit
import AVKit

class VideoInfoView: UIView {
    let video: Video
    let episodes: [Episode]
    
    let stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()
    
    var descriptionLabel = UILabel()
    var playButton = UIButton()
    var episodesButton = UIButton()
    
    var audioPlayer: AVPlayer!
    var videoPlayer: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    init(frame: CGRect, video: Video) {
        self.video = video
        self.episodes = video.episodes
        super.init(frame: frame)
        
        setupStackView()
        setupVideoInfo()
        playAudio(audioUrl: video.audioUrl)
        setupVideoPlayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16)
        ])
    }
    
    func setupVideoInfo() {
        setupTitleLabel()
        setupYearLabel()
        setupDescriptionLabel()
        playButtonSetup()
        episodesButtonSetup()
        myListRatingShareButtonsSetup()
        setupDivider()
        synopsisLabelSetup()
        setupDivider()
    }
    
    func setupTitleLabel() {
        let titleLabel = UILabel()
        titleLabel.text = video.title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.numberOfLines = 0
        stackView.addArrangedSubview(titleLabel)
    }
    
    func setupYearLabel() {
        let yearLabel = UILabel()
        yearLabel.text = "\(video.year)年"
        yearLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        yearLabel.textColor = .secondaryLabel
        stackView.addArrangedSubview(yearLabel)
    }
    
    func setupDescriptionLabel() {
        descriptionLabel.text = video.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        stackView.addArrangedSubview(descriptionLabel)
    }
    
    func playButtonSetup() {
        var config = UIButton.Configuration.filled()
        
        var buttonTitle: AttributedString
        if !episodes.isEmpty {
            buttonTitle = AttributedString("第\(getCurrentEpisodeNum() + 1)話を再生")
        } else {
            buttonTitle = AttributedString("再生")
        }
        buttonTitle.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        
        var buttonSubtitle = AttributedString(" (\(video.duration)分)")
        buttonSubtitle.font = UIFont.systemFont(ofSize: 12, weight: .light)
        
        buttonTitle.append(buttonSubtitle)
        config.attributedTitle = buttonTitle
        config.image = UIImage(systemName: "play.fill")
        config.imagePadding = 8.0
        config.baseForegroundColor = Color.darkBackground.value
        config.baseBackgroundColor = .white
        config.cornerStyle = .medium
        playButton.configuration = config
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
        playButton.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(playButton)
    }
    
    func episodesButtonSetup() {
        if !episodes.isEmpty {
            var config = UIButton.Configuration.filled()
            config.title = "エピゾードを選択(全\(episodes.count)話)"
            config.image = UIImage(systemName: "rectangle.stack")
            config.imagePadding = 8.0
            config.baseForegroundColor = .white
            config.baseBackgroundColor = Color.lightBackground.value
            config.cornerStyle = .medium
            config.background.strokeColor = .white
            config.background.strokeWidth = 1
            episodesButton.configuration = config
            episodesButton.addTarget(self, action: #selector(episodesButtonTapped), for: .touchUpInside)
            episodesButton.translatesAutoresizingMaskIntoConstraints = false
            
            stackView.addArrangedSubview(episodesButton)
            
            // MARK: Setup content insets for play button and episodes button
            NSLayoutConstraint.activate([
                playButton.heightAnchor.constraint(equalToConstant: 44),
                playButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                episodesButton.heightAnchor.constraint(equalToConstant: 44),
                episodesButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 12)
            ])
        } else {
            // MARK: Setup content insets for play button
            NSLayoutConstraint.activate([
                playButton.heightAnchor.constraint(equalToConstant: 44),
                playButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16)
            ])
        }
    }
    
    func myListRatingShareButtonsSetup() {
        let buttonsView = VideoDetailsButtonsView(video: video)
        stackView.addArrangedSubview(buttonsView)
    }
    
    func synopsisLabelSetup() {
        let synopsisHeaderLabel = UILabel()
        synopsisHeaderLabel.text = "ストーリー"
        synopsisHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        stackView.addArrangedSubview(synopsisHeaderLabel)
        
        let synopsis = UILabel()
        synopsis.text = video.synopsis
        synopsis.numberOfLines = 0
        synopsis.font = UIFont.systemFont(ofSize: 16, weight: .light)
        stackView.addArrangedSubview(synopsis)
    }
    
    func setupDivider() {
        let divider = HorizontalDivider()
        stackView.addArrangedSubview(divider)
    }
    
    deinit {
        audioPlayer.pause()
        audioPlayer = nil
        
        videoPlayer.pause()
        videoPlayer = nil
    }
}

extension VideoInfoView {
    func playAudio(audioUrl: String) {
        guard let audioUrl = URL(string: audioUrl) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set audio session: \(error)")
            return
        }
        
        audioPlayer = AVPlayer(url: audioUrl)
        audioPlayer.volume = 0.5
        audioPlayer.play()
    }
    
    func setupVideoPlayer() {
        let videoUrl: URL
        if !episodes.isEmpty {
            videoUrl = URL(string: episodes[getCurrentEpisodeNum()].videoUrl)!
        } else {
            videoUrl = URL(string: video.videoUrl)!
        }
        
        videoPlayer = AVPlayer(url: videoUrl)
        
        playerViewController = AVPlayerViewController()
        playerViewController.player = videoPlayer
    }
    
    func getCurrentEpisodeNum() -> Int {
        if let watchHistory = Settings.shared.watchHistory.first(where: { $0.videoId == video.id }) {
            return watchHistory.currentEpisodeNum
        }
        return 0
    }
    
    @objc func playButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.1) {
            sender.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
            sender.configuration?.baseBackgroundColor = sender.configuration?.baseBackgroundColor?.withAlphaComponent(0.7)
        } completion: { _ in
            if let viewController = self.getViewController() {
                viewController.present(self.playerViewController, animated: true) {
                    guard let windowScene = self.playerViewController.view.window?.windowScene else { return }
                    windowScene.requestGeometryUpdate(.iOS(interfaceOrientations: .landscapeRight))
                    
                    self.audioPlayer.pause()
                    self.videoPlayer.play()
                }
            }
            
            UIView.animate(withDuration: 0.2, delay: 0.05, options: [.curveEaseInOut]) {
                sender.configuration?.baseBackgroundColor = sender.configuration?.baseBackgroundColor?.withAlphaComponent(1.0)
                sender.transform = .identity
            }
        }
    }
    
    @objc func episodesButtonTapped() {
        let controller = EpisodeCollectionViewController(episodes: self.video.episodes.sorted(by: <))
        controller.title = video.title
        
        if let viewController = self.getViewController(),
           let navigationController = viewController.navigationController {
            navigationController.pushViewController(controller, animated: true)
        }
    }
}
