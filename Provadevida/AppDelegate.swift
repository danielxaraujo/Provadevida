//
//  AppDelegate.swift
//  Provadevida
//
//  Created by Daniel Xavier Araújo on 24/10/2017.
//  Copyright © 2017 Daniel Xavier Araújo. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public static var user: String?
    public static var userName: String?
    public static var image: UIImage?
    public static var image64: String?
    public static var video: URL?
    public static var video64: String?

    var window: UIWindow?
    var _isFullScreen:Bool = false

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        NotificationCenter.default.addObserver(
            self,
            selector: "willExitFullScreen:",
            name: NSNotification.Name(rawValue: "MoviePlayerWillExitFullscreenNotification"),
            object: nil)
        
        
        NotificationCenter.default.addObserver(
            self,
            selector: "willEnterFullScreen:",
            name: NSNotification.Name(rawValue: "MoviePlayerWillEnterFullscreenNotification"),
            object: nil)
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

    private func application(_ application: UIApplication, supportedInterfaceOrientationsForWindow window: UIWindow?) -> Int {
        if (_isFullScreen) {
            return Int(UIInterfaceOrientationMask.portrait.rawValue) | Int(UIInterfaceOrientationMask.landscapeLeft.rawValue) | Int(UIInterfaceOrientationMask.landscapeRight.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.portrait.rawValue)
        }
    }
    
    func willExitFullScreen(notification: NSNotification){
        _isFullScreen = false
    }
    
    func willEnterFullScreen(notification: NSNotification){
        _isFullScreen = true
    }

}

