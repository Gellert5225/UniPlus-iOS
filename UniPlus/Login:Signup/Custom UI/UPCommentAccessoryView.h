//
//  UPCommentAccessoryView.h
//  UniPlus
//
//  Created by Jiahe Li on 14/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UPCommentAccessoryView;
/**
 Tracking the typing events
 */
@protocol UPCommentAccessoryViewDelegate <NSObject>

/**
 Asks the delegate whether the specified text should be replaced in the text view.
 
 The text view calls this method whenever the user types a new character or deletes an existing character. Implementation of this method is optional. You can use this
 method to replace text before it is committed to the text view storage. For example, a spell checker might use this method to replace a misspelled word with the 
 correct spelling.
 
 @param should Whether the specified text should be replaced in the text view.
 
 @param text The text to insert.
 */
- (void)userShouldChangeText:(BOOL)should withText:(NSString *)text;

/**
 An event listener to the tap gesture recognizer, discard the UPCommentAccessoryView.
 */
- (void)userDidTapDiscardView;

@optional

/**
 User did enter some text.
 */
- (void)userDidEnterText;

@end

/**
 This is a custom keyboard accessory view.
 */
@interface UPCommentAccessoryView : UIView <UITextViewDelegate,UIGestureRecognizerDelegate>

/*!
 @name Properties
 */

/**
 The UPCommentAccessoryViewDelegate.
 */
@property (nonatomic, weak) id <UPCommentAccessoryViewDelegate> delegate;
/**
 The comment text view.
 */
@property (weak, nonatomic) IBOutlet UITextView *commentView;
/**
 The label which shows the character limit.
 */
@property (weak, nonatomic) IBOutlet UILabel *charLimitLabel;
/**
 The label which shows whom to reply.
 */
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
/**
 The background of the UPCommentAccessoryView.
 */
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
/**
 The discard view when user swipes left.
 */
@property (weak, nonatomic) IBOutlet UIView *discardView;
/**
 The front view of the UPCommentAccessoryView. This is where we add the pan gesture recognizer.
 */
@property (weak, nonatomic) IBOutlet UIView *frontView;
/**
 The trailing constraint of the front view.
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontViewTrailingConstraint;
/**
 The leading constraint of the front view.
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *frontViewLeadingConstraint;

/*!
 @name Instance Methods
 */

/**
 A designated initializer that initializes the view from interface biulder.
 
 @param nib The nib name of the xib.
 
 @return An instance type.
 */
- (id)initWithNibName:(NSString *)nib;

@end
