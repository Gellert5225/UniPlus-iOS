//
//  NewestQueryTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 19/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "ParseUI.h"
#import "PostQuestionTableViewController.h"

/**
 It's a subclass of PFQueryTableViewController, main interface of the application, showing all the questions in one category.
 */
@interface NewestQueryTableViewController : PFQueryTableViewController<PostQuestionTableViewControllerDelegate>

/**
 @name Properties
 */

/**
 whether the table view is loading for the first time after initialization.
 */
@property (nonatomic) BOOL isLoadingForTheFirstTime;

/**
 @name Initialization
 */

/**
 Designated initializer for NewestQueryTableViewController.<br/>
 This will set the topic, parse class and sorting order used for querying.
 
 @param style The style of the table view
 
 @param topic The topic of the view controller
 
 @param className The Parse class that the query is querying to

 @param order The sorting order

 @return An instancetype
 */
- (id)initWithStyle:(UITableViewStyle)style
              Topic:(NSString *)topic
         ParseClass:(NSString *)className
       sortingOrder:(NSString *)order;

@end
