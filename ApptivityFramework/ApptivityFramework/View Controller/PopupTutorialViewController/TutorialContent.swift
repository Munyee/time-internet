//
//  TutorialContent.swift
//  TutorialContent
//
//  Created by Li Theen Kok on 26/05/2016.
//  Copyright © 2016 Apptivity Lab. All rights reserved.
//

import UIKit

open class TutorialContent: NSObject {

    open var title: String!
    open var body: String?
    open var screenshotImage: UIImage!
    open var popupImage: UIImage?

    open var popupOrigin: CGPoint?
    open var popupTargetPosition: CGPoint?

    public init(title: String, body: String? = nil, screenshotImage: UIImage, popupImage: UIImage? = nil) {
        self.title = title
        self.body = body
        self.screenshotImage = screenshotImage
        self.popupImage = popupImage

        super.init()
    }
}
