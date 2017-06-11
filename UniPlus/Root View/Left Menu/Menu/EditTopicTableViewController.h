//
//  EditTopicTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 22/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchMajorTableViewController.h"

@class EditTopicTableViewController;
/**
 Return the selected topic back to Left Menu
 */
@protocol EditTopicTableViewControllerDelegate <NSObject>

/**
  Pass the selected major back to previous view controller
 
 @param array User selected topics
 */
- (void)passMajorArrayToLeftMenu:(NSMutableArray *)array;

@end

/**
 The EditTopicTableViewController conforms to the SearchMajorTableViewControllerDelegate Protocol.<br/>
 Here user can add or delete their topics, however, user must select at least one topic.
 */
@interface EditTopicTableViewController : UITableViewController<SearchMajorTableViewControllerDelegate>

/*!
 @name Property 
 */

/**
 EditTopicTableViewControllerDelegate
 */
@property (nonatomic, weak) id <EditTopicTableViewControllerDelegate>delegate;
/**
 Topics selected by user
 */
@property (strong, nonatomic) NSMutableArray *editableMajorArray;

@end
