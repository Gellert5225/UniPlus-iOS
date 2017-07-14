//
//  Comment.m
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "Comment.h"

@implementation Comment

- (id)initWithPFObject:(PFObject *)object {
    self = [super init];
    if (self) {
        _body          = object[@"commentBody"];
        _toUser        = object[@"toUser"];
        self.createdAt = object.createdAt;
        self.objectId  = object.objectId;
        self.author    = object[@"user"];
        self.upVotes   = object[@"upVotes"];
        self.pfObject  = object;
        self.type      = TypeComment;
    }
    return self;
}

+ (void)commentToObject:(UPObject *)object withComment:(PFObject *)comment underQuestion:(Question *)question {
    PFObject *objectCommentedTo;
    if ([object isKindOfClass:[Question class]]) {
        Question *q = (Question *)object;
        objectCommentedTo = q.pfObject;
    } else if ([object isKindOfClass:[Answer class]]) {
        Answer *answer = (Answer *)object;
        objectCommentedTo = answer.pfObject;
    }
    
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            PFRelation *commentRelation = [objectCommentedTo relationForKey:@"comments"];
            [commentRelation addObject:comment];
            //[question.pfQuestion incrementKey:@"numberOfComments"];
            [objectCommentedTo saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    PFObject *feed = [PFObject objectWithClassName:@"Feeds"];
                    feed[@"type"]       = [object isKindOfClass:[Question class]]?@"CommentToQuestion":@"CommentToAnswer";
                    feed[@"fromUser"]   = [PFUser currentUser];
                    feed[@"toUser"]     = object.author;
                    feed[@"toQuestion"] = question.pfObject;
                    feed[@"toQuestionID"] = question.objectId;
                    if ([object isKindOfClass:[Answer class]]){feed[@"toAnswer"] = objectCommentedTo;feed[@"toAnswerID"] = objectCommentedTo.objectId;}
                    feed[@"toComment"]  = comment;
                    feed[@"toCommentID"] = comment.objectId;
                    feed[@"repChange"]  = [NSNumber numberWithInt:0];
                    [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                        if (succeeded) {
                            //NSLog(@"succeed saving feed");
                            [PFCloud callFunctionInBackground:@"commentNotification" withParameters:@{
                                @"targetUser":object.author.objectId,
                                @"message":[NSString stringWithFormat:@"%@ commented on your question: %@", PFUser.currentUser.username, comment[@"commentBody"]]
                            }];
                            PFRelation *rel = [[PFUser currentUser] relationForKey:@"feeds"];
                            [rel addObject:feed];
                            [[PFUser currentUser] saveInBackground];
                        } else {
                            
                        }
                    }];
                } else {
                    
                }
            }];
        } else {
            
        }
    }];
}

- (void)deleteComments {
    PFQuery *q = [PFQuery queryWithClassName:@"Comments"];
    [q getObjectInBackgroundWithId:self.objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            [object deleteInBackground];
        }
    }];
}

@end
