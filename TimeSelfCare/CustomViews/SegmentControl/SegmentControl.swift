//
//  SegmentControl.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 16/06/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit

protocol SegmentControlDelegate: class {
    func changeToIndex(index: Int)
}

class SegmentControl: UIView {

    private var buttonTitles: [String]!
    private var buttons: [UIButton]!
    private var selectorView: UIView!
    weak var delegate: SegmentControlDelegate?
    private var currentIndex: Int!

    var textColor: UIColor = .lightGray
    var selectorViewColor: UIColor = .primary
    var selectorTextColor: UIColor = .primary

    convenience init(frame: CGRect, buttonTitle: [String]) {
        self.init(frame: frame)
        currentIndex = 0
        self.buttonTitles = buttonTitle
    }

    override func draw(_ rect: CGRect) {
        super.draw(rect)
        updateView()
        let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(currentIndex)
        self.selectorView.frame.origin.x = selectorPosition
    }

    private func configStackView() {
        let stack = UIStackView(arrangedSubviews: buttons)
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 10
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }

    private func configSelectorView() {
        let selectorWidth = frame.width / CGFloat(self.buttonTitles.count)
        selectorView = UIView(frame: CGRect(x: 0, y: self.frame.height, width: selectorWidth, height: 2))
        selectorView.backgroundColor = selectorViewColor
        addSubview(selectorView)
    }

    private func createButton() {
        buttons = [UIButton]()
        buttons.removeAll()
        subviews.forEach { $0.removeFromSuperview() }
        for buttonTitle in buttonTitles {
            let button = UIButton(type: .system)
            button.setTitle(buttonTitle, for: .normal)
            button.addTarget(self, action: #selector(SegmentControl.buttonAction(sender:)), for: .touchUpInside)
            button.setTitleColor(textColor, for: .normal)
            button.titleLabel?.lineBreakMode = .byWordWrapping
            button.titleLabel?.textAlignment = .center
            button.titleLabel?.font = UIFont(name: "Din-Bold", size: 15)

            buttons.append(button)
        }
        buttons[0].setTitleColor(selectorTextColor, for: .normal)
    }

    @objc
    func buttonAction(sender: UIButton) {
        for (buttonIndex, btn) in buttons.enumerated() {
            btn.setTitleColor(textColor, for: .normal)
            if btn == sender {
                let selectorPosition = frame.width / CGFloat(buttonTitles.count) * CGFloat(buttonIndex)
                currentIndex = buttonIndex
                delegate?.changeToIndex(index: buttonIndex)
                UIView.animate(withDuration: 0.3) {
                    self.selectorView.frame.origin.x = selectorPosition
                }
                btn.setTitleColor(selectorTextColor, for: .normal)
            }
        }
    }

    private func updateView () {
        createButton()
        configSelectorView()
        configStackView()
    }

    func setButtonTitles(buttonTitles: [String]) {
        self.buttonTitles = buttonTitles
        updateView()
    }
}
