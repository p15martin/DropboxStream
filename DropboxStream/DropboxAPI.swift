//
//  DropboxUsers.swift
//  DropboxStream
//
//  Created by Peter Martin on 6/12/15.
//  Copyright (c) 2015 microsoft. All rights reserved.
//

import SwiftyDropbox
import Foundation

extension CallError {
    var errorCode: Int? {
        switch self {
        case .InternalServerError(let code, let message):
            return code
        case .HTTPError(let code, let message):
            return code
        default:
            return nil
        }
    }
}

public typealias SuccessCompletionHandler = (Users.Account) -> Void
public typealias FailureCompletionHandler = (DropboxError) -> Void

public protocol DropboxError {
    var errorCode: Int? { get }
    var errorMessage: String { get }
    var tokenHasExpired: Bool { get }
}

public class Error: DropboxError, Printable {
    private let code: Int?
    private let message: String
    
    init(error: CallError<Void>) {
        code = error.errorCode
        message = error.description
    }
    
    public var errorCode: Int? {
        return self.code
    }
    
    public var errorMessage: String {
        return self.message
    }
    
    public var tokenHasExpired: Bool {
        return errorCode! == 401
    }
    
    public var description: String {
        return self.message
    }
}

public class DropboxAPI {
    
    public func connect(appKey: String) {
        if DropboxAuthManager.sharedAuthManager == nil {
            Dropbox.setupWithAppKey(appKey)
        }
    }
    
    public func verifyConnectionAfterAuth() {
        if Dropbox.authorizedClient == nil {
            println("Reconnecting the account")
            if let token = DropboxAuthManager.sharedAuthManager.getFirstAccessToken() {
                Dropbox.authorizedClient = DropboxClient(accessToken: token)
                DropboxClient.sharedClient = Dropbox.authorizedClient
            }
        }
    }
    
    public func authorizeFromController(controller: UIViewController) {
        Dropbox.authorizeFromController(controller)
    }
    
    public func getCurrentAccount(success: SuccessCompletionHandler, failure: FailureCompletionHandler) {
        
        if let client = Dropbox.authorizedClient {
            println("Has client")
            
            client.usersGetCurrentAccount().response { response, error in
                if let callError = error {
                    let dropboxError = Error(error: callError)
                    
                    if dropboxError.tokenHasExpired {
                        println("Token has expired")
                        Dropbox.unlinkClient()
                    }
                    
                    failure(dropboxError)
                } else {
                    success(response!)
                }
            }
        }
    }
}