//
//  MainPageViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 19/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarbonKit.h"

/**
 It is a wrapper view controller, in which there are 3 child view controllers, ie. 3 instances of NewestQueryTableViewController
 */
@interface MainPageViewController : UIViewController

/*!
 @name Initialization
 */

/**
 Designated initializer

 @param topic The topic
 
 @param className The Parse class name

 @return MainPageViewController
 */
- (instancetype)initWithTopic:(NSString *)topic ParseClass:(NSString *)className;

@end
