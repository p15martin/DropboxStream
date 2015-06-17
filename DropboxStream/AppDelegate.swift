//
//  AppDelegate.swift
//  DropboxStream
//
//  Created by Peter Martin on 6/10/15.
//  Copyright (c) 2015 microsoft. All rights reserved.
//

import UIKit
import SwiftyDropbox

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var dropbox: DropboxAPI!
    
    var window: UIWindow?
    
    //MARK: Initialization

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        initDropbox()
        initRootViewController()
        
        return true
    }
    
    private func initRootViewController() {
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.rootViewController = createRootController()
        self.window!.makeKeyAndVisible()
    }
    
    private func createRootController() -> UIViewController {
        let rootController: UIViewController!
        
        if let client = Dropbox.authorizedClient {
            rootController = StreamViewController()
        } else {
            rootController = LoginViewController()
        }
        
        return rootController
    }

    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject?) -> Bool {
        
        if let authResult = DropboxAuthManager.sharedAuthManager.handleRedirectURL(url) {
            switch authResult {
                case .Success(let token):
                    println("Success! User is logged into Dropbox.")
                    
                    self.dropbox.verifyConnectionAfterAuth()
                    moveToStreamViewController()
                case .Error(let error, let description):
                    println("Error: \(description)")
            }
        }
        
        return false
    }
    
    //MARK: Dropbox
    private func initDropbox() {
        println("Init dropbox")
        
        self.dropbox = DropboxAPI()
        self.dropbox.connect("u26m764zuo8q8uy")
    }
    
    //MARK: Segues
    
    private func moveToStreamViewController() {
        let streamViewController = StreamViewController()
        
        self.window!.rootViewController?.presentViewController(streamViewController, animated: true, completion: nil)
    }
}