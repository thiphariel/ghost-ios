//
//  LoginViewController.swift
//  Ghost
//
//  Created by Thomas Collot on 22/09/2015.
//  Copyright © 2015 Thomas Collot. All rights reserved.
//

import UIKit
import Alamofire
import SwiftHoedown
import SWXMLHash

class LoginViewController: UIViewController {

    @IBOutlet weak var blogUrl: UITextField!
    @IBOutlet weak var emailAddress: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBAction func login(sender: UIButton) {
        let domain = ""
        let username = ""
        let password = ""
        var key: NSString?
        
        // Get request to retrieve the client_secret token from ghost-admin
        Alamofire.request(.GET, "\(domain)/ghost/api/v0.1/authentication/token", encoding: .JSON).response {
            (request, response, result, error) in
            
            let html = NSString(data: result!, encoding: NSUTF8StringEncoding) as! String
            let htmlLines = html.componentsSeparatedByString("\n")
            
            for line in htmlLines {
                let line = line.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                let tag = SWXMLHash.parse(line)
                
                if (tag["meta"] && tag["meta"].element?.attributes["name"] == "env-clientSecret") {
                    key = tag["meta"].element?.attributes["content"]
                    break;
                }
            }
            
            // Now, if we have the token, let's try to connect
            if (key != nil) {
                let parameters = [
                    "grant_type": "password",
                    "username": username,
                    "password": password,
                    "client_id": "ghost-admin",
                    "client_secret": key!
                ]
                
                Alamofire.request(.POST, "http://devngame.com/ghost/api/v0.1/authentication/token", parameters: parameters,  encoding: .URL).responseJSON {
                    (request, response, result) in
                    
                    print(request?.HTTPMethod)
                    print(request, response, result)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //let markdownString = "# Hello Markdown"
        //let htmlString = Hoedown.renderHTMLForMarkdown(markdownString)
        
    }
}

