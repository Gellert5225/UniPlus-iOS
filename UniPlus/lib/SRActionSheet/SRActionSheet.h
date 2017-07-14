//
//  SRActionSheetView.h
//  SRActionSheetDemo
//
//  Created by 郭伟林 on 16/7/5.
//  Copyright © 2016年 SR. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SRActionSheet;

/**
 Handle the events if the user select the action sheet at a specific index.
 */
@protocol SRActionSheetDelegate <NSObject>

@required
/**
 Delegate's method

 @param actionSheet The SRActionSheet
 
 @param index top is 0 and 0++ to down but cancelBtn's index is -1
 */
- (void)actionSheet:(SRActionSheet *)actionSheet didSelectSheet:(NSInteger)index;

@optional
- (void)actionSheet:(SRActionSheet *)actionSheet willDismissFromSuperView:(UIView *)superView;

@end

/**
 *  block's call
 *
 *  @param index the same to the delegate
 */
typedef void (^ActionSheetDidSelectSheetBlock)(SRActionSheet *actionSheetView, NSInteger index);

/**
 A custom action sheet view
 */
@interface SRActionSheet : UIView

/*!
 @name Properties
 */

/**
 The SRActionSheetDelegate property
 */
@property (nonatomic, weak) id<SRActionSheetDelegate> delegate;

/**
 A block used for handling the selection events
 */
@property (nonatomic, copy) ActionSheetDidSelectSheetBlock selectSheetBlock;

/*!
 @name Factory Methods
 */

/**
 Initialize the SRActionSheet and handle the selection events using selectSheetBlock.
 
 @param title The title of the action sheet
 
 @param cancelButtonTitle The title of the cancel button 
 
 @param destructiveButtonTitle The title of the destructive button
 
 @param otherButtonTitles An array of titles for other buttons
 
 @param selectSheetBlock The selectSheetBlock
 */
+ (void)sr_showActionSheetViewWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSArray  *)otherButtonTitles
                       selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock;

/**
 Initialize the SRActionSheet and handle the selection events using SRActionSheetDelegate.
 
 @param title The title of the action sheet
 
 @param cancelButtonTitle The title of the cancel button
 
 @param destructiveButtonTitle The title of the destructive button
 
 @param otherButtonTitles An array of titles for other buttons
 
 @param delegate The SRActionSheetDelegate
 */
+ (void)sr_showActionSheetViewWithTitle:(NSString *)title
                      cancelButtonTitle:(NSString *)cancelButtonTitle
                 destructiveButtonTitle:(NSString *)destructiveButtonTitle
                      otherButtonTitles:(NSArray  *)otherButtonTitles
                               delegate:(id<SRActionSheetDelegate>)delegate;


/*!
 @name Instance Methods
 */

/**
 Initialize the SRActionSheet and handle the selection events using selectSheetBlock.
 
 @param title The title of the action sheet
 
 @param cancelButtonTitle The title of the cancel button
 
 @param destructiveButtonTitle The title of the destructive button
 
 @param otherButtonTitles An array of titles for other buttons
 
 @param selectSheetBlock The selectSheetBlock
 
 @return An instancetype - SRActionSheet *
 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray  *)otherButtonTitles
             selectSheetBlock:(ActionSheetDidSelectSheetBlock)selectSheetBlock;

/**
 Initialize the SRActionSheet and handle the selection events using SRActionSheetDelegate.
 
 @param title The title of the action sheet
 
 @param cancelButtonTitle The title of the cancel button
 
 @param destructiveButtonTitle The title of the destructive button
 
 @param otherButtonTitles An array of titles for other buttons
 
 @param delegate The SRActionSheetDelegate
 
 @return An instancetype - SRActionSheet *
 */
- (instancetype)initWithTitle:(NSString *)title
            cancelButtonTitle:(NSString *)cancelButtonTitle
       destructiveButtonTitle:(NSString *)destructiveButtonTitle
            otherButtonTitles:(NSArray  *)otherButtonTitles
                     delegate:(id<SRActionSheetDelegate>)delegate;

- (void)show;

@end
