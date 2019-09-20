//
//  WalkthroughViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 09/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit

internal class WalkthroughViewController: UIViewController {
    private var images: [UIImage] = [#imageLiteral(resourceName: "bg_walkthrough_1"), #imageLiteral(resourceName: "bg_walkthrough_2"), #imageLiteral(resourceName: "bg_walkthrough_3")]
    private var descriptions: [String] = ["Swipe left and right to navigate.",
                                         "Tap on floating action button to see the menu.",
                                         "Switch account on the sidebar."]
    override var prefersStatusBarHidden: Bool {
        return true
    }

    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var pageControl: UIPageControl!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var doneButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        let screenRatio = max(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height) / min(UIScreen.main.bounds.size.width, UIScreen.main.bounds.size.height)
        if screenRatio > 2 {
            self.images = [#imageLiteral(resourceName: "bg_walkthrough_1_iphoneX"), #imageLiteral(resourceName: "bg_walkthrough_2_iphoneX"), #imageLiteral(resourceName: "bg_walkthrough_3_iphoneX")]
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    @IBAction func dismiss(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        Installation.current().set(true, forKey: hasShownWalkthroughKey)
    }
}

extension WalkthroughViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WalkthroughCell", for: indexPath) as? WalkthroughCell {
            cell.configureCell(with: self.images[indexPath.item])
            return cell
        }
        return UICollectionViewCell()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if let indexPath = self.collectionView.indexPathForVisibleFullScreenItem {
            self.pageControl.currentPage = indexPath.item
            self.doneButton.isHidden = indexPath.item < self.images.count - 1
            self.descriptionLabel.text = self.descriptions[indexPath.item]
        }
    }
}
