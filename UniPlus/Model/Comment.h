//
//  Comment.h
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Question.h"
#import "Answer.h"
#import "UPObject.h"

@class Question;
@class Answer;
/**
 This class represents the comment that a user posted either under a Question or an Answer. It has all the attributes that the Comments class on Parse server has.
 */
@interface Comment : UPObject

/*!
 @name Properties
 */

/**
 The body of the comment.
 */
@property (strong, nonatomic) NSString *body;
/**
 Which user that the comment is for.
 */
@property (strong, nonatomic) PFUser *toUser;

/*!
 @name Instance Methods
 */

/**
 A designated initializer that init the Comment with a PFObject from Parse.
 
 @param object The Comment in PFObject format.
 
 @return It returns an instance type.
 */
- (id)initWithPFObject:(PFObject *)object;

- (void)deleteComments;

/*!
 @name Factory Methods
 */

+ (void)commentToObject:(UPObject *)object withComment:(PFObject *)comment underQuestion:(Question *)question;

@end
