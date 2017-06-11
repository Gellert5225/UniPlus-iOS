//
//  UPError.h
//  UniPlus
//
//  Created by Jiahe Li on 25/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniPlus-Swift.h"
#import <PopupDialog/PopupDialog-Swift.h>

@class UPError;

/**
 An event handler for displaying the error alert.
 */
@protocol UPErrorDelegate <NSObject>

/**
 This method will be called after user taps the retry button.
 */
- (void)didTapRetryButton;

@end

/**
 This class represents the errors.
 */
@interface UPError : NSObject

/*!
 @name Properties
 */

/**
 The error string
 */
@property (nonatomic, strong) NSString *errorString;
/**
 The UPErrorDelegate
 */
@property (nonatomic, weak) id <UPErrorDelegate>delegate;

/*!
 @name Instance Methods
 */

/**
 A designated initializer.
 
 @param error The error string
 */
- (id)initWithErrorString:(NSString *)error;

/**
 To configure the PopupDialog
 
 @return It returns the PopupDialog instance.
 */
- (PopupDialog *)configurePopupDialog;

@end
