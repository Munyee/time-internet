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
    @IBOutlet private weak var noTicketView: UIView!
    @IBOutlet private weak var ticketDate: UILabel!
    @IBOutlet private weak var ticketSubject: UILabel!
    @IBOutlet private weak var ticketCategory: UILabel!
    @IBOutlet private weak var statusLabel: UILabel!
    @IBOutlet private weak var statusBackground: UIView!
    @IBOutlet private weak var viewAllBtn: UIButton!
    @IBOutlet private weak var raiseTicketView: UIView!
    @IBOutlet private weak var supportVideoView: UIView!
    let flowLayout = CenteredCollectionViewFlowLayout()
    var ticket: Ticket?
    var videos: [Video] = []
    var allVideos: [Video] = []
    var isDragging: Bool = false

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("SUPPORT", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissView))
        
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
//        snakePage.pageCount = videos.count
        snakePage.isHidden = true
        
        raiseTicketView.layer.shadowColor = UIColor.lightGray.cgColor
        raiseTicketView.layer.shadowOffset = CGSize(width: 0, height: 0)
        raiseTicketView.layer.shadowOpacity = 0.7
        raiseTicketView.layer.shadowRadius = 5
    }
    
    @objc
    func dismissView() {
        self.scrollView.delegate = nil
        self.collectionView.delegate = nil
        self.dismissVC()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.yourTicketView.isHidden = true
        self.noTicketView.isHidden = true
        self.supportVideoView.isHidden = true
        loadTickets()
        loadVideos()
    }
    
    @objc
    private func refresh() {
        loadTickets()
    }
    
    func loadVideos() {
        SupportDataController.shared.loadSupportVideos { (videoData: [Video], error) in
            if error != nil {
                self.supportVideoView.isHidden = true
                return
            }
            self.supportVideoView.isHidden = false

            self.videos = Array(videoData.prefix(3))
            self.allVideos = videoData
            self.snakePage.pageCount = self.videos.count
            
            if self.videos.count >= 3 {
                self.viewAllBtn.isHidden = false
            }
            
            #if DEBUG
            self.viewAllBtn.isHidden = false
            #endif
            
            self.collectionView.reloadData()
        }
    }
    
    func loadTickets() {
        self.refreshControl.beginRefreshing()
        
        TicketDataController.shared.loadTickets(account: AccountController.shared.selectedAccount) { (tickets: [Ticket], error: Error?) in
            self.refreshControl.endRefreshing()
            if error != nil {
                return
            }

            guard let ticket = tickets.sorted(by: { $0.timestamp ?? 0 > $1.timestamp ?? 0 }).first else {
                self.yourTicketView.isHidden = true
                self.noTicketView.isHidden = false
                return
            }
            self.ticket = ticket
            self.yourTicketView.isHidden = false
            self.noTicketView.isHidden = true
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
        LiveChatDataController.shared.loadStatus { statusResult in
            if let status = statusResult {
                if status == "online" {
                    DispatchQueue.main.async {
                        if let selectedAccount = AccountController.shared.selectedAccount, let service = ServiceDataController.shared.getServices(account: selectedAccount).first {
                            if let restoreID = FreshChatManager.shared.restoreID, let username = selectedAccount.profileUsername {
                                Freshchat.sharedInstance().identifyUser(withExternalID: username, restoreID: restoreID)
                            } else {
                                let user = FreshchatUser.sharedInstance()
                                let profile = selectedAccount.profile
                                user.firstName = profile?.fullname
                                user.email = profile?.email
                                user.phoneNumber = profile?.mobileNo
                                Freshchat.sharedInstance().setUserPropertyforKey("AccountNo", withValue: selectedAccount.accountNo)
                                Freshchat.sharedInstance().setUserPropertyforKey("so_number", withValue: service.serviceId)
                                Freshchat.sharedInstance().setUser(user)
                                if let username = selectedAccount.profileUsername {
                                    Freshchat.sharedInstance().identifyUser(withExternalID: username, restoreID: nil)
                                }
                            }
                            
                            let alert = UIAlertController(title: "Choose Option", message: nil, preferredStyle: .actionSheet)
                            alert.addAction(UIAlertAction(title: "Conversations", style: .default , handler:{ (UIAlertAction) in
                                Freshchat.sharedInstance().showConversations(self)
                            }))
                            alert.addAction(UIAlertAction(title: "FAQ", style: .default , handler:{ (UIAlertAction) in
                                Freshchat.sharedInstance().showFAQs(self)
                            }))
                            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))
                            self.present(alert, animated: true, completion: nil)
                        } else {
                            if let viewController = UIStoryboard(name: "LiveChatUserDetailsViewController", bundle: nil).instantiateViewController(withIdentifier: "LiveChatUserDetailsViewController") as? LiveChatUserDetailsViewController {
                                viewController.modalTransitionStyle = .crossDissolve
                                viewController.modalPresentationStyle = .overFullScreen
                                viewController.previousViewController = self
                                self.present(viewController, animated: true, completion: nil)
                            }
                        }
                    }
                } else {
                    if var vc = UIApplication.shared.keyWindow?.rootViewController {
                        while let presentedViewController = vc.presentedViewController {
                            vc = presentedViewController
                        }
                        
                        if let alertView = UIStoryboard(name: "LiveChatAlert", bundle: nil).instantiateViewController(withIdentifier: "alertView") as? LiveChatPopUpViewController {
                            vc.addChild(alertView)
                            alertView.view.frame = vc.view.frame
                            vc.view.addSubview(alertView.view)
                            alertView.didMove(toParent: vc)
                        }
                    }
                }
            }
        }
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
        videoListVC.videos = allVideos
        self.navigationController?.pushViewController(videoListVC, animated: true)
    }
}

