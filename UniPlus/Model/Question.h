//
//  Question.h
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//
#import "Comment.h"
#import "Answer.h"
#import "UPObject.h"

/**
 Type of properties that belongs to a question.
 */
typedef NS_ENUM(NSInteger, PropertyType) {
    Views,
    NumberOfComments,
    UpVotes,
    NumberOfFavs
};

/**
 This class represents a Question object that a user posted. It has all the attributes that a Questions class on the Parse server has.
 */
@interface Question : UPObject

/*!
 @name Properties
 */

/**
 The title of the question.
 */
@property (strong, nonatomic) NSString *title;
/**
 The body of the question.
 */
@property (strong, nonatomic) NSString *body;
/**
 Which topic the question belongs to.
 */
@property (strong, nonatomic) NSString *category;
/**
 Number of comments of the question.
 
 @note These comments are the comments under the question, comments under the answers are not included.
 */
@property (strong, nonatomic) NSNumber *numberOfComments;
/**
 Number of users who favourite this question.
 */
@property (strong, nonatomic) NSNumber *numberOfFavs;
/**
 Total views of the question.
 */
@property (strong, nonatomic) NSNumber *views;
/**
 The array of Comment of the question.
 */
@property (strong, nonatomic) NSMutableArray *comments;
/**
 The array of Answer of the question.
 */
@property (strong, nonatomic) NSMutableArray *answers;
/**
 Whether the question is solved or not.
 */
@property (nonatomic) BOOL solved;
/**
 Whether the question is marked by user or not.
 */
@property (nonatomic) BOOL markedByUser;
/**
 The correct answer of this question.
 */
@property (strong, nonatomic) PFObject *correctAnswer;

/*!
 @name Instance Methods
 */

/**
 Increment the value by 1.
 
 @param key The property that needs to increment.
 
 @warning The keys are strictly limited to the followings: views, numberOfFavs, numberOfComments, upVotes. Using any other key will raise an exception.
 */
- (void)incrementPropertyByKey:(PropertyType)key;

/**
 Increment the value by a certain amout.
 
 @param key The property that needs to be incremented.
 
 @param amount The amount that needs to increment.
 
 @warning The keys are strictly limited to the followings: views, numberOfFavs, numberOfComments, upVotes. Using any other key will raise an exception.
 
 */
- (void)incrementPropertyByKey:(PropertyType)key amount:(NSNumber *)amount;

/*!
 @name Factory Methods
 */

/**
 Retrive the entire Question object including comments and answers. This is running in background thread, after the completion block, it goes back to main thread.
 
 The completion handler takes the following arguments:
 
 |Parameters |Description|
 |:----------|:--------------------------------------------------------------------------|
 |success    |Whether we have successfully retrive all the data under the Question object|
 |error      |The error                                                                  |
 |pfQuestion |The question in PFObject format                                            |
 |question   |The Question object after successfully retrived the question.              |
 
 @param objectId The question's ID.
 
 @param block The completion block that handle the action after complete.
 
*/
+ (void)getQuestionObjectWithObjectId:(NSString *)objectId completionBlock:(void (^)(BOOL success, NSError *error, PFObject *pfQuestion, Question *question))block;

@end
