//
//  VideoView.swift
//  ApptivityFramework
//
//  Created by Qi Hao on 01/03/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import UIKit
import AVKit

public protocol VideoViewDelegate: class {
    func videoView(_ videoView: VideoView, didBeginPlayingItem: AVPlayerItem)
    func videoView(_ videoView: VideoView, didReceiveTap gestureRecognizer: UIGestureRecognizer)
}

public class VideoView: UIView, MediaView {
    
    public var index: Int = -1
    public var reuseIdentifier: String!
    public weak var delegate: VideoViewDelegate?
    private var singleTapGestureRecognizer: UITapGestureRecognizer!

    public weak var playerViewController: AVPlayerViewController?
    private weak var playButton: UIButton?

    public override required init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }

    private func setup() {
        self.backgroundColor = UIColor.white
        self.setupGestureRecognizer()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.playButton?.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
    }

    public func prepareForReuse() {
        self.stopVideo()
    }

    public func addPlayButton(_ button: UIButton) {
        self.playButton?.removeFromSuperview()
        self.playButton = button
        self.playButton?.center = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        self.playButton?.addTarget(self, action: #selector(self.playVideo), for: UIControlEvents.touchUpInside)
        if let playButton = self.playButton {
            self.addSubview(playButton)
        }
    }

    private func setupGestureRecognizer() {
        self.singleTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.receiveSingleTap(_:)))
        self.addGestureRecognizer(self.singleTapGestureRecognizer)
    }

    @objc
    private func receiveSingleTap(_ sender: Any) {
        guard let isShowingControls = self.playerViewController?.showsPlaybackControls, !isShowingControls else {
            return
        }
        self.delegate?.videoView(self, didReceiveTap: self.singleTapGestureRecognizer)
    }

    @objc
    private func playVideo() {
        guard let player = self.playerViewController?.player, let currentItem = player.currentItem else {
            return
        }
        self.playerViewController?.view.isUserInteractionEnabled = true
        self.playerViewController?.showsPlaybackControls = true
        self.playButton?.isHidden = true
        self.delegate?.videoView(self, didBeginPlayingItem: currentItem)
        player.play()
    }

    private func stopVideo() {
        guard let player = self.playerViewController?.player, player.currentItem != nil else {
            return
        }
        player.pause()
        player.seek(to: kCMTimeZero)
        self.playerViewController?.showsPlaybackControls = false
        self.playerViewController?.view.isUserInteractionEnabled = false
        self.playButton?.isHidden = false
    }
}
