//
//  SearchInstitutionTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPSearchController.h"

@class SearchInstitutionTableViewController;
/**
 This will be called in the view controller who's gonna diplay the selected results.
 */
@protocol SearchInstitutionTableViewControllerDelegate <NSObject>

/**
 Pass the selected institution back to previous view controller.
 
 @param search The search view controller
 
 @param university The selected institution
 */
- (void)addUniversity:(SearchInstitutionTableViewController *)search didFinishPickingUniversity:(NSString *)university;

@end

/**
 A list of all US Institutions will be displayed here.
 */
@interface SearchInstitutionTableViewController : UITableViewController<UISearchBarDelegate, UISearchResultsUpdating, UPSearchControllerDelegate, UISearchControllerDelegate>

/*! 
 @name Properties
 */

/**
 A full list of all US institutions.
 */
@property(strong, nonatomic) NSMutableArray *universities;
/**
 The SearchInstitutionTableViewControllerDelegate property.
 */
@property (nonatomic, weak) id <SearchInstitutionTableViewControllerDelegate>delegate;

@end
