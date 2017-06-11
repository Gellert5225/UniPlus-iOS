//
//  ProfileTableViewModel.h
//  UniPlus
//
//  Created by Jiahe Li on 09/06/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

/**
 A view model for ProfileTableViewController.
 
 It can handle all the fetch requests.
 */
@interface ProfileTableViewModel : NSObject

/*!
 @name Properties
 */

/**
 An array of PFObjects representing the Feeds.
 */
@property (strong, nonatomic) NSMutableArray *activities;

/**
 An array of PFObjects representing questions asked by the user.
 */
@property (strong, nonatomic) NSMutableArray *questions;

/**
 An array of PFObjects representing answers posted by the user.
 */
@property (strong, nonatomic) NSMutableArray *answers;

/*!
 @name Instance Methods
 */

/**
 Fetch the latesest 10 activities from the user.
 
 @note Limit for query is set to 10
 
 @param user The user in the ProfileViewController.
 
 @param block Handle the completion.
 */
- (void)fetchRecentActivitiesForUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error)) block;

/**
 Fetch the latesest 10 questions asked by the user.
 
 @note Limit for query is set to 10
 
 @param user The user in the ProfileViewController.
 
 @param block Handle the completion.
 */
- (void)fetchRecentQuestionsForUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error)) block;

/**
 Fetch the latesest 10 answers posted by user.
 
 @note Limit for query is set to 10
 
 @param user The user in the ProfileViewController.
 
 @param block Handle the completion.
 */
- (void)fetchRecentAnswersForUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error)) block;

@end
