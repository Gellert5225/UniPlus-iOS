//
//  Question.m
//  UniPlus
//
//  Created by Jiahe Li on 20/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "Question.h"

@implementation Question
@synthesize currentUserVote;

+ (void)getQuestionObjectWithObjectId:(NSString *)objectId
                      completionBlock:(void (^)(BOOL success, NSError *error, PFObject *pfQuestion, __weak Question *question))block {
    Question *question = [[Question alloc]init];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Questions"];
    [query includeKey:@"user"];
    [query includeKey:@"correctAnswer"];
    [query getObjectInBackgroundWithId:objectId block:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (object) {
            question.title            = object[@"title"];
            question.body             = object[@"body"];
            question.category         = object[@"category"];
            question.upVotes          = object[@"upVotes"];
            question.numberOfComments = object[@"numberOfComments"];
            question.numberOfFavs     = object[@"numberOfFavs"];
            question.views            = object[@"views"];
            question.author           = object[@"user"];
            question.correctAnswer    = object[@"correctAnswer"];
            question.createdAt        = object.createdAt;
            question.objectId         = object.objectId;
            question.pfObject         = object;
            question.type             = TypeQuestion;
            
            if ([object[@"markedUsers"] containsObject:[PFUser currentUser].objectId]) {
                question.markedByUser = YES;
            } else {
                question.markedByUser = NO;;
            }
            
            PFRelation *voteRelation = [object relationForKey:@"votes"];
            PFQuery *q = [voteRelation query];
            [q whereKey:@"fromUser" equalTo:[PFUser currentUser]];
            [q findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                if (!error) {
                    if (objects.count) {
                        PFObject *vote = objects[0];
                        if ([vote[@"type"] isEqualToString:@"upVote"]) {
                            question.currentUserVote = @"upVote";
                        } else {
                            question.currentUserVote = @"downVote";
                        }
                    } else {
                        question.currentUserVote = @"none";
                    }
                    [self getCommentsAndAnswersFromCommentRelation:[object relationForKey:@"comments"]
                                                    answerRelation:[object relationForKey:@"answers"]
                                                   completionBlock:^(BOOL success, NSError *err, NSMutableArray *commentArray, NSMutableArray *answerArray) {
                        if (success) {
                            question.comments = [[NSMutableArray alloc]initWithArray:commentArray];
                            [answerArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                                __weak Answer *a = obj;
                                if ([a.pfObject.objectId isEqualToString:question.correctAnswer.objectId]) {
                                    [answerArray removeObjectAtIndex:idx];
                                    [answerArray insertObject:a atIndex:0];
                                }
                            }];
                            
                            question.answers = [[NSMutableArray alloc]initWithArray:answerArray];
                            block(YES, nil, object, question);
                        } else {
                            block(NO, err, nil, nil);
                        }
                    }];
                } else {
                    block(NO, error, nil, nil);
                }
            }];
        } else {
            block(NO, error, nil, nil);
        }
    }];
}

+ (void)getCommentsAndAnswersFromCommentRelation:(PFRelation *)commentRelation
                                  answerRelation:(PFRelation *)ansRelation
                                 completionBlock:(void (^)(BOOL success, NSError *error, NSMutableArray *commentArray, NSMutableArray *answerArray))block {
    NSMutableArray *comments = [[NSMutableArray alloc]init];
    NSMutableArray *answers  = [[NSMutableArray alloc]init];
    
    PFQuery *query = [commentRelation query];
    [query includeKey:@"user"];
    [query includeKey:@"toUser"];
    [query orderByAscending:@"createdAt"];
    
    PFQuery *ansQuery = [ansRelation query];
    [ansQuery includeKey:@"author"];
    [ansQuery orderByDescending:@"upVotes"];
    
    //find comments
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            if (objects.count) {
                for (PFObject *c in objects) {
                    Comment *comment = [[Comment alloc]initWithPFObject:c];
                    [comments addObject:comment];
                }
            }
            //find answers
            [ansQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable ansObjects, NSError * _Nullable ansError) {
                if (!ansError) {
                    if (ansObjects.count) { //if there is any answers to this question
                        for (PFObject *a in ansObjects) {
                            [Answer getAnswerFromPFObject:a completionBlock:^(BOOL success,NSError *err, __weak Answer *answer) { //convert PFObject to Answer
                                if (success) {
                                    [answers addObject:answer];
                                    if (answers.count == ansObjects.count) { //if we have added all the Answers to the array
                                        block(YES,nil,comments,answers);
                                    }
                                } else {
                                    block(NO,err,comments,nil);
                                }
                            }];
                        }
                    } else {
                        block(YES,nil,comments,answers);
                    }
                } else {
                    block(NO,ansError,comments, nil);
                }
            }];
        } else {
            block(NO,error,nil, nil);
        }
    }];
}

- (NSMutableArray *)comments {
    if (!_comments) {
        _comments = [[NSMutableArray alloc]init];
    }
    return _comments;
}

- (void)deleteQuestion {
    if (self.comments.count) {
        for (Comment *c in self.comments) {
            [c deleteComments];
        }
    }
    
    if (self.answers.count) {
        for (Answer *a in self.answers) {
            [a deleteAnswer];
        }
    }
    
    //delete the feed
    [PFCloud callFunctionInBackground:@"deleteQuestionFeed" withParameters:@{@"questionId" : self.objectId}];
}

- (void)incrementPropertyByKey:(PropertyType)key {
    if (key == Views) {
        self.views = [NSNumber numberWithInt:[self.views intValue] + 1];
    } else if (key == NumberOfComments) {
        self.numberOfComments = [NSNumber numberWithInt:[self.numberOfComments intValue] + 1];
    } else if (key == UpVotes) {
        self.upVotes = [NSNumber numberWithInt:[self.upVotes intValue] + 1];
    } else if (key == NumberOfFavs) {
        self.numberOfFavs = [NSNumber numberWithInt:[self.numberOfFavs intValue] + 1];
    } else {
        NSException *exception = [NSException
                                  exceptionWithName:NSInvalidArgumentException
                                  reason:@"Invalid argument!"
                                  userInfo:nil];
        @throw exception;
    }
}

- (void)incrementPropertyByKey:(PropertyType)key amount:(NSNumber *)amount {
    if (key == Views) {
        self.views = [NSNumber numberWithInt:[self.views intValue] + [amount intValue]];
    } else if (key == NumberOfComments) {
        self.numberOfComments = [NSNumber numberWithInt:[self.numberOfComments intValue] + [amount intValue]];
    } else if (key == UpVotes) {
        self.upVotes = [NSNumber numberWithInt:[self.upVotes intValue] + [amount intValue]];
    } else if (key == NumberOfFavs) {
        self.numberOfFavs = [NSNumber numberWithInt:[self.numberOfFavs intValue] + [amount intValue]];
    } else {
        NSException *exception = [NSException
                                  exceptionWithName:NSInvalidArgumentException
                                  reason:@"Invalid argument!"
                                  userInfo:nil];
        @throw exception;
    }
}

@end
