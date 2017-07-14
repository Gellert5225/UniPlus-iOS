//
//  Answer.h
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UPObject.h"
#import "Comment.h"

/**
 This class represents the answer that a user posted under a Question. It has all the attributes that the Answers class on Parse server has.
 */
@interface Answer : UPObject

/*!
 @name Properties
 */

/**
 The body of the Answer.
 */
@property (strong, nonatomic) NSString *body;
/**
 All the Comment under this Answer.
 */
@property (strong, nonatomic) NSMutableArray *comments;

- (void)deleteAnswer;
/*!
 @name Factory Methods
 */

/**
 Retrive the Answer object from Parse server, including all the comments under this Answer.
 
 The completion handler takes the following arguments:
 
 |Parameters |Description|
 |:----------|:--------------------------------------------------------------------------|
 |success    |Whether we have successfully retrive all the data under the Answer object  |
 |err        |The error                                                                  |
 |answer     |The retieved Answer                                                        |
 
 @param object The Answer object in PFObject format.

 @param block The completion block that handles the action after retrieving the Answer.
 
 */
+ (void)getAnswerFromPFObject:(PFObject *)object completionBlock:(void (^)(BOOL success, NSError *err, __weak Answer *answer))block;

@end
