//
//  AppDelegate.swift
//  SAM Advance
//
//  Created by Fabianus Hendy Evan on 1/4/17.
//  Copyright © 2017 Astra International. All rights reserved.
//

import UIKit
import UserNotifications
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
   
   var window: UIWindow?
   var url = BASE_URL
   var isFromPushToken = false
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      if launchOptions != nil {
         print("notif lagi")
         
         let remoteNotif: NSDictionary? = (launchOptions! as NSDictionary).object(forKey: UIApplicationLaunchOptionsKey.remoteNotification) as? NSDictionary
         
         if remoteNotif != nil {
            print("dari notif")
            
         }
      }
      
      SVProgressHUD.setDefaultMaskType(.black)
      SVProgressHUD.setMinimumDismissTimeInterval(2)
      registerForRemoteNotification()
      return true
   }
   
   func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   }
   
   func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }
   
   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   }
   
   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }
   
   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }
   
   func registerForRemoteNotification() {
      if #available(iOS 10.0, *) {
         let center  = UNUserNotificationCenter.current()
         center.delegate = self
         center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
            if error == nil{
               UIApplication.shared.registerForRemoteNotifications()
            }
         }
      }
      else {
         UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
         UIApplication.shared.registerForRemoteNotifications()
      }
   }
   
   func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
      print("DEVICE TOKEN = \(deviceToken)")
      
      let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
      defaults.set(deviceTokenString, forKey: devicePushTokenKey)
      if defaults.object(forKey: "DeviceTokenKey") != nil {
//         refreshWebView()
      }
      print(deviceTokenString)
   }
   
   func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
      print(error)
   }
   
   @available(iOS 10.0, *)
   func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      print(response.notification.request.content.userInfo)
      let userInfo = response.notification.request.content.userInfo as NSDictionary
      let aps = userInfo["aps"] as! [String: AnyObject]
      print("present \(aps[linkUrlKey])")
      url = "\(aps[linkUrlKey]!)"
      isFromPushToken = true
      refreshWebView()
      completionHandler()
   }
   
   @available(iOS 10.0, *)
   func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
      print(notification.request.content.userInfo)
      let userInfo = notification.request.content.userInfo as NSDictionary
      print("\(userInfo)")
      let aps = userInfo["aps"] as! [String: AnyObject]
      print("present \(aps[linkUrlKey])")
//      isFromPushToken = true
//      url = "https://www.google.com"
//      refreshWebView()
      completionHandler(UNNotificationPresentationOptions.alert)
   }
   
   func application(_ application: UIApplication, didRegister notificationSettings: UIUserNotificationSettings) {
      if notificationSettings.types != UIUserNotificationType() {
      }
   }
   
   func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
      print(userInfo)
      let aps = userInfo["aps"] as! [String: AnyObject]
      
      
      switch application.applicationState {
      case .active:
         //app is currently active, can update badges count here
         print("link foreground \(aps["link"])")
         url = "\(aps[linkUrlKey]!)"
         isFromPushToken = true
         refreshWebView()
         break
      case .inactive:
         //app is transitioning from background to foreground (user taps notification), do what you need when user taps here
         print("link user tap notif \(aps["link"])")
         url = "\(aps[linkUrlKey]!)"
         isFromPushToken = true
         refreshWebView()
         break
      case .background:
         //app is in background, if content-available key of your notification is set to 1, poll to your backend to retrieve data and update your interface here
         isFromPushToken = true
         url = "\(aps[linkUrlKey]!)"
         refreshWebView()
         print("link background \(aps["link"])")
         break
      }
      
      completionHandler(UIBackgroundFetchResult.newData)
   }
   
   func refreshWebView() {
      let controller: UINavigationController = storyBoard.instantiateViewController(withIdentifier: "WebViewScreen") as! UINavigationController
      setRootViewController(viewController: controller)
   }
   
   func testScreen() {
      let controller: UINavigationController = storyBoard.instantiateViewController(withIdentifier: "TestScreen") as! UINavigationController
      setRootViewController(viewController: controller)
   }
   
   func setRootViewController(viewController: UINavigationController) {
      
      UIView.transition(with: window!, duration: 0.25, options: ([.transitionCrossDissolve, .allowAnimatedContent]), animations: { () -> Void in
         
         let oldState = UIView.areAnimationsEnabled
         UIView.setAnimationsEnabled(false)
         self.window?.rootViewController = viewController
         UIView.setAnimationsEnabled(oldState)
         
      }) { (finished: Bool) -> Void in
         
      }
   }
   
}

