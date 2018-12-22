//
//  QuestionDetailViewModel.m
//  UniPlus
//
//  Created by Jiahe Li on 25/04/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import "QuestionDetailViewModel.h"

@implementation QuestionDetailViewModel
@synthesize question = _question;

- (void)setQuestion:(Question *)question {
    _question = question;
}

- (Question *)_question {
    if (!_question) {
        _question = [[Question alloc]init];
    }
    return _question;
}

- (id)initWithQuesstionID:(NSString *)questionID {
    self = [super init];
    if (self) {
        _questionID = questionID;
    }
    return self;
}

- (void)fetchQuestionWithQuestionID:(NSString *)questionID completionBlock:(void (^)(BOOL success, NSError *error)) block {
    [Question getQuestionObjectWithObjectId:questionID completionBlock:^(BOOL success, NSError *error, PFObject *pfQuestion, __weak Question *question) {
        if (success) {
            self->_question = question;
            block(YES, nil);
        } else {
            block(NO, error);
        }
    }];
}

- (void)acceptAnswer:(Answer *)answer accepted:(BOOL)accepted {
    if (accepted) {
        _question.pfObject[@"correctAnswer"] = answer.pfObject;
        _question.correctAnswer = answer.pfObject;
    } else {
        [_question.pfObject removeObjectForKey:@"correctAnswer"];
        _question.correctAnswer = nil;
    }
    
    [_question.pfObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            if (![answer.author.objectId isEqualToString:[PFUser currentUser].objectId]) {
                [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
                   @"userId": answer.author.objectId,
                   @"repChange": [NSNumber numberWithInt:accepted?15:-15]
                }];
            }
            [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
               @"userId": [PFUser currentUser].objectId,
               @"repChange": [NSNumber numberWithInt:accepted?2:-2]
            }];
        }
    }];
}

- (void)commentToObject:(UPObject *)object withCommentBody:(NSString *)body replyToComment:(PFObject *)toComment {
    PFObject *comment = [PFObject objectWithClassName:@"Comments"];
    comment[@"user"]        = [PFUser currentUser];
    comment[@"toUser"]      = object.author;
    comment[@"commentBody"] = body;
    comment[@"upVotes"]     = [NSNumber numberWithInt:0];
    if (toComment) {
        comment[@"replyToComment"] = toComment;
    }
    
    [Comment commentToObject:object withComment:comment underQuestion:_question];
    
    Comment *c = [[Comment alloc]initWithPFObject:comment];
    
    if ([object isKindOfClass:[Question class]]) {
        [_question.comments addObject:c];
    } else if ([object isKindOfClass:[Answer class]]) {
        Answer *a = (Answer *)object;
        [a.comments addObject:c];
    }
}

- (void)incrementNumberOfViews {
    if (![_question.author.objectId isEqualToString:[PFUser currentUser].objectId]) {
        [_question incrementPropertyByKey:Views];
        [_question.pfObject incrementKey:@"views"];
        [_question.pfObject saveInBackground];
    }
}

@end
