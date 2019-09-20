//
//  PopupTutorialViewController.swift
//  PopupTutorialViewController
//
//  Created by Li Theen Kok on 26/05/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

open class PopupTutorialViewController: UIViewController {

    open var tutorialContent: [TutorialContent] = []
    open var popupTargetSize: CGSize = CGSize(width: 280, height: 280)

    @IBOutlet open weak var collectionView: UICollectionView!
    @IBOutlet open weak var pageControl: UIPageControl!
    @IBOutlet open weak var dismissButton: UIButton!

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.register(TutorialContentCell.self, forCellWithReuseIdentifier: "TutorialContentCell")
        self.collectionView.register(UINib(nibName: "TutorialContentCell", bundle: Bundle(for: PopupTutorialViewController.self)), forCellWithReuseIdentifier: "TutorialContentCell")

        if let flowLayout: UICollectionViewFlowLayout = self.collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = UIScreen.main.bounds.size
        }

        self.pageControl.numberOfPages = self.tutorialContent.count
        self.dismissButton.alpha = 0
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismiss(_ sender: AnyObject) {
        self.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension PopupTutorialViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.tutorialContent.count
    }

    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let content: TutorialContent = self.tutorialContent[indexPath.item]

        let cell: TutorialContentCell = collectionView.dequeueReusableCell(withReuseIdentifier: "TutorialContentCell", for: indexPath) as! TutorialContentCell
        cell.popupTargetSize = self.popupTargetSize
        cell.content = content

        return cell
    }

    open func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        (cell as? TutorialContentCell)?.animatePopup()
    }
}

extension PopupTutorialViewController {

    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page: Int = Int(scrollView.contentOffset.x / self.view.frame.size.width)
        self.pageControl.currentPage = page

        if page == self.tutorialContent.count - 1 {
            UIView.animate(withDuration: 0.3, delay: 0.5, options: UIViewAnimationOptions.beginFromCurrentState, animations: {
                self.dismissButton.alpha = 1
                }, completion: nil)
        } else {
            self.dismissButton.alpha = 0
        }
    }
}
