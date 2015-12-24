//
//  ViewController.swift
//  Serengeti
//
//  Created by 전수열 on 12/25/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var addressInput: UITextField!
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var forwardButton: UIBarButtonItem!

    let activityIndicatorItem: UIBarButtonItem = {
        let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        activityIndicatorView.startAnimating()
        return UIBarButtonItem(customView: activityIndicatorView)
    }()
    var activityIndicatorView: UIActivityIndicatorView? {
        return self.activityIndicatorItem.customView as? UIActivityIndicatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.scrollView.contentInset.bottom = self.toolbar.frame.size.height

        if let URL = NSURL(string: "http://xoul.kr") {
            let request = NSURLRequest(URL: URL)
            self.webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addressInputDidReturn() {
        guard var URLString = self.addressInput.text else {
            return
        }
        self.addressInput.resignFirstResponder()

        if !URLString.hasPrefix("http://") && !URLString.hasPrefix("https://") {
            URLString = "http://" + URLString
        }
        guard let URL = NSURL(string: URLString) else {
            let alert = UIAlertController(title: "앗!", message: "잘못된 형식의 URL입니다.", preferredStyle: .Alert)
            let action = UIAlertAction(title: "죄송", style: .Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        let request = NSURLRequest(URL: URL)
        self.webView.loadRequest(request)
    }

    @IBAction func reloadButtonDidTap() {
        self.webView.reload()
    }

    @IBAction func backButtonDidTap() {
        self.webView.goBack()
    }

    @IBAction func forwardButtonDidTap() {
        self.webView.goForward()
    }

}


// MARK: - UIWebViewDelegate

extension ViewController: UIWebViewDelegate {

    func webView(webView: UIWebView,
                 shouldStartLoadWithRequest request: NSURLRequest,
                 navigationType: UIWebViewNavigationType) -> Bool {
        self.addressInput.text = request.mainDocumentURL?.absoluteString
        return true
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.backButton.enabled = webView.canGoBack
        self.forwardButton.enabled = webView.canGoForward
    }

}
