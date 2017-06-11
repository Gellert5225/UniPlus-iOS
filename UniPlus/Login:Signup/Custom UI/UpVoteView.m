//
//  UpVoteView.m
//  UniPlus
//
//  Created by Jiahe Li on 11/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "UpVoteView.h"

@implementation UpVoteView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(buttonPressed)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)buttonPressed {
    NSString *voteType;
    NSNumber *voteChange;
    NSString *newCurrentuserVote;
    
    UIView *wrapper = self.superview;
    UIImageView *downImgView = [wrapper viewWithTag:2];
    UILabel *voteLabel = [wrapper viewWithTag:3];
    
    if (!_own) {
        if ([_object.currentUserVote isEqualToString:@"upVote"]) { //user has already upvoted the question //user has changed his mind, so we decrement it by 1.
            voteType = @"upVote";
            newCurrentuserVote = @"none";
            voteChange = [NSNumber numberWithInt:-1];
            self.image = [UIImage imageNamed:@"tri-up"];
        } else if ([_object.currentUserVote isEqualToString:@"downVote"]) { //user has already down voted
            voteType = @"downVote";
            newCurrentuserVote = @"upVote";
            voteChange = [NSNumber numberWithInt:2];
            self.image  = [UIImage imageNamed:@"tri-up-sel"];
            downImgView.image  = [UIImage imageNamed:@"tri-down"];
        } else {
            // create relation.
            voteType = @"newUpVote";
            newCurrentuserVote = @"upVote";
            voteChange = [NSNumber numberWithInt:1];
            self.image  = [UIImage imageNamed:@"tri-up-sel"];
        }
        
        _object.upVotes = [NSNumber numberWithInt:[_object.upVotes intValue] + voteChange.intValue];
        _object.currentUserVote = newCurrentuserVote;
        voteLabel.text = [_object.upVotes stringValue];
        
        [UPObject upVote:_object.pfObject voteType:voteType objectType:_type byAmount:voteChange toUser:_object.author completionBlock:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"%@", voteType);
            } else {
                NSLog(@"%@", error.userInfo[@"error"]);
            }
            wrapper.userInteractionEnabled = YES;
        }];
    }
    [self.delegate upVoteObject:_object];
}

@end
