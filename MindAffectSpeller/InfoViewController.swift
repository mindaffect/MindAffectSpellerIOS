/* Copyright (c) 2016-2020 MindAffect.

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE. */


import UIKit
import NoiseTagging
import WebKit

/**
This view controller uses a `WKWebView` to display info about this app and MindAffect.
*/
class InfoViewController: UIViewController, WKNavigationDelegate {

	// Model:
	var url: URL!
	var busyLoadingAboutPage = true
	var trialsWereRunning = false // while the Info is displayed we stop noisetagging trials; using this var we remember whether to turn it back on when we are dismissed
	
	// UI:
	let webView = WKWebView()
	let closeButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
		
		// Set our url based on the current system language. By default we show info in English, but if the language code is "nl", we show it in Dutch:
		self.url = Bundle.main.url(forResource: "htmlInfo_english", withExtension: "html")!
		if let actualLanguageCode = Locale.current.languageCode {
			if actualLanguageCode == "nl" {
				self.url = Bundle.main.url(forResource: "htmlInfo_dutch", withExtension: "html")!
			}
		}
		
		
		// Prepare our `webView`:
		
		// Layout:
		let frameWebView = self.view.bounds
		self.webView.frame = frameWebView
		self.webView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
		self.view.addSubview(self.webView)

		// Load the url:
		self.webView.loadFileURL(self.url, allowingReadAccessTo: self.url)
		
		// Make sure the webView is scrolled to the top:
		let rect = CGRect(x: 0, y: 0, width: self.webView.frame.size.width, height: self.webView.frame.size.height)
		self.webView.scrollView.scrollRectToVisible(rect, animated: false)
		
		// Become the webView's delegate, so we can load requests in an external browser:
		self.webView.navigationDelegate = self
		
		// Add a button to dismiss:
		let edgeLengthCloseButton: CGFloat = 64
		let marginCloseButton: CGFloat = 10
		self.closeButton.frame = CGRect(x: self.view.bounds.width - edgeLengthCloseButton - marginCloseButton, y: marginCloseButton, width: edgeLengthCloseButton, height: edgeLengthCloseButton)
		self.closeButton.autoresizingMask = [.flexibleBottomMargin, .flexibleLeftMargin]
		self.view.addSubview(self.closeButton)
		self.closeButton.setImage(UIImage(named: "Icons_Close help"), for: .normal)
		self.closeButton.addTarget(self, action: #selector(self.close), for: .touchUpInside)
    }
	
	@objc func close() {
		self.dismiss(animated: true, completion: nil)
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		// Turn noise tagging trials off, but remember whether they were on:
		self.trialsWereRunning = NoiseTagging.trialsAreRunning
		NoiseTagging.trialsAreRunning = false
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		
		// Turn noise tagging trials back on if necessary:
		NoiseTagging.trialsAreRunning = self.trialsWereRunning
	}
		
	
	// MARK: - WKNavigationDelegate
	
	func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
		guard let requestedURL = navigationAction.request.url else {
			decisionHandler(.cancel)
			return
		}
		
		if requestedURL == self.url {
			decisionHandler(.allow)
		} else {
			// Otherwise open the url with the default internet browser:
			decisionHandler(.cancel)
			UIApplication.shared.open(requestedURL, options: [:], completionHandler: nil)
		}
	}
	
}
