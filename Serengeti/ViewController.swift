//
//  ViewController.swift
//  Serengeti
//
//  Created by 전수열 on 12/25/15.
//  Copyright © 2015 Suyeol Jeon. All rights reserved.
//

import UIKit

let SerengetiHomeURL = "SerengetiHomeURL"

class ViewController: UIViewController {

    @IBOutlet var webView: UIWebView!
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var addressInput: UITextField!
    @IBOutlet var refreshButton: UIBarButtonItem!
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
        self.webView.scrollView.keyboardDismissMode = .OnDrag

        let homeURLString = NSUserDefaults.standardUserDefaults().objectForKey(SerengetiHomeURL) as? String
        let URLString = homeURLString ?? "http://xoul.kr"
        if let URL = NSURL(string: URLString) {
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

    @IBAction func bookmarkButtonDidTap() {
        guard let URLString = self.webView.request?.mainDocumentURL?.absoluteString else {
            return
        }
        let alert = UIAlertController(
            title: "홈으로 설정",
            message: "'\(URLString)' 을 홈으로 설정할까요?",
            preferredStyle: .Alert
        )
        let yes = UIAlertAction(title: "네", style: .Cancel) { _ in
            NSUserDefaults.standardUserDefaults().setObject(URLString, forKey: SerengetiHomeURL)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        let no = UIAlertAction(title: "아니오", style: .Default, handler: nil)
        alert.addAction(yes)
        alert.addAction(no)
        self.presentViewController(alert, animated: true, completion: nil)
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

    func webViewDidStartLoad(webView: UIWebView) {
        if var items = self.toolbar.items {
            items.removeFirst()
            items.insert(self.activityIndicatorItem, atIndex: 0)
            self.toolbar.items = items
        }
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        if var items = self.toolbar.items {
            items.removeFirst()
            items.insert(self.refreshButton, atIndex: 0)
            self.toolbar.items = items
        }
        self.backButton.enabled = webView.canGoBack
        self.forwardButton.enabled = webView.canGoForward
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        if let error = error {
            let alert = UIAlertController(title: "앗!", message: error.localizedDescription, preferredStyle: .Alert)
            let action = UIAlertAction(title: "네", style: .Cancel, handler: nil)
            alert.addAction(action)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        self.webViewDidFinishLoad(webView)
    }

}
