//
//  VideoListViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 09/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import SwiftyJSON

class VideoListViewController: UIViewController {

    var videos: [Video] = []
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalVideo: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var selectCategory: UILabel!
    @IBOutlet private weak var categoryControlView: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("HOW TO VIDEOS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        
        totalVideo.text = "\(videos.count) video\(videos.count == 1 ? "" : "s")"
        selectCategory.text = "All categories"
        categoryLabel.text = "All"
        
        
        categoryControlView.layer.masksToBounds = false
        categoryControlView.layer.shadowColor = UIColor.black.cgColor
        categoryControlView.layer.shadowOffset = CGSize(width: 0, height: 0)
        categoryControlView.layer.shadowOpacity = 0.1
        categoryControlView.layer.cornerRadius = 7
        categoryControlView.layer.shadowRadius = 5
        
    }
    
    @objc
    func popBack() {
        tableView.delegate = nil
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func actSelectCategory(_ sender: Any) {
        if var vc = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = vc.presentedViewController {
                vc = presentedViewController
            }
            
            if let videoCategoryVC = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController(withIdentifier: "VideoCategoryViewController") as? VideoCategoryViewController {
                vc.addChild(videoCategoryVC)
                videoCategoryVC.videos = videos
                videoCategoryVC.selectedCategory = selectCategory.text ?? ""
                videoCategoryVC.delegate = self
                videoCategoryVC.view.frame = vc.view.frame
                vc.view.addSubview(videoCategoryVC.view)
                videoCategoryVC.didMove(toParent: vc)
            }
        }
    }
}

extension VideoListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categoryText = categoryLabel.text, !categoryText.contains("All") {
            return videos.filter { ($0.videoCategory?.contains(categoryText) ?? true) }.count
        }
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ytViewCell-table", for: indexPath) as? YTVideoTableViewCell
        var video = videos[indexPath.row]
        
        if let categoryText = categoryLabel.text, !categoryText.contains("All") {
            video = videos.filter { ($0.videoCategory?.contains(categoryText) ?? true) }[indexPath.row]
        }
        
        guard let videoId = video.videoId, let videoTitle = video.videoTitle, let videoDuration = video.videoDuration, let videoCategory = video.videoCategory else {
            return UITableViewCell()
        }
        
        let playerVars = ["controls" : 0, "playsinline" : 0, "autohide" : 1, "autoplay" : 0,
                           "fs" : 1, "rel" : 0, "loop" : 0, "enablejsapi" : 1, "modestbranding" : 0]
        cell?.ytView.webView?.backgroundColor = UIColor(hex: "#111723")
        if cell?.videoId != "" {
            cell?.ytView.cueVideo(byId: videoId, startSeconds: 0)
        } else {
            cell?.videoId = videoId
            cell?.ytView.load(withVideoId: videoId, playerVars: playerVars)
        }
        cell?.ytViewHeight.constant = (view.bounds.width) * 0.563
        cell?.ytView.webView?.allowsLinkPreview = false
        cell?.title.text = videoTitle
        cell?.type.text = videoCategory
        cell?.duration.text = secondsToHoursMinutesSeconds(seconds: Int(videoDuration) ?? 0)
        cell?.ytView.delegate = self
        return cell ?? UITableViewCell()
    }
}

extension VideoListViewController: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            for (index, item) in tableView.subviews.enumerated() {
                if let cell = item as? YTVideoTableViewCell, cell.ytView == playerView {
                    let video = videos[index]
                    cell.ytView.cueVideo(byId: video.videoId ?? "", startSeconds: 0)
                    break
                }
            }
        }
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (String) {
        var time = "\(String(format: "%02d", (seconds % 3_600) / 60)):\(String(format: "%02d", seconds % 60))"
        if ((seconds / 3_600) % 24) > 0 {
            time = "\(String(format: "%02d", (seconds / 3_600) % 24)):\(time)"
        }
        return time
    }
}

extension VideoListViewController: VideoCategoryViewDelegate {
    func categoryDidSelect(type: String) {
        selectCategory.text = type
        categoryLabel.text = type.contains("All") ? "All" : type
        var totalVideos = videos.count
        if let categoryText = categoryLabel.text, !categoryText.contains("All") {
            totalVideos = videos.filter { ($0.videoCategory?.contains(categoryText) ?? true) }.count
        }
        totalVideo.text = "\(totalVideos) video\(totalVideos == 1 ? "" : "s")"
        tableView.reloadData()
    }
}