extension SupportMainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? YTVideoCollectionViewCell
        if self.isDragging {
            cell?.ytView.playVideo()
        } else {
            cell?.ytView.playVideo()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ytViewCell", for: indexPath) as? YTVideoCollectionViewCell
        let video = videos[indexPath.row]
        let playerVars = ["controls" : 0, "playsinline" : 0, "autohide" : 1, "autoplay" : 0,
                           "fs" : 1, "rel" : 0, "loop" : 0, "enablejsapi" : 1, "modestbranding" : 0]
        cell?.ytView.webView?.backgroundColor = UIColor(hex: "#111723")
        
        guard let videoId = video.videoId, let videoTitle = video.videoTitle, let videoDuration = video.videoDuration, let videoCategory = video.videoCategory else {
            return UICollectionViewCell()
        }
        if cell?.videoId != "" {
            cell?.ytView.cueVideo(byId: videoId, startSeconds: 0)
        } else {
            cell?.videoId = videoId
            cell?.ytView.load(withVideoId: videoId, playerVars: playerVars)
        }
        cell?.ytView.isUserInteractionEnabled = false
        cell?.ytViewHeight.constant = (view.bounds.width - 72) * 0.563
        cell?.ytView.webView?.allowsLinkPreview = false
        cell?.title.text = videoTitle
        cell?.type.text = videoCategory
        cell?.duration.text = secondsToHoursMinutesSeconds(seconds: Int(videoDuration) ?? 0)
        cell?.ytView.delegate = self
        return cell ?? UICollectionViewCell()
    }
}

extension SupportMainViewController: YTPlayerViewDelegate {
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {
        if state == .ended || state == .paused {
            for (index, item) in collectionView.subviews.enumerated() {
                if let cell = item as? YTVideoCollectionViewCell, cell.ytView == playerView {
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

extension SupportMainViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = (scrollView.contentOffset.x + 36) / (scrollView.bounds.width - 50)
        let progressInPage = scrollView.contentOffset.x + 36 - (page * (scrollView.bounds.width - 50))
        let progress = CGFloat(page) + progressInPage
//        snakePage.progress = progress
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
         self.isDragging = true
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
         if !decelerate {
             self.isDragging = true
         } else {
             self.isDragging = false
         }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         self.isDragging = false
    }
}

extension URL {
    func valueOf(_ queryParamaterName: String) -> String? {
        guard let url = URLComponents(string: self.absoluteString) else { return nil }
        return url.queryItems?.first(where: { $0.name == queryParamaterName })?.value
    }
}
