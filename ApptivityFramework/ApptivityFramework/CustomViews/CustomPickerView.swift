//
//  CustomPickerView.swift
//  ApptivityFramework
//
//  Created by Loka on 31/10/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

public protocol CustomPickerViewDelegate: class {
    func pickerView(pickerView: CustomPickerView, didConfirmSelectionOfRowWithTitle title: [String])
    func pickerViewDidCancel(pickerView: CustomPickerView)
    func pickerView(pickerView: CustomPickerView, didSelectRowWithTitle title: [String])
}

open class CustomPickerView: UIView {

    fileprivate var dataArray: [[String]] = []
    var identifier: String!
    weak var pickerView: UIPickerView!
    open weak var delegate: CustomPickerViewDelegate?
    public var title: String = ""
    private var customBackgroundColor: UIColor?
    private var buttonTextColor: UIColor?
    fileprivate var textColor: UIColor?

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    public convenience init(dataArray: [String]..., title: String? = nil, backgroundColor: UIColor? = nil, buttonTextColor: UIColor? = nil, textColor: UIColor? = nil) {
        self.init(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 244))

        for data in dataArray {
            self.dataArray.append(data)
        }

        self.customBackgroundColor = backgroundColor
        self.buttonTextColor = buttonTextColor
        self.textColor = textColor
        self.title = title ?? ""
        self.setup()
    }

    // SETUP: Setting up display
    private func setup() {
        // Init picker view
        let pickerView: UIPickerView = UIPickerView(frame: CGRect(x: 0, y: 44, width: self.frame.width, height: self.frame.height - 44))
        pickerView.dataSource = self
        pickerView.delegate = self
        self.pickerView = pickerView

        // Init control bar
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.frame.size.width / 3, height: 44))

        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.cancelButtonTapped(sender:)))
        cancelButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body), NSAttributedStringKey.foregroundColor: buttonTextColor ?? UIColor.black ], for: UIControlState.normal)

        let doneButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.plain, target: self, action: #selector(self.doneButtonTapped(sender:)))
        doneButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: UIFontTextStyle.body), NSAttributedStringKey.foregroundColor: buttonTextColor ?? UIColor.black], for: UIControlState.normal)

        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width / 3, height: self.frame.height))
        label.text = self.title
        label.center = CGPoint(x: self.frame.midX, y: self.frame.height)
        label.textAlignment = NSTextAlignment.center
        let toolbarTitle = UIBarButtonItem(customView: label)

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        toolBar.setItems([cancelButton, flexSpace ,toolbarTitle, flexSpace, doneButton], animated: false)

        if let customBackgroundColor = customBackgroundColor {
            pickerView.backgroundColor = customBackgroundColor
            toolBar.backgroundColor = customBackgroundColor
        }
        toolBar.sizeToFit()
        self.addSubview(toolBar)
        self.addSubview(self.pickerView)
    }

    fileprivate func getSelectedRows() -> [String] {
        var selectedRows: [String] = []

        for (i, array) in self.dataArray.enumerated() {
            let rowIndex: Int = pickerView.selectedRow(inComponent: i)
            if rowIndex >= 0 {
                selectedRows.append(array[rowIndex])
            }
        }
        return selectedRows.isEmpty ? [] : selectedRows
    }

    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool) {
        self.pickerView.selectRow(row, inComponent: component, animated: animated)
    }

    @objc func doneButtonTapped(sender: AnyObject?) {
        self.delegate?.pickerView(pickerView: self, didConfirmSelectionOfRowWithTitle: self.getSelectedRows())
    }

    @objc func cancelButtonTapped(sender: AnyObject?) {
        self.delegate?.pickerViewDidCancel(pickerView: self)
    }
}

extension CustomPickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataArray[component][row]
    }

    public func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attributes: [NSAttributedStringKey: Any] = [:]

        if let textColor = self.textColor {
            attributes[NSAttributedStringKey.foregroundColor] = textColor
        }
        return NSAttributedString(string: self.dataArray[component][row], attributes: attributes)
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataArray[component].count
    }

    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataArray.count
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.delegate?.pickerView(pickerView: self, didSelectRowWithTitle: self.getSelectedRows())
    }
}
