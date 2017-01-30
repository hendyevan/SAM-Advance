//
//  ViewController.swift
//  SAM Advance
//
//  Created by Fabianus Hendy Evan on 1/4/17.
//  Copyright © 2017 Astra International. All rights reserved.
//

import UIKit
import SVProgressHUD

class WebViewController: UIViewController {
   
   @IBOutlet weak var webView: UIWebView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // Do any additional setup after loading the view, typically from a nib.
      let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
      if statusBar.responds(to: #selector(setter: UIView.backgroundColor)) {
         statusBar.backgroundColor = UIColor(red: 211/255, green: 47/255, blue: 46/255, alpha: 1.0)
      }
      
      print("haloo \(appDelegate.url)")
      let urlComponents = NSURLComponents(string: appDelegate.url)!
      
      if !appDelegate.isFromPushToken {
         urlComponents.queryItems = [
            NSURLQueryItem(name: "pushtoken", value: defaults.object(forKey: devicePushTokenKey) as! String?) as URLQueryItem ]
      } else {
         webView.stopLoading()
      }
      
      URLCache.shared.removeAllCachedResponses()
      URLCache.shared.diskCapacity = 0
      URLCache.shared.memoryCapacity = 0
      
      if let cookies = HTTPCookieStorage.shared.cookies {
         for cookie in cookies {
            HTTPCookieStorage.shared.deleteCookie(cookie)
         }
      }
      
      print("olaaa \(urlComponents.url!)")
      let request = URLRequest(url: urlComponents.url!,
                               cachePolicy:NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                               timeoutInterval: 10.0)
      
      webView.loadRequest(request)
      appDelegate.isFromPushToken = false
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}

extension WebViewController: UIWebViewDelegate {
   
   func webViewDidStartLoad(_ webView: UIWebView) {
      print("load")
      UIApplication.shared.isNetworkActivityIndicatorVisible = true
   }
   
//   func webViewDidStartLoad(_ webView: UIWebView) {
//      UIApplication.shared.isNetworkActivityIndicatorVisible = true
//      print("load")
//      SVProgressHUD.show()
//   }
   
   func webViewDidFinishLoad(_ webView: UIWebView) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      print("finish")
      SVProgressHUD.dismiss()
   }
   
   func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
      SVProgressHUD.dismiss()
      print(error)
   }
}
