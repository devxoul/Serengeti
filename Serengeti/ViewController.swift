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

    override func viewDidLoad() {
        super.viewDidLoad()
        if let URL = NSURL(string: "http://xoul.kr") {
            let request = NSURLRequest(URL: URL)
            self.webView.loadRequest(request)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

