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

    var videos = JSON()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var totalVideo: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    @IBOutlet private weak var selectCategory: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = NSLocalizedString("HOW TO VIDEOS", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.popBack))
        
        totalVideo.text = "\(videos.arrayValue.count) video\(videos.arrayValue.count == 1 ? "" : "s")"
        selectCategory.text = "All categories"
        categoryLabel.text = "All"
    }
    
    @objc
    func popBack() {
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
            return videos.arrayValue.filter { $0["type"].stringValue.contains(categoryText) }.count
        }
        return videos.arrayValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ytViewCell-table", for: indexPath) as? YTVideoTableViewCell
        var dataVal = videos[indexPath.row]
        if let categoryText = categoryLabel.text, !categoryText.contains("All") {
            dataVal = videos.arrayValue.filter { $0["type"].stringValue.contains(categoryText) }[indexPath.row]
        }
        let playerVars = ["controls" : 0, "playsinline" : 0, "autohide" : 1, "autoplay" : 0,
                           "fs" : 1, "rel" : 0, "loop" : 0, "enablejsapi" : 1, "modestbranding" : 0]
        cell?.ytView.webView?.backgroundColor = UIColor(hex: "#111723")
        if cell?.videoId != "" {
            cell?.ytView.cueVideo(byId: dataVal["videoId"].stringValue, startSeconds: 0)
        } else {
            cell?.videoId = dataVal["videoId"].stringValue
            cell?.ytView.load(withVideoId: dataVal["videoId"].stringValue, playerVars: playerVars)
        }
        cell?.ytViewHeight.constant = (view.bounds.width) * 0.563
        cell?.ytView.webView?.allowsLinkPreview = false
        cell?.title.text = dataVal["title"].stringValue
        cell?.type.text = dataVal["type"].stringValue
        cell?.duration.text = secondsToHoursMinutesSeconds(seconds: dataVal["duration"].intValue)
        cell?.ytView.delegate = self
        return cell ?? UITableViewCell()
    }
}

extension VideoListViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.duration { val, error in
            playerView.videoUrl { url, error in
                if let videoId = url?.valueOf("v"), error == nil {
                    for (index, item) in self.videos.arrayValue.enumerated() {
                        if item["videoId"].stringValue == videoId {
                            self.videos[index]["duration"] = JSON(val)
                            break
                        }
                    }
                }
            }
            
            if let cell = playerView.superview?.superview?.superview as? YTVideoTableViewCell, error == nil {
                cell.duration.text = self.secondsToHoursMinutesSeconds(seconds: Int(val))
            }
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            for (index, item) in tableView.subviews.enumerated() {
                if let cell = item as? YTVideoTableViewCell, cell.ytView == playerView {
                    let dataVal = videos[index]
                    cell.ytView.cueVideo(byId: dataVal["videoId"].stringValue, startSeconds: 0)
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
        var totalVideos = videos.arrayValue.count
        if let categoryText = categoryLabel.text, !categoryText.contains("All") {
            totalVideos = videos.arrayValue.filter { $0["type"].stringValue.contains(categoryText) }.count
        }
        totalVideo.text = "\(totalVideos) video\(totalVideos == 1 ? "" : "s")"
        tableView.reloadData()
    }
}
