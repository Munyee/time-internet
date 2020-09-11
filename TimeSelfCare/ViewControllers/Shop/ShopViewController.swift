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
        
        if let webViewContainer = webViewContainer {
            // Initialize:
            let webView = WKWebView(frame: webViewContainer.bounds, configuration: WKWebViewConfiguration()) // Create a new web view
            webView.translatesAutoresizingMaskIntoConstraints = false // This needs to be called due to manually adding constraints

            // Add as a subview:
            webViewContainer.addSubview(webView)

            // Add constraints to be the same as webViewContainer
            webViewContainer.addConstraint(NSLayoutConstraint(item: webView, attribute: .leading, relatedBy: .equal, toItem: webViewContainer, attribute: .leading, multiplier: 1.0, constant: 0.0))
            webViewContainer.addConstraint(NSLayoutConstraint(item: webView, attribute: .trailing, relatedBy: .equal, toItem: webViewContainer, attribute: .trailing, multiplier: 1.0, constant: 0.0))
            webViewContainer.addConstraint(NSLayoutConstraint(item: webView, attribute: .top, relatedBy: .equal, toItem: webViewContainer, attribute: .top, multiplier: 1.0, constant: 0.0))
            webViewContainer.addConstraint(NSLayoutConstraint(item: webView, attribute: .bottom, relatedBy: .equal, toItem: webViewContainer, attribute: .bottom, multiplier: 1.0, constant: 0.0))

            // Assign web view for reference
            self.webView = webView
        }
        
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
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Redirect...")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        debugPrint("Start...")
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { // swiftlint:disable:this implicitly_unwrapped_optional
        webView.evaluateJavaScript("document.title") { (string, error) in
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
