//
//  ProfileTableViewModel.m
//  UniPlus
//
//  Created by Jiahe Li on 09/06/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "ProfileTableViewModel.h"

@implementation ProfileTableViewModel
@synthesize activities = _activities, questions = _questions, answers = _answers;

#pragma - mark Accessors

- (void)setActivities:(NSMutableArray *)activities {
    _activities = activities;
}

- (NSMutableArray *)activities {
    if (!_activities) {
        _activities = [[NSMutableArray alloc]init];
    }
    return _activities;
}

- (void)setQuestions:(NSMutableArray *)questions {
    _questions = questions;
}

- (NSMutableArray *)questions {
    if (!_questions) {
        _questions = [[NSMutableArray alloc]init];
    }
    return _questions;
}

- (void)setAnswers:(NSMutableArray *)answers {
    _answers = answers;
}

- (NSMutableArray *)answers {
    if (!_answers) {
        _answers = [[NSMutableArray alloc]init];
    }
    return _answers;
}

- (void)fetchRecentActivitiesForUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error)) block {
    PFRelation *feedsRelation = [user relationForKey:@"feeds"];
    PFQuery    *feedsQuery    = [feedsRelation query];
    [feedsQuery orderByDescending:@"createdAt"];
    [feedsQuery includeKey:@"fromUser"];
    [feedsQuery includeKey:@"toUser"];
    [feedsQuery includeKey:@"toQuestion"];
    [feedsQuery includeKey:@"toComment"];
    [feedsQuery includeKey:@"toAnswer"];
    [feedsQuery setLimit:10];
    [feedsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            _activities = [NSMutableArray arrayWithArray:objects];
            block(YES, nil);
        } else {
            block(NO, error);
        }
    }];
}

- (void)fetchRecentQuestionsForUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error)) block {
    PFRelation *feedsRelation = [user relationForKey:@"feeds"];
    PFQuery    *feedsQuery    = [feedsRelation query];
    [feedsQuery orderByDescending:@"createdAt"];
    [feedsQuery includeKey:@"fromUser"];
    [feedsQuery includeKey:@"toQuestion"];
    [feedsQuery whereKey:@"type" equalTo:@"Ask"];
    [feedsQuery setLimit:5];
    [feedsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            _questions = [NSMutableArray arrayWithArray:objects];
            block(YES, nil);
        } else {
            block(NO, error);
        }
    }];
}

- (void)fetchRecentAnswersForUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error)) block {
    PFRelation *feedsRelation = [user relationForKey:@"feeds"];
    PFQuery    *feedsQuery    = [feedsRelation query];
    [feedsQuery orderByDescending:@"createdAt"];
    [feedsQuery includeKey:@"fromUser"];
    [feedsQuery includeKey:@"toQuestion"];
    [feedsQuery includeKey:@"toAnswer"];
    [feedsQuery includeKey:@"toUser"];
    [feedsQuery whereKey:@"type" equalTo:@"Answer"];
    [feedsQuery setLimit:5];
    [feedsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            _questions = [NSMutableArray arrayWithArray:objects];
            block(YES, nil);
        } else {
            block(NO, error);
        }
    }];
}

@end
