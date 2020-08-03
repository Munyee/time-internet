//
//  UIImageView+.swift
//  TimeSelfCare
//
//  Created by Chan Mun Yee on 19/05/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import Foundation

extension UIImageView {
    func download(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }

    func download(from link: String) {
        guard let url = URL(string: link) else { return }
        download(from: url)
    }
}
