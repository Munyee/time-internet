//
//  ShopViewController.swift
//  TimeSelfCare
//
//  Created by Raviteja Gadige on 10/09/2020.
//  Copyright © 2020 Apptivity Lab. All rights reserved.
//

import UIKit
import WebKit

class ShopViewController: TimeBaseViewController, WKUIDelegate {
    
    @IBOutlet private weak var webView: WKWebView!
    @IBOutlet private weak var activity: UIActivityIndicatorView!
    var parameters: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Shop", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        let path = "open_shop"
        parameters["action"] = path
        parameters["username"] = AccountController.shared.profile?.username
        parameters["account_no"] = AccountController.shared.selectedAccount?.accountNo
        parameters["token"] = APIClient.shared.getToken(forPath: path)
        parameters["bulb"] = "yes"
        parameters["session_id"] = AccountController.shared.sessionId
        
        var request = URLRequest(url: APIClient.BaseAPIURL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        webView.load(request)
        
        // add activity
        self.webView.addSubview(self.activity)
        self.activity.startAnimating()
        self.webView.navigationDelegate = self
        self.activity.hidesWhenStopped = true
    }
}

extension ShopViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Commit...")
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Redirect...")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Start...")
        self.activity.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        self.activity.stopAnimating()
//        webView.evaluateJavaScript("document.body.title") { (string, error) in
//            print("title = \(String(describing: string))")
//        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) { // swiftlint:disable:this implicitly_unwrapped_optional
        self.activity.stopAnimating()
        self.showAlertMessage(with: error)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { // swiftlint:disable:this implicitly_unwrapped_optional
        self.activity.stopAnimating()
        self.showAlertMessage(with: error)
    }

    func webViewDidClose(_ webView: WKWebView) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if navigationAction.request.url!.absoluteString.contains("/user/dashboard/") {
            if navigationAction.request.url!.absoluteString.contains("/welcome/") {
                decisionHandler(.allow)
            } else {
                self.webViewDidClose(webView)
                decisionHandler(.cancel)
            }
        } else {
        decisionHandler(.allow)
        }
    }
}
