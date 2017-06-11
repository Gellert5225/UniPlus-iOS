//
//  QuestionDetailViewModel.h
//  UniPlus
//
//  Created by Jiahe Li on 25/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Question.h"

/**
 A view model for QuestionDetailTableViewController.
 
 It can handle the fetch requests, posting comments, mark answers as accepted or not, etc.
 */
@interface QuestionDetailViewModel : NSObject

/*!
 @name Properties
 */

/**
 The Question object that returned by fetchQuestionWithQuestionID:completionBlock: method
 */
@property (strong, nonatomic) Question *question;
/**
 The objectID of the Question.
 */
@property (strong, nonatomic) NSString *questionID;

/*!
 @name Instance Methods
 */

/**
 Fetch the Question object from the server with an objectID provided by Parse
 
 @param questionID the objectID of the question.
 
 @param block handling the completion after fetching.
 */
- (void)fetchQuestionWithQuestionID:(NSString *)questionID completionBlock:(void (^)(BOOL success, NSError *error))block;

/**
 Mark the answer as correct or not correct.
 
 @param answer the Answer object that is being marked.
 
 @param accepted whether or not it is correct.
 */
- (void)acceptAnswer:(Answer *)answer accepted:(BOOL)accepted;

/**
 Post a comment to a Question or Answer.
 
 @param object a generic UPObject representing the post to which the comment belongs.
 
 @param body the comment body.
 
 @param toComment a nullable Comment object that tells the server whether user is replying to another comment.
 */
- (void)commentToObject:(UPObject *)object withCommentBody:(NSString *)body replyToComment:(PFObject *)toComment;

/**
 Increment the number of views.
 */
- (void)incrementNumberOfViews;

@end
