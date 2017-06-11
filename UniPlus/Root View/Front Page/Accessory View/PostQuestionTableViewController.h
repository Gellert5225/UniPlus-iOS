//
//  PostQuestionTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 25/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "QuestionDraft.h"

@class PostQuestionTableViewController;

/**
 It's a delegate used to monitor the status of the question being posted.<br/>
 It will get called in NewestQueryTableViewController, in order to track the status of the post request.
 */
@protocol PostQuestionTableViewControllerDelegate <NSObject>

/**
 The PostQuestionTableViewControllerDelegate method which takes the question object as an argument and post it to Parse.
 
 @param question The question object awaiting to be posted.
 
 @param title The title of the notification.
 
 @param messageBody The body of the message.
 
 @param img The image of the notification.
 
 @param err Whether there is an error or not.
 */
- (void)postQuestionWithQuestionObject:(PFObject *)question notificationTitle:(NSString *)title message:(NSString *)messageBody image:(UIImage *)img error:(BOOL)err;

@end

/**
 User must enter a title, body to be able to preview/post your question. Also, users can save their draft if they want to post later.
 */
@interface PostQuestionTableViewController : UITableViewController<UITextViewDelegate>

/*!
 @name Properties 
 */

/**
 The PostQuestionTableViewControllerDelegate property.
 */
@property (weak, nonatomic) id <PostQuestionTableViewControllerDelegate>delegate;
/**
 The Parse class (Discussions or Questions) that the question's gonna post to.
 */
@property (strong, nonatomic) NSString *parseClass;
/**
 The topic that the question belongs to.
 */
@property (strong, nonatomic) NSString *topic;
/**
 Whether or not the user is editing the question.
 */
@property (nonatomic) BOOL editingQuestion;

/**
 The question to be edited.
 */
@property (strong, nonatomic) PFObject *questionToBeEdited;

@end
