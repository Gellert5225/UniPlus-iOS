//
//  UPObject.h
//  UniPlus
//
//  Created by Jiahe Li on 17/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

/**
 Different types of votes a user can give to a Question or Answer.
 */
typedef NS_ENUM(NSInteger, VoteType) {
    UpVote,
    DownVote,
    NewUpVote,
    NewDownVote
};

/**
 This class represents the super class of Answer, Comment and Question classes.
 */
@interface UPObject : NSObject

/*!
 @name Properties
 */
 
/**
 The objectId from Parse server.
 */
@property (strong, nonatomic) NSString *objectId;

/**
 The author of each object.
 */
@property (strong, nonatomic) PFUser *author;

/**
 The current user's vote on the object.
 
 @note This can only have 3 values: upVote, downVote, none.
 */
@property (strong, nonatomic) NSString *currentUserVote;

/**
 The PFObject format of the object
 */
@property (strong, nonatomic) PFObject *pfObject;

/**
 Number of up votes of the object.
 
 @note This is the net value of all votes.
 */
@property (strong, nonatomic) NSNumber *upVotes;

/**
 The creation date of the object.
 */
@property (strong, nonatomic) NSDate *createdAt;

/*!
 @name Factory Methods
 */

+ (void)upVote:(PFObject *)object voteType:(NSString *)type objectType:(NSString *)objType byAmount:(NSNumber *)amount toUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error))block;

+ (void)downVote:(PFObject *)object voteType:(NSString *)vType objectType:(NSString *)objType byAmount:(NSNumber *)amount toUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error))block;

@end
