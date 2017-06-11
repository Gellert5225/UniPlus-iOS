//
//  QuestionDetailTableViewController.h
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "Question.h"
#import "UPCommentAccessoryView.h"
#import "QuestionDetailTitleCell.h"
#import "FavouriteView.h"
#import "EditView.h"
#import "PostQuestionTableViewController.h"
#import "QuestionDetailViewModel.h"

/**
 Displays the detail of a Question, including question body, author, comments, answers, votes...etc.
 */
@interface QuestionDetailTableViewController : UITableViewController<UPCommentAccessoryViewDelegate,UpVoteViewDelegate, DownVoteViewDelegate>

/*!
 @name Properties
 */

/**
 The QuestionDetailViewModel object.
 */
@property (strong, nonatomic) QuestionDetailViewModel *viewModel;
/**
 The Question in a form of PFObject.
 */
@property (strong, nonatomic) PFObject *questionObject;
/**
 The objectId of the question.
 */
@property (strong, nonatomic) NSString *questionId;
/**
 Whether the view is loading or not.
 */
@property (nonatomic) BOOL isLoading;
/**
 Whether the view is presenting from clicking a user's profile.
 */
@property (nonatomic) BOOL isFromProfile;
/**
 Whether the user is previewing their question.
 */
@property (nonatomic) BOOL preview;

- (id)initWithStyle:(UITableViewStyle)style questionID:(NSString *)ID questionObject:(PFObject *)object setFromProfile:(BOOL)fromProfile setLoading:(BOOL)loading;

@end
