//
//  SummaryViewController.swift
//  TimeSelfCare
//
//  Created by Aarief on 02/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import SystemConfiguration
import Smartlook

internal class BaseViewController: TimeBaseViewController {
    func updateDataSet(items: [Service]?) {}
    func updateUI() {}
}
internal protocol SummaryPageViewControllerDelegate: class {
    func didUpdatePage(with index: Int)
}

internal class SummaryPageViewController: UIPageViewController {
    private var services: [Service] = []
    private var orderedViewControllers: [UIViewController] = []
    private var pendingIndex: Int?

    // swiftlint:disable implicitly_unwrapped_optional
    private var accountSummaryVC: AccountSummaryViewController!
    private var addonVC: AddOnViewController!
    private var voiceVC: VoiceSummaryViewController!
    private var performanceVC: PerformanceViewController!
    // swiftlint:enable implicitly_unwrapped_optional

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString("Pull to refresh", comment: ""))
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        return refreshControl
    }()

    weak var vcDelegate: SummaryPageViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Smartlook.setUserIdentifier(AccountController.shared.profile?.username)
        
        self.dataSource = self
        self.delegate = self
        let storyboard = UIStoryboard(name: "Summary", bundle: nil)

        let accountSummaryVC: AccountSummaryViewController = storyboard.instantiateViewController()
        let addonVC: AddOnViewController = storyboard.instantiateViewController()
        let voiceVC: VoiceSummaryViewController = storyboard.instantiateViewController()
        let performanceVC: PerformanceViewController = UIStoryboard(name: TimeSelfCareStoryboard.performance.filename, bundle: nil).instantiateViewController()

        self.accountSummaryVC = accountSummaryVC
        self.addonVC = addonVC
        self.voiceVC = voiceVC
        self.performanceVC = performanceVC

        self.updatePageViewController()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleAccountChange), name: NSNotification.Name.SelectedAccountDidChange, object: nil)
    }

    @objc
    private func handleAccountChange() {
        self.refresh()

        self.updatePageViewController()
        self.setViewControllers([orderedViewControllers.first!], direction: .forward, animated: true, completion: nil) // swiftlint:disable:this force_unwrapping
        self.vcDelegate?.didUpdatePage(with: 0)
    }
    
    @objc
    private func handleControlHub() {
        self.setViewControllers([orderedViewControllers.last!], direction: .forward, animated: true, completion: nil) // swiftlint:disable:this force_unwrapping
        self.vcDelegate?.didUpdatePage(with: orderedViewControllers.count - 1)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.updateDataSet(items: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.handleControlHub), name: NSNotification.Name.ReceiveControlHubNotification, object: nil)
        self.refresh()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    private func updatePageViewController() {
        self.orderedViewControllers = [accountSummaryVC, addonVC]

        let account = AccountController.shared.selectedAccount! // swiftlint:disable:this force_unwrapping

        let shouldShowVoiceScreen: Bool = ServiceDataController.shared.getServices(account: account).first { $0.category == .voice } != nil

        if shouldShowVoiceScreen {
            self.orderedViewControllers.append(voiceVC)
        }

        self.orderedViewControllers.append(performanceVC)

        self.setViewControllers([orderedViewControllers.first!], direction: .forward, animated: true, completion: nil)  // swiftlint:disable:this force_unwrapping
    }

    func updateDataSet(items: [Service]?) {
        self.services = items ?? ServiceDataController.shared.getServices(account: AccountController.shared.selectedAccount)
        self.updateUI()
    }

    func updateUI() {}

    @objc
    public func refresh() {
        guard let accountNo = AccountController.shared.selectedAccount?.accountNo else {
            return
        }

        ServiceDataController.shared.loadServices(accountNo: accountNo) { (services: [Service], error: Error?) in
            self.refreshControl.endRefreshing()
            guard error == nil else {
                self.showAlertMessage(with: error)
                return
            }
            self.updateDataSet(items: services)
            self.orderedViewControllers.forEach { viewController in
                if let vc = viewController as? BaseViewController {
                    vc.updateDataSet(items: nil)
                }
            }
        }
    }
}

extension SummaryPageViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let previousIndex = (index - 1) < 0 ? self.orderedViewControllers.count - 1 : (index - 1)
        return self.orderedViewControllers[previousIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = orderedViewControllers.index(of: viewController) else {
            return nil
        }
        let nextIndex = (index + 1) % self.orderedViewControllers.count
        return self.orderedViewControllers[nextIndex]
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        DispatchQueue.main.async {
            guard let viewController = pendingViewControllers.first,
                  let index = self.orderedViewControllers.index(of: viewController) else {
                    return
            }
            self.pendingIndex = index
        }
    }

    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let index = self.pendingIndex {
            self.vcDelegate?.didUpdatePage(with: index)
        }
    }
}

@IBDesignable
internal class RingView: UIView {
    private var adjustmentAngle: CGFloat = 0.5

    var percentageFilled: CGFloat = 0

    override func draw(_ rect: CGRect) {
        drawRingFittingInsideView()
        addFillLayer()
    }

    func drawRingFittingInsideView() {
        let baseLayer = self.getCircleLayer(color: UIColor.grey2, endAngle: CGFloat.pi * (2 - adjustmentAngle))
        layer.addSublayer(baseLayer)
    }

    func getCircleLayer(color: UIColor, endAngle: CGFloat) -> CAShapeLayer {
        let halfSize: CGFloat = min( bounds.size.width / 2, bounds.size.height / 2)
        let desiredLineWidth: CGFloat = 8

        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: halfSize, y: halfSize),
            radius: CGFloat( halfSize - (desiredLineWidth / 2) ),
            startAngle: -CGFloat.pi / 2,
            endAngle: endAngle,
            clockwise: true)

        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath

        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = desiredLineWidth
        return shapeLayer
    }

    func addFillLayer() {
        let topLayer = self.getCircleLayer(color: .primary, endAngle: (percentageFilled * 2 - adjustmentAngle) * CGFloat.pi)
        self.layer.insertSublayer(topLayer, at: UInt32(self.layer.sublayers?.count ?? 0))
    }
}
