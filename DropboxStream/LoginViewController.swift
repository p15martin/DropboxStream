//
//  ViewController.swift
//  DropboxStream
//
//  Created by Peter Martin on 6/10/15.
//  Copyright (c) 2015 microsoft. All rights reserved.
//

import UIKit

public class LoginViewController: UIViewController {
    private var dropbox: DropboxAPI!
    private var loginButton: UIButton!

    //MARK: Initialization
    
    override public func loadView() {
        super.loadView()
        
        dropbox = DropboxAPI()
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        addLoginButton()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        self.view.setTranslatesAutoresizingMaskIntoConstraints(true)
    }
    
    private func addLoginButton() {
        self.loginButton = UIButton()
        self.loginButton.setTranslatesAutoresizingMaskIntoConstraints(false)
        
        let image = UIImage(named: "dropbox")
        self.loginButton.setImage(image, forState: .Normal)
        self.loginButton.addTarget(self, action: "loginButtonPressed:", forControlEvents: .TouchUpInside)
        
        self.view.addSubview(loginButton)
    }
    
    //MARK: Actions
    
    func loginButtonPressed(button: UIButton) {
        self.dropbox.authorizeFromController(self)
    }
    
    //MARK: Constraints
    
    override public func updateViewConstraints() {
        addConstraintsCenterLoginButton()
        
        super.updateViewConstraints()
    }
    
    private func addConstraintsCenterLoginButton() {
        let views = ["loginButton": self.loginButton]
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[loginButton]|", options: nil, metrics: nil, views: views))
        
        self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[loginButton]|", options: nil, metrics: nil, views: views))
    }
}