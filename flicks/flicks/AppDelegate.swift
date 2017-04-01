//
//  AppDelegate.swift
//  flicks
//
//  Created by Kevin Thrailkill on 3/30/17.
//  Copyright © 2017 kevinthrailkill. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        UITabBar.appearance().tintColor = UIColor(red: 0, green: 0.263, blue: 0.337, alpha: 1.0)
        
        // Set up the first View Controller
        let vc1 = storyboard.instantiateViewController(withIdentifier: "MainNavController") as! UINavigationController
        let nowPlaying = vc1.viewControllers.first as! MovieListViewController
        nowPlaying.movieDBEndpoint = MovieDBEndpoint.nowPlaying
        vc1.tabBarItem.title = "Now Playing"
        vc1.tabBarItem.image = #imageLiteral(resourceName: "mov")
        vc1.tabBarItem.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Gill Sans", size: 10.0)! ], for: .normal)
        
        // Set up the second View Controller
        let vc2 = storyboard.instantiateViewController(withIdentifier: "MainNavController") as! UINavigationController
        let topRated = vc2.viewControllers.first as! MovieListViewController
        topRated.movieDBEndpoint = MovieDBEndpoint.topRated
        vc2.tabBarItem.title = "Top Rated"
        vc2.tabBarItem.image = #imageLiteral(resourceName: "star")
        vc2.tabBarItem.setTitleTextAttributes([ NSFontAttributeName: UIFont(name: "Gill Sans", size: 10.0)! ], for: .normal)

        
        // Set up the Tab Bar Controller to have two tabs
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [vc1, vc2]
        tabBarController.tabBar.barTintColor = UIColor(red: 0, green: 0.741, blue: 0.949, alpha: 1.0)
        tabBarController.tabBar.unselectedItemTintColor = UIColor.darkGray
        
        // Make the Tab Bar Controller the root view controller
        window?.rootViewController = tabBarController
        window?.makeKeyAndVisible()
        
        
        
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


}

