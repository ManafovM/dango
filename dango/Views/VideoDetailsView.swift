//
//  VideoDetailsView.swift
//  dango
//
//  Created by マナフォフ・マリフ on 2024/12/16.
//

import UIKit
import AVKit

class VideoDetailsView: UIView {
    let video: Video
    
    let stackView = UIStackView()
    
    var audioPlayer: AVPlayer!
    var videoPlayer: AVPlayer!
    var playerViewController: AVPlayerViewController!
    
    init(frame: CGRect, video: Video) {
        self.video = video
        super.init(frame: frame)
        
        setupStackView()
        setupVideoInfo()
        playAudio(audioUrl: video.audioUrl)
        setupVideoPlayer(videoUrl: video.videoUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupStackView() {
        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.distribution = .fill
        stackView.alignment = .fill
        
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
        // MARK: Title label setup
        let titleLabel = UILabel()
        titleLabel.text = video.title
        titleLabel.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        titleLabel.numberOfLines = 0
        stackView.addArrangedSubview(titleLabel)
        
        // MARK: Year label setup
        let yearLabel = UILabel()
        yearLabel.text = "\(video.year)年"
        yearLabel.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        yearLabel.textColor = .secondaryLabel
        stackView.addArrangedSubview(yearLabel)
        
        // MARK: Description label setup
        let descriptionLabel = UILabel()
        descriptionLabel.text = video.description
        descriptionLabel.numberOfLines = 0
        descriptionLabel.font = UIFont.systemFont(ofSize: 18, weight: .light)
        stackView.addArrangedSubview(descriptionLabel)
        
        // MARK: Play button setup
        let playButton = UIButton(type: .system)
        var config = UIButton.Configuration.filled()
        
        var buttonTitle = AttributedString("再生")
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
        stackView.addArrangedSubview(playButton)
        
        // MARK: Episodes button setup
        let episodesButton = UIButton(type: .system)
        let episodes = video.episodes
        if !episodes.isEmpty {
            var config2 = UIButton.Configuration.filled()
            config2.title = "エピゾードを選択(全\(episodes.count)話)"
            config2.image = UIImage(systemName: "rectangle.stack")
            config2.imagePadding = 8.0
            config2.baseForegroundColor = .white
            config2.baseBackgroundColor = Color.background.value
            config2.cornerStyle = .medium
            config2.background.strokeColor = .white
            config2.background.strokeWidth = 1
            episodesButton.configuration = config2
            stackView.addArrangedSubview(episodesButton)
            
            episodesButton.addTarget(self, action: #selector(episodesButtonTapped), for: .touchUpInside)
        }
        
        // MARK: Synopsis label setup
        let divider = createDivider()
        stackView.addArrangedSubview(divider)
        
        let synopsisHeaderLabel = UILabel()
        synopsisHeaderLabel.text = "ストーリー"
        synopsisHeaderLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        stackView.addArrangedSubview(synopsisHeaderLabel)
        
        let synopsis = UILabel()
        synopsis.text = video.synopsis
        synopsis.numberOfLines = 0
        synopsis.font = UIFont.systemFont(ofSize: 16, weight: .light)
        stackView.addArrangedSubview(synopsis)

        let divider2 = createDivider()
        stackView.addArrangedSubview(divider2)
        
        if episodes.isEmpty {
            // MARK: Setup content insets for play button
            playButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playButton.heightAnchor.constraint(equalToConstant: 44),
                playButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                playButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -32)
            ])
        } else {
            // MARK: Setup content insets for play button and episodes button
            playButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                playButton.heightAnchor.constraint(equalToConstant: 44),
                playButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 16),
                episodesButton.heightAnchor.constraint(equalToConstant: 44),
                episodesButton.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 12),
                episodesButton.bottomAnchor.constraint(equalTo: divider.topAnchor, constant: -32)
            ])
        }
        
        // MARK: Play button's on tapped action
        playButton.addTarget(self, action: #selector(playButtonTapped(_:)), for: .touchUpInside)
    }
    
    func createDivider() -> UIView {
        let divider = UIView()
        divider.backgroundColor = .lightGray.withAlphaComponent(0.5)
        divider.heightAnchor.constraint(equalToConstant: 1 / UIScreen.main.scale).isActive = true
        return divider
    }
    
    deinit {
        audioPlayer.pause()
        audioPlayer = nil
        
        videoPlayer.pause()
        videoPlayer = nil
    }
}

extension VideoDetailsView {
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
    
    func setupVideoPlayer(videoUrl: String) {
        let videoUrl = URL(string: videoUrl)!
        videoPlayer = AVPlayer(url: videoUrl)
        
        playerViewController = AVPlayerViewController()
        playerViewController.player = videoPlayer
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle(for: EpisodeCollectionViewController.self))
        let controller = storyboard.instantiateViewController(identifier: "EpisodeCollectionViewController") { coder in
            EpisodeCollectionViewController(coder: coder, episodes: self.video.episodes)
        }
        
        if let viewController = self.getViewController(),
           let navigationController = viewController.navigationController {
            navigationController.pushViewController(controller, animated: true)
        }
    }
}
