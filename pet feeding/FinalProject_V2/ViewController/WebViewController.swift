//
//  WebViewController.swift
//  FinalProject_V2
//
//  Created by Weijie Zheng
//  
//  Description：A Web view controller to show the darksky website
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKNavigationDelegate{
    
    @IBOutlet var wbPage : WKWebView!
    @IBOutlet var activity : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //API address for Mississauga
        let urlAddress = URL(string: "https://darksky.net/forecast/43.5903,-79.6457/si12/en")
        let url = URLRequest(url: urlAddress!)
        //Load website
        wbPage.load(url)
        wbPage.navigationDelegate = self
    }
    // start activity's animation
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        activity.isHidden = false
        activity.startAnimating()
    }
    //end activity's animation
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        activity.isHidden = true
        activity.stopAnimating()
    }
}
