//
//  UPObject.m
//  UniPlus
//
//  Created by Jiahe Li on 17/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "UPObject.h"

@implementation UPObject

+ (void)upVote:(PFObject *)object voteType:(NSString *)vType objectType:(NSString *)objType byAmount:(NSNumber *)amount toUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error))block {
    if ([vType isEqualToString:@"newUpVote"]) {
        PFObject *feed = [PFObject objectWithClassName:@"Feeds"];
        feed[@"type"] = @"upVote";
        feed[@"fromUser"] = [PFUser currentUser];
        feed[@"toUser"] = user;
        if ([objType isEqualToString:@"Questions"]) {
            feed[@"toQuestion"] = object;
        } else {
            feed[@"toAnswer"] = object;
        }
        [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                //save relation.
                PFRelation *relation = [object relationForKey:@"votes"];
                [relation addObject:feed];
                [object incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:1]];
                [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
                    @"userId": user.objectId,
                    @"repChange": [NSNumber numberWithInt:10]
                }];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        block(YES, nil);
                    } else {
                        block(NO, error);
                    }
                }];
            } else {
                block(NO, error);
            }
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Feeds"];
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [objType isEqualToString:@"Questions"] ? [query whereKey:@"toQuestion" equalTo:object] : [query whereKey:@"toAnswer" equalTo:object];
        [query whereKey:@"type" equalTo:vType];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                if (objects.count) {
                    if ([vType isEqualToString:@"upVote"]) {
                        PFRelation *relation = [object relationForKey:@"votes"];
                        [relation removeObject:objects[0]];
                        [object incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:-1]];
                        [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
                           @"userId": user.objectId,
                           @"repChange": [NSNumber numberWithInt:-10]
                        }];
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
                                    if (succeeded) {
                                        block(YES, nil);
                                    } else {
                                        block(NO, error);
                                    }
                                }];
                            } else {
                                block(NO, error);
                            }
                        }];
                    } else if ([vType isEqualToString:@"downVote"]) {
                        PFObject *feed = objects[0];
                        feed[@"type"] = @"upVote";
                        [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                [object incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:2]];
                                [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
                                   @"userId": user.objectId,
                                   @"repChange": [NSNumber numberWithInt:20]
                                }];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    if (succeeded) {
                                        block(YES, nil);
                                    } else {
                                        block(NO, error);
                                    }
                                }];
                            } else {
                                block(NO, error);
                            }
                        }];
                    }
                } else {
                    block(NO, nil);
                }
            } else {
                block(NO, error);
            }
        }];
    }
}

+ (void)downVote:(PFObject *)object voteType:(NSString *)vType objectType:(NSString *)objType byAmount:(NSNumber *)amount toUser:(PFUser *)user completionBlock:(void (^)(BOOL success, NSError *error))block {
    if ([vType isEqualToString:@"newDownVote"]) {
        PFObject *feed = [PFObject objectWithClassName:@"Feeds"];
        feed[@"type"] = @"downVote";
        feed[@"fromUser"] = [PFUser currentUser];
        feed[@"toUser"] = user;
        if ([objType isEqualToString:@"Questions"]) {
            feed[@"toQuestion"] = object;
        } else {
            feed[@"toAnswer"] = object;
        }
        [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if (succeeded) {
                //save relation.
                PFRelation *relation = [object relationForKey:@"votes"];
                [relation addObject:feed];
                [object incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:-1]];
                [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
                   @"userId": user.objectId,
                   @"repChange": [NSNumber numberWithInt:-10]
                }];
                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        block(YES, nil);
                    } else {
                        block(NO, error);
                    }
                }];
            } else {
                block(NO, error);
            }
        }];
    } else {
        PFQuery *query = [PFQuery queryWithClassName:@"Feeds"];
        [query whereKey:@"fromUser" equalTo:[PFUser currentUser]];
        [objType isEqualToString:@"Questions"] ? [query whereKey:@"toQuestion" equalTo:object] : [query whereKey:@"toAnswer" equalTo:object];
        [query whereKey:@"type" equalTo:vType];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                if (objects.count) {
                    if ([vType isEqualToString:@"downVote"]) {
                        PFRelation *relation = [object relationForKey:@"votes"];
                        [relation removeObject:objects[0]];
                        [object incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:1]];
                        [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
                           @"userId": user.objectId,
                           @"repChange": [NSNumber numberWithInt:10]
                        }];
                        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                [PFObject deleteAllInBackground:objects block:^(BOOL succeeded, NSError * _Nullable error) {
                                    if (succeeded) {
                                        block(YES, nil);
                                    } else {
                                        block(NO, error);
                                    }
                                }];
                            } else {
                                block(NO, error);
                            }
                        }];
                    } else if ([vType isEqualToString:@"upVote"]) {
                        PFObject *feed = objects[0];
                        feed[@"type"] = @"downVote";
                        [feed saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                            if (succeeded) {
                                [object incrementKey:@"upVotes" byAmount:[NSNumber numberWithInt:-2]];
                                [PFCloud callFunctionInBackground:@"changeReputation" withParameters:@{
                                   @"userId": user.objectId,
                                   @"repChange": [NSNumber numberWithInt:-20]
                                }];
                                [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                                    if (succeeded) {
                                        block(YES, nil);
                                    } else {
                                        block(NO, error);
                                    }
                                }];
                            } else {
                                block(NO, error);
                            }
                        }];
                    }
                } else {
                    block(NO, nil);
                }
            } else {
                block(NO, error);
            }
        }];
    }
}

@end
