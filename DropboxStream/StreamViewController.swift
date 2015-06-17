//
//  StreamViewController.swift
//  DropboxStream
//
//  Created by Peter Martin on 6/11/15.
//  Copyright (c) 2015 microsoft. All rights reserved.
//

import UIKit

public class StreamViewController: UIViewController {
    private var dropbox: DropboxAPI!
    
    //MARK: Initialization

    override public func loadView() {
        super.loadView()
        
        self.dropbox = DropboxAPI()
        
        self.view.backgroundColor = UIColor.yellowColor()
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        fetchUserAccount()
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.setTranslatesAutoresizingMaskIntoConstraints(true)
    }
    
    private func fetchUserAccount() {
        self.dropbox.getCurrentAccount({
            account in
                println(account.name.givenName)
            },
            failure: { error in
                if error.tokenHasExpired {
                    self.dropbox.authorizeFromController(self)
                }
        })
    }
}