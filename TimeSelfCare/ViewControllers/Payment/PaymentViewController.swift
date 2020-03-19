//
//  PaymentViewController.swift
//  TimeSelfCare
//
//  Created by Loka on 22/11/2017.
//  Copyright © 2017 Apptivity Lab. All rights reserved.
//

import UIKit
import WebKit

internal class PaymentViewController: TimeBaseViewController, WKUIDelegate {
    var webView: WKWebView! // swiftlint:disable:this implicitly_unwrapped_optional
    var parameters: [String: Any] = [:]
    var transactionSuccessBlock: (() -> Void)?
    var transactionFailedBlock: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view = webView

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("Cancel", comment: ""), style: .plain, target: self, action: #selector(self.webViewDidClose(_:)))
        var request = URLRequest(url: APIClient.BaseAPIURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        webView.load(request)
    }
}

extension PaymentViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Commit... \(webView.url)")
        guard let url = webView.url else {
            return
        }

        if url.absoluteString.contains("payment_success.php") && url.absoluteString.contains("close=true") {
            self.endWithSuccess()
        } else if url.absoluteString.contains("payment_success.php") {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("DONE", comment: ""), style: .plain, target: self, action: #selector(self.endWithSuccess))

        } else if url.absoluteString.contains("payment_failed.php") && url.absoluteString.contains("close=true") {
            self.endWithFailure()
        } else if url.absoluteString.contains("payment_failed.php") {
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: NSLocalizedString("DONE", comment: ""), style: .plain, target: self, action: #selector(self.endWithFailure))
        }
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Redirect...")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Start...")
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { // swiftlint:disable:this implicitly_unwrapped_optional
        self.showAlertMessage(with: error)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { // swiftlint:disable:this implicitly_unwrapped_optional
        self.showAlertMessage(with: error)
    }

    func webViewDidClose(_ webView: WKWebView) {
        self.dismiss(animated: true, completion: nil)
    }

    @objc
    func endWithFailure() {
        if self.transactionFailedBlock != nil {
            self.transactionFailedBlock?()
        } else {
            self.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

    @objc
    func endWithSuccess() {
        if self.transactionSuccessBlock != nil {
            self.transactionSuccessBlock?()
        } else {
            self.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }
}
