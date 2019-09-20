//
//  StyleGuide.swift
//  ApptivityFramework
//
//  Created by AppLab on 08/11/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

public class StyleGuide {

    public static let shared: StyleGuide = StyleGuide()

    public var colors: [String: UIColor] = [:]
    public var fonts: [String: UIFont] = [:]

    public let longDateFormatter: DateFormatter
    public let longTimeFormatter: DateFormatter
    public let shortTimeFormatter: DateFormatter

    private init() {
        // Load storyboard
        let styleGuideVC: StyleGuideViewController = UIStoryboard(name: "StyleGuide", bundle: nil).instantiateInitialViewController() as! StyleGuideViewController
        let _ = styleGuideVC.view

        // Read colors
        for label in styleGuideVC.colorLabels {
            // Update into colors map
            let color: UIColor = label.backgroundColor!
            let colorName: String = label.text!
            self.colors[colorName] = color
        }

        // Read fonts
        for label in styleGuideVC.fontLabels {
            // Update into fonts map
            let font: UIFont = UIFont(name: label.font.fontName, size: 12)!
            let fontName: String = label.text!
            self.fonts[fontName] = font
        }

        // Locale formatters
        self.longDateFormatter = DateFormatter()
        self.longDateFormatter.dateStyle = .long
        self.longDateFormatter.timeStyle = .none

        self.longTimeFormatter = DateFormatter()
        self.longTimeFormatter.dateStyle = .none
        self.longTimeFormatter.timeStyle = .long

        self.shortTimeFormatter = DateFormatter()
        self.shortTimeFormatter.dateStyle = .none
        self.shortTimeFormatter.timeStyle = .short
    }
}

public class StyleGuideViewController: UIViewController {

    @IBOutlet public var colorLabels: [UILabel] = []
    @IBOutlet public var fontLabels: [UILabel] = []
}
