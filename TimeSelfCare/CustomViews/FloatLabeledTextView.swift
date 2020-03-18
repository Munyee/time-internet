//
//  FloatLabeledTextView.swift
//  TimeSelfCare
//
//  Created by Loka on 22/05/2018.
//  Copyright © 2018 Apptivity Lab. All rights reserved.
//

import JVFloatLabeledTextField

class FloatLabeledTextView: JVFloatLabeledTextView {
    var showCursor: Bool = true

    override func caretRect(for position: UITextPosition) -> CGRect {
        let rect = super.caretRect(for: position)

        return showCursor ? rect : CGRect.zero
    }
}
