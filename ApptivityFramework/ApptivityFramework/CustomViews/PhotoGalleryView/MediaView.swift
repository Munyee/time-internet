//
//  MediaView.swift
//  ApptivityFramework
//
//  Created by Qi Hao on 01/03/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

@objc
public protocol MediaView {
    var index: Int {get set}
    var reuseIdentifier: String! {get set}
    func prepareForReuse()
}
