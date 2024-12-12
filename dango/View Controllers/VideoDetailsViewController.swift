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
    let contentView = UIView()
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
        setupTopImageView()
        setupScrollView()
        setupContentView()
        setupVideoInfo()
        
        view.bringSubviewToFront(closeButton)
    }
    
    func setupScrollView() {
        scrollView.frame = view.bounds
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
    
    func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalToConstant: view.frame.height * 2) // TODO: Delete this
        ])
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
    
    func setupVideoInfo() {
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.spacing = 0
            stackView.distribution = .fill
            stackView.alignment = .fill
            
            return stackView
        }()
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = video.title
            label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
            label.setContentHuggingPriority(.required, for: .vertical)
            
            return label
        }()
        
        contentView.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: topImage.frame.height * 0.95),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        ])
        
        stackView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: stackView.topAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: stackView.trailingAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: stackView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: stackView.leadingAnchor)
        ])
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
