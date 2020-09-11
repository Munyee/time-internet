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
    
    @IBOutlet private var webViewContainer: UIView?
    var webView: WKWebView! // swiftlint:disable:this implicitly_unwrapped_optional
    var parameters: [String: Any] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("Shop", comment: "")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_back_arrow"), style: .done, target: self, action: #selector(self.dismissVC(_:)))
        
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view = webView

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
    }
}

extension ShopViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        guard let url = webView.url else {
            return }
        debugPrint("Commit... \(url)")
        
        if url.absoluteString.contains("user/dashboard/") {
            self.webViewDidClose(webView)
        }
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Redirect...")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Start...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        webView.evaluateJavaScript("document.body.textContent") { (string, error) in
            print("title = \(String(describing: string))")
        }
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
}
