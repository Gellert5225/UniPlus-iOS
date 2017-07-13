//
//  Answer.m
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "Answer.h"

@implementation Answer

- (id)initWithPFObject:(PFObject *)object {
    self = [super init];
    if (self) {
        _body          = object[@"body"];
        self.upVotes   = object[@"upVotes"];
        self.createdAt = object.createdAt;
        self.pfObject  = object;
        self.objectId  = object.objectId;
        self.author    = object[@"author"];
        self.type      = TypeAnswer;
    }
    return self;
}

+ (void)getAnswerFromPFObject:(PFObject *)object completionBlock:(void (^)(BOOL success, NSError *err, __weak Answer *answer))block {
    Answer *a = [[Answer alloc]initWithPFObject:object];
    PFRelation *voteRelation = [object relationForKey:@"votes"];
    PFQuery *q = [voteRelation query];
    [q whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    [q findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count) {
                PFObject *vote = objects[0];
                if ([vote[@"type"] isEqualToString:@"upVote"]) {
                    a.currentUserVote = @"upVote";
                } else {
                    a.currentUserVote = @"downVote";
                }
            } else {
                a.currentUserVote = @"none";
            }
        }
        [self getCommentsFromRelation:[object relationForKey:@"comments"] completionBlock:^(BOOL success, NSError *error, NSMutableArray *commentArray) {
            if (success) {
                a.comments = [[NSMutableArray alloc]initWithArray:commentArray];
                block(YES,nil,a);
            } else {
                block(NO, error,a);
            }
        }];
    }];
}

+ (void)getCommentsFromRelation:(PFRelation *)relation completionBlock:(void (^)(BOOL success, NSError *error, NSMutableArray *commentArray))block {
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    
    PFQuery *query = [relation query];
    [query includeKey:@"user"];
    [query includeKey:@"toUser"];
    [query orderByAscending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count) {
                for (PFObject *c in objects) {
                    Comment *comment = [[Comment alloc]initWithPFObject:c];
                    [comments addObject:comment];
                }
            }
            block(YES,nil,comments);
        } else {
            block(NO,error,nil);
        }
    }];
}

@end
