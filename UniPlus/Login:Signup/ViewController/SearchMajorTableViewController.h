//
//  SearchMajorTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 21/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPSearchController.h"

@class SearchMajorTableViewController;
/**
 Pass the selected major back to previous view controller.<br/>
 This will be called in the view controller who's gonna diplay the selected results.
 */
@protocol SearchMajorTableViewControllerDelegate <NSObject>

/**
 Pass the selected major back to previous view controller.
 
 @param search The search view controller
 
 @param major Selected major
 */
- (void)addMajor:(SearchMajorTableViewController *)search didFinishPickingMajor:(NSString *)major;

@end

/**
  A list of all majors will be displayed here.
 */
@interface SearchMajorTableViewController : UITableViewController<UISearchBarDelegate, UISearchResultsUpdating, UPSearchControllerDelegate, UISearchControllerDelegate>

/*!
 @name Properties 
 */

/**
 A list of all majors
 */
@property(strong, nonatomic) NSArray *majors;
/**
 SearchMajorTableViewControllerDelegate
 */
@property (nonatomic, weak) id <SearchMajorTableViewControllerDelegate>delegate;

@end
