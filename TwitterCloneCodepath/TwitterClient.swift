//
//  TwitterClient.swift
//  TwitterCloneCodepath
//
//  Created by SGLMR on 30/10/16.
//  Copyright © 2016 Golavs. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((Error) -> ())?

    static let sharedInstance = TwitterClient(baseURL: URL(string: "https://api.twitter.com"), consumerKey: "nVWbApuEFyqeknftweBXLzCbp", consumerSecret: "1I0ou3U64bSWaQ8dD5Ki36bMzBqwFJ09su3Q9OX2v7ut8NLx5c")
    
    func login(success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        self.loginSuccess = success
        self.loginFailure = failure
        
        deauthorize()
        fetchRequestToken(withPath: "/oauth/request_token", method: "GET", callbackURL: URL(string:"twitterCloneCodepath://oauth"), scope: nil, success: { (requestToken: BDBOAuth1Credential?) in
            print("I have a token")
            let url = URL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\((requestToken?.token)!)")!
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
        })
    }
    
    func logout() {
        User.currentUser = nil
        deauthorize()
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: User.userDidLogoutNotification), object: nil)
    }
    
    func handleOpenUrl(url: URL) {
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessToken(withPath: "oauth/access_token", method: "POST", requestToken: requestToken, success: { (accessToken: BDBOAuth1Credential?) in
            
            self.currentAccount(success: { (user: User) in
                User.currentUser = user
                self.loginSuccess?()
            }, failure: { (error: Error) in
                self.loginFailure?(error)
            })
        }, failure: { (error: Error?) in
            self.loginFailure?(error!)
        })
    }
    
    func homeTimeline(success: @escaping  ([Tweet]) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/statuses/home_timeline.json", parameters: nil, progress: nil, success: { (task: URLSessionTask?, response: Any?) in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries: dictionaries)
            
            success(tweets)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func currentAccount(success: @escaping (User) -> (), failure: @escaping (Error) -> ()) {
        get("1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: URLSessionTask?, response: Any?) in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            
            success(user)
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func statusUpdate(status: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let endpoint = "1.1/statuses/update.json"
        let originalStatuts = status
        let escapedStatus = originalStatuts.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let parametersString = "\(endpoint)?status=\(escapedStatus!)"
        
        post(parametersString, parameters: nil, progress: nil, success: { (task: URLSessionTask?, response: Any?) in
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func retweet(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let endpoint = "1.1/statuses/retweet/\(id).json"
        
        post(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionTask?, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            print(tweetDictionary["retweeted"]!)
            success()
        }, failure: { (task: URLSessionDataTask?, error: Error) in
            failure(error)
        })
    }
    
    func favorite(id: String, success: @escaping () -> (), failure: @escaping (Error) -> ()) {
        let endpoint = "1.1/favorites/create.json?id=\(id)"
        
        post(endpoint, parameters: nil, progress: nil, success: { (task: URLSessionTask?, response: Any?) in
            let tweetDictionary = response as! NSDictionary
            print(tweetDictionary["favorited"]!)
            success()
            }, failure: { (task: URLSessionDataTask?, error: Error) in
                failure(error)
        })
    }
}



