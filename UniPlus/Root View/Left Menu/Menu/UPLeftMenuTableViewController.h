//
//  UPLeftMenuTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 08/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExpandableTableView.h"
#import "SLExpandableTableView.h"
#import "EditTopicTableViewController.h"

@class UPLeftMenuTableViewController;
/**
 Return the selected topic back to Left Menu
 */
@protocol UPLeftMenuTableViewControllerDelegate <NSObject>

/**
 Pass the selected major back to previous view controller
 
 @param array User selected topics
 */
- (void)didFinishLoginWithMajorArray:(NSMutableArray *)array;

@end

/**
 It is the left view controller of the SWRevealViewController. User can have access to all contents here.
 */
@interface UPLeftMenuTableViewController : UITableViewController<SLExpandableTableViewDatasource, SLExpandableTableViewDelegate, EditTopicTableViewControllerDelegate>

/*! 
 @name Properties
 */

/**
 The academic topics that the user selected
 */
@property (strong, nonatomic) NSMutableArray *menuMajorArray;

@end
