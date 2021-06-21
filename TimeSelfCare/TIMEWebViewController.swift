//
//  TIMECustomWebViewController.swift
//  TimeSelfCare
//
//  Created by Aarief on 15/12/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import WebKit

internal class TIMEWebViewController: UIViewController, WKUIDelegate {
    var url: URL! // swiftlint:disable:this implicitly_unwrapped_optional
    var parameters: [String: Any] = [:]

    private weak var webView: WKWebView! // swiftlint:disable:this implicitly_unwrapped_optional
    private var fileURL: URL? {
        let docDirectory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return docDirectory?.appendingPathComponent("tempInvoices.pdf")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view = webView
        self.webView = webView

        if self.navigationController?.viewControllers.count ?? 1 > 1 {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .plain, target: self, action: #selector(self.navigateBack))
        } else {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.webViewDidClose(_:)))
        }

        self.webView.load(URLRequest(url: url))
    }

    @objc
    func navigateBack() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
    }

    @objc
    func share() {
        guard
            let documentPath = self.fileURL?.path,
            FileManager.default.fileExists(atPath: documentPath),
            let document = NSData(contentsOfFile: documentPath)
        else {
            debugPrint("document was not found")
            return
        }

        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [document], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.modalPresentationStyle = .fullScreen
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension TIMEWebViewController: WKNavigationDelegate {
    func webViewDidClose(_ webView: WKWebView) {
        if self.navigationController?.viewControllers.count ?? 1 > 1 {
            self.navigationController?.popViewController(animated: true)
        }
        self.dismiss(animated: true, completion: nil)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        let fileManager = FileManager.default
        if let fileURL = self.fileURL,
            let webViewUrl = self.webView.url,
            let pdfDoc = try? Data(contentsOf: webViewUrl),
            fileManager.createFile(atPath: fileURL.path, contents: pdfDoc, attributes: nil) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(self.share))
        }
    }
}
