//
//  Data+Apptivity.swift
//  Apptivity Lab
//
//  Created by Apptivity Lab on 25/10/2016.
//
//

import Foundation

public extension Data {

    public func hexadecimalString() -> String {
        var values: [UInt8] = [UInt8](repeating:0, count: self.count)
        self.copyBytes(to: &values, count: self.count)

        var output: String = ""
        for i in 0 ..< values.count {
            output += String(format: "%02.2hhx", arguments: [values[i]])
        }

        return output
    }
}

// MARK: - QR Code Image
public extension Data {

    public func QRImage(withScale scale: CGFloat) -> UIImage? {
        if let coreImageFilter = CIFilter(name: "CIQRCodeGenerator") {
            coreImageFilter.setValue(self, forKey: "inputMessage")
            return coreImageFilter.outputImage?.UIImage(withScale: scale)
        }

        return nil
    }

    public func barcodeImage(withScale scale: CGFloat, filterName: String = "CICode128BarcodeGenerator") -> UIImage? {
        if let coreImageFilter = CIFilter(name: filterName) {
            coreImageFilter.setValue(self, forKey: "inputMessage")
            return coreImageFilter.outputImage?.UIImage(withScale: scale)
        }
        return nil
    }
}
