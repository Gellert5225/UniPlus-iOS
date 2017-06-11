//
//  UPSearchController.h
//  UniPlus
//
//  Created by Jiahe Li on 07/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPSearchController;
/**
 Tracking the events
 */
@protocol UPSearchControllerDelegate

/**
 User did tap on search bar
 */
- (void) didStartSearching;
/**
 User did start searching
 */
- (void) didTapOnSearchButton;
/**
 User did cancel searching
 */
- (void) didTapOnCancelButton;
/**
 User did enter text
 
 @param searchText The search string
  */
- (void) didChangeSearchText:(NSString *)searchText;
@end

/**
 UniPlus custom search controller
 */
@interface UPSearchController : UISearchController

/*!
 @name Properties
 */

/**
 The UPSearchControllerDelegate
 */
@property (nonatomic, weak) id <UPSearchControllerDelegate> UPDelegate;

@end
