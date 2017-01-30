//
//  SplashScreenViewController.swift
//  SAM Advance
//
//  Created by Fabianus Hendy Evan on 1/23/17.
//  Copyright © 2017 Astra International. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
      print("aloo")
      performBlockAfterDelay(delay: 5)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   
   func performBlockAfterDelay(delay: Double) {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
         // Your code with delay
         appDelegate.refreshWebView()
      }
   }
   
   
   /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
   
}
