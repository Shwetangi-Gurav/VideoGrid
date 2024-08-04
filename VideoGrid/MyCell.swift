//
//  MyCell.swift
//  VideoGrid
//
//  Created by Shwetangi Gurav on 04/08/24.
//

import UIKit
import AVKit

class MyCell: UICollectionViewCell {
    var videoViews: [AVPlayerViewController] = []
    var imageViews: [UIImageView] = []
    var currentIndex = 0
    var playTimer: Timer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        for _ in 0..<4 {
            let videoView = AVPlayerViewController()
            videoView.view.contentMode = .scaleAspectFill
            videoView.showsPlaybackControls = false
            videoViews.append(videoView)
            contentView.addSubview(videoView.view)
            
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageViews.append(imageView)
            contentView.addSubview(imageView)
        }
        
        layoutViews()
    }
    
    private func layoutViews() {
        let cellWidth = contentView.frame.width / 2
        let cellHeight = contentView.frame.height / 2
        
        for i in 0..<4 {
            let row = i / 2
            let col = i % 2
            let frame = CGRect(x: CGFloat(col) * cellWidth, y: CGFloat(row) * cellHeight, width: cellWidth - 10 , height: cellHeight - 10)
            videoViews[i].view.frame = frame
            imageViews[i].frame = frame
        }
    }
    
    func loadImage(from url: URL?, into imageView: UIImageView) {
        guard let url = url else {
            imageView.image = UIImage(named: "placeholder")
            return
        }
        
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    imageView.image = image
                }
            } else {
                DispatchQueue.main.async {
                    imageView.image = UIImage(named: "placeholder")
                }
            }
        }
    }
    
    func configure(with videos: [Video]) {
        stopPlaying()
        
        for (index, video) in videos.enumerated() {
            let player = AVPlayer(url: URL(string: video.video)!)
            player.automaticallyWaitsToMinimizeStalling = false
            videoViews[index].player = player
            loadImage(from: URL(string: video.thumbnail), into: imageViews[index])
            VideoPreloader.shared.preloadVideo(with: URL(string: video.video)!)
        }
        
        startPlaying()
    }
    
    
    private func startPlaying() {
        playTimer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(playNextVideo), userInfo: nil, repeats: true)
        playNextVideo()
    }
    
    private func stopPlaying() {
        playTimer?.invalidate()
        playTimer = nil
        for videoView in videoViews {
            videoView.player?.pause()
        }
    }
    
    @objc private func playNextVideo() {
        guard videoViews.count > 0 else { return }
        print(currentIndex)
        
        videoViews[currentIndex].player?.pause()
        imageViews[currentIndex].isHidden = false
        
        currentIndex = (currentIndex + 1) % videoViews.count
        
        let player = videoViews[currentIndex].player
        player?.seek(to: .zero)
        imageViews[currentIndex].isHidden = true
        player?.playImmediately(atRate: 2.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        stopPlaying()
        for imageView in imageViews {
            imageView.image = nil
        }
    }
    
    
}
