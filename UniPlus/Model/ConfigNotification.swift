//
//  ConfigNotification.swift
//  UniPlus
//
//  Created by Jiahe Li on 04/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

import Foundation
import SwiftMessages
import Parse

/**
 This class is just to use the Swift Struct, since it's not possible to access in an Objective-C class.
 */
class ConfigNotification: NSObject, UIGestureRecognizerDelegate {
     //static var delegate: ConfigNotificationDelegate?
    
    /**
     Configure the notification and recursively resend the post if the action fails.
     
     - parameter viewController: The view controller in which the alert gonna present
    
     - parameter error: Determines the alert type
    
     - parameter title: The alert title
    
     - parameter body: The alert body
     */
    @objc static func configureNotification(inViewController viewController:UIViewController, withError error:Bool, withTitle title:String, withBody body:String) {
        let objectAwaiting = GlobalVariables.getInstance().tempObject
        let view: MessageView
        view = MessageView.viewFromNib(.StatusLine)
        if error {
            view.configureTheme(.error)
        } else {
            view.configureTheme(.success)
        }
        
        view.configureDropShadow()
        view.configureContent(title, body: body)
        view.tapHandler = {_ in
            if !error {
                
            } else {
                //retry
                objectAwaiting?.saveInBackground(block: { (success, parseError) in
                    if success {
                        print("Posted a new quesiton \(String(describing: objectAwaiting))")
                        configureNotification(inViewController: viewController, withError: false, withTitle: "Success!", withBody: "Posted!(Tap to view)")
                        PFUser.current()?.incrementKey("numberOfPosts")
                        PFUser.current()?.saveInBackground()
                    } else {
                        var parseErrorString: String;
                        if parseError!._code == 100 {
                            parseErrorString = "Failed. No internet connection.(Tap to retry)"
                        } else {
                            parseErrorString = "\(String(describing: (parseError! as NSError).userInfo["error"])) (Tap to retry)"
                        }
                        configureNotification(inViewController: viewController, withError: true, withTitle: "Failed", withBody: parseErrorString)
                    }
                })
            }
            SwiftMessages.hide()
        }
    
        var config = SwiftMessages.Config()
        config.presentationContext = .viewController(viewController)
        config.duration = .seconds(seconds: 10)
        
        if error {
            SwiftMessages.show(config, view: view);
        }
    }
}
