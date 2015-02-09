//
//  ViewController.swift
//  Browser
//
//  Created by ZSXJ on 15/2/9.
//  Copyright (c) 2015年 ZSXJ. All rights reserved.
//

import UIKit
import WebKit
class ViewController: UIViewController,UITextFieldDelegate,WKNavigationDelegate {
    @IBOutlet weak var barView:UIView!
    @IBOutlet weak var urlField:UITextField!
    
    @IBOutlet weak var backButton:UIBarButtonItem!
    @IBOutlet weak var forwardButton:UIBarButtonItem!
    @IBOutlet weak var refreshButton:UIBarButtonItem!
    
    @IBOutlet weak var progressView:UIProgressView!
    var webView:WKWebView
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the frame of barView
        barView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: 30)
        
//        view.addSubview(webView)
        view.insertSubview(webView, belowSubview: progressView)
        /**
        add constraints to webview
        */
        webView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let height = NSLayoutConstraint(item: webView, attribute: .Height, relatedBy: .Equal, toItem: view, attribute: .Height, multiplier: 1, constant: -44)
        let width = NSLayoutConstraint(item: webView, attribute: .Width, relatedBy: .Equal, toItem: view, attribute: .Width, multiplier: 1, constant: 0)
        view.addConstraints([height,width])
        /**
        open a default web page
        */
        let url:NSURL = NSURL(string: "http://www.apple.com")!
        let request = NSURLRequest(URL:url)
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
        webView.loadRequest(request)
        backButton.enabled = false
        forwardButton.enabled = false
        /**
        Add the observer to webView
        */
        webView.addObserver(self, forKeyPath: "loading", options: .New, context: nil)
        self.navigationController?.hidesBarsOnSwipe = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRectZero)
        super.init(coder: aDecoder)
        self.webView.navigationDelegate = self
    }
    
    override func  viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        barView.frame = CGRect(x: 0, y: 0, width: size.width, height: 30)
        
    }
    //Observer
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if(keyPath == "loading")
        {
            backButton.enabled = true
            forwardButton.enabled = true
        }
        if(keyPath == "estimatedProgress")
        {
            progressView.hidden = webView.estimatedProgress == 1
            progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
        }
    }

    //UITextFieldDelegate
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = "http://"
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        webView.loadRequest(NSURLRequest(URL: NSURL(string: textField.text)!))
        return false
    }
    //WKNavigationDelegate
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    func webView(webView: WKWebView, didFinishNavigation navigation: WKNavigation!) {
        progressView.setProgress(0.0, animated: false)
    }
    //UIAction func
    @IBAction func back(sender:UIBarButtonItem)
    {
        webView.goBack()
    }
    @IBAction func forward(sender:UIBarButtonItem)
    {
        webView.goForward()
    }
    @IBAction func refresh(sender:UIBarButtonItem)
    {
        let request = NSURLRequest(URL: webView.URL!)
        webView.loadRequest(request)
    }
}

