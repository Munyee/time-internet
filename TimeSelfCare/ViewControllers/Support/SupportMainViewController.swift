//
//  SupportMainViewController.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 06/08/2021.
//  Copyright © 2021 Apptivity Lab. All rights reserved.
//

import UIKit
import SwiftyJSON

class SupportMainViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var snakePage: SnakePageControl!
    @IBOutlet private weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet private weak var yourTicketView: UIView!
    @IBOutlet private weak var ticketDate: UILabel!
    @IBOutlet private weak var ticketSubject: UILabel!
    @IBOutlet private weak var ticketCategory: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusBackground: UIView!
    let flowLayout = CenteredCollectionViewFlowLayout()
    var ticket: Ticket?
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()
    
    var data = JSON(
        [
            ["videoId": "9oeEHZIycjg", "title": "A-Lin《有一種悲傷 A Kind of Sorrow》Official Music Video - 電影『比悲傷更悲傷的故事 More Than Blue 』主題曲", "type":"Connectivity"],
            ["videoId": "ZqRRN7JhFSk", "title": "How to run Self-Diagnostic + TIME App functions (Hub video)", "type":"Live Chat"],
            ["videoId": "BRcudpJzy1I", "title": "A-Lin《有一種悲傷 A Kind of Sorrow》Official Music Video - 電影『比悲傷更悲傷的故事 More Than Blue 』主題曲", "type":"Connectivity"],
            ["videoId": "EbgNITLTji0", "title": "三個麻瓜的新成員登場！", "type":"Connectivity"],
//            ["videoId": "1ghp2v05KiA", "title": "挑戰粉絲指定任務！模仿進擊的巨人和火影忍者跑、挑戰困難自拍到跌倒、在初鹿牧場盲測各牌牛奶...｜麻瓜挑戰", "type":"Connectivity"],
//            ["videoId": "XwTCNn2GGck", "title": "【小孩暗黑真心話！！原來他的心裡是這樣想？！】20161121 綜藝大熱門", "type":"Connectivity"],
//            ["videoId": "wKhYmzuqMJo", "title": "A-Lin《有一種悲傷 A Kind of Sorrow》Official Music Video - 電影『比悲傷更悲傷的故事 More Than Blue 』主題曲", "type":"Connectivity"],
//            ["videoId": "Jxpvq068z3s", "title": "A-Lin《有一種悲傷 A Kind of Sorrow》Official Music Video - 電影『比悲傷更悲傷的故事 More Than Blue 』主題曲", "type":"Connectivity"],
        ])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("SUPPORT", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        self.scrollView.addSubview(refreshControl)
        
        collectionView.collectionViewLayout = flowLayout
        collectionView.decelerationRate = .fast
        flowLayout.itemSize = CGSize(
            width: view.bounds.width - 72,
            height: (view.bounds.width - 72) * 0.563 + 72
          )
        flowLayout.minimumLineSpacing = 20
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionViewHeight.constant = (view.bounds.width - 72) * 0.563 + 72
        snakePage.pageCount = data.arrayValue.count
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.yourTicketView.isHidden = true
        loadTickets()
    }
    
    @objc
    private func refresh() {
        loadTickets()
    }
    
    func loadTickets() {
        self.refreshControl.beginRefreshing()
        
        TicketDataController.shared.loadTickets(account: AccountController.shared.selectedAccount) { (tickets: [Ticket], error: Error?) in
            self.refreshControl.endRefreshing()
            if let error = error {
                self.showAlertMessage(with: error)
                return
            }

            guard let ticket = tickets.sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 }).first else {
                self.yourTicketView.isHidden = true
                return
            }
            self.ticket = ticket
            self.yourTicketView.isHidden = false
            self.ticketDate.text = ticket.datetime
            self.ticketSubject.text = ticket.subject
            self.ticketCategory.text = ticket.category
            self.statusLabel.text = ticket.statusString
            self.statusBackground.isHidden = ticket.statusString?.isEmpty ?? true
            if ["open"].contains(ticket.statusString?.lowercased()) {
                self.statusBackground.backgroundColor = .positive
            } else if ["closed"].contains(ticket.statusString?.lowercased()) {
                self.statusBackground.backgroundColor = .grey2
            } else {
                self.statusBackground.backgroundColor = .primary
            }
        }
    }
    
    @IBAction func viewAllTicket(_ sender: Any) {
        let ticketListVC: TicketListViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(ticketListVC, animated: true)
    }
    
    @IBAction func createTicket(_ sender: Any) {
        let ticketFormVC: TicketFormViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
        self.presentNavigation(ticketFormVC, animated: true)
    }
    
    @IBAction func viewTicket(_ sender: Any) {
        if let ticket = self.ticket {
            let ticketDetailVC: TicketDetailViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
            ticketDetailVC.ticket = ticket
            self.navigationController?.pushViewController(ticketDetailVC, animated: true)
        }
    }
    
    @IBAction func viewAllVideo(_ sender: Any) {
        let videoListVC: VideoListViewController = UIStoryboard(name: TimeSelfCareStoryboard.support.filename, bundle: nil).instantiateViewController()
        videoListVC.videos = data
        self.navigationController?.pushViewController(videoListVC, animated: true)
    }
}

extension SupportMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.arrayValue.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ytViewCell", for: indexPath) as? YTVideoCollectionViewCell
        let dataVal = data[indexPath.row]
        let playerVars = ["controls" : 0, "playsinline" : 0, "autohide" : 1, "autoplay" : 0,
                           "fs" : 1, "rel" : 0, "loop" : 0, "enablejsapi" : 1, "modestbranding" : 0]
        cell?.ytView.webView?.backgroundColor = UIColor(hex: "#111723")
        if cell?.videoId != "" {
            cell?.ytView.cueVideo(byId: dataVal["videoId"].stringValue, startSeconds: 0)
        } else {
            cell?.videoId = dataVal["videoId"].stringValue
            cell?.ytView.load(withVideoId: dataVal["videoId"].stringValue, playerVars: playerVars)
        }
        cell?.ytViewHeight.constant = (view.bounds.width - 72) * 0.563
        cell?.ytView.webView?.allowsLinkPreview = false
        cell?.title.text = dataVal["title"].stringValue
        cell?.type.text = dataVal["type"].stringValue
        cell?.duration.text = secondsToHoursMinutesSeconds(seconds: dataVal["duration"].intValue)
        cell?.ytView.delegate = self
        return cell ?? UICollectionViewCell()
    }
}

extension SupportMainViewController: YTPlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
        playerView.duration { val, error in
            playerView.videoUrl { url, error in
                if let videoId = url?.valueOf("v"), error == nil {
                    for (index, item) in self.data.arrayValue.enumerated() {
                        if item["videoId"].stringValue == videoId {
                            self.data[index]["duration"] = JSON(val)
                            break
                        }
                    }
                }
            }
            
            if let cell = playerView.superview?.superview?.superview as? YTVideoCollectionViewCell, error == nil {
                cell.duration.text = self.secondsToHoursMinutesSeconds(seconds: Int(val))
            }
        }
    }
    
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended {
            for (index, item) in collectionView.subviews.enumerated() {
                if let cell = item as? YTVideoCollectionViewCell, cell.ytView == playerView {
                    let dataVal = data[index]
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

extension SupportMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = (scrollView.contentOffset.x + 36) / (scrollView.bounds.width - 50)
        let progressInPage = scrollView.contentOffset.x + 36 - (page * (scrollView.bounds.width - 50))
        let progress = CGFloat(page) + progressInPage
        snakePage.progress = progress
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
