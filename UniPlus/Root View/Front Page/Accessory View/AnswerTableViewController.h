//
//  AnswerTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 15/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class AnswerTableViewController;

@protocol AnswerTableViewControllerDelegate <NSObject>

- (void)answerQuestionWithAnswerObject:(PFObject *)answer notificationTitle:(NSString *)title message:(NSString *)message image:(UIImage *)img withError:(BOOL)err;

@end

@interface AnswerTableViewController : UITableViewController<UITextViewDelegate>

@property (strong, nonatomic) PFObject *question;

@property (strong, nonatomic) PFObject *answerToBeEdited;

@property (nonatomic) BOOL editingAnswer;

@property (weak, nonatomic) id <AnswerTableViewControllerDelegate>delegate;

@end
