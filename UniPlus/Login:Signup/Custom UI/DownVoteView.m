//
//  DownVoteView.m
//  UniPlus
//
//  Created by Jiahe Li on 12/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "DownVoteView.h"

@implementation DownVoteView

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
    UIImageView *upImgView = [wrapper viewWithTag:1];
    UILabel *voteLabel = [wrapper viewWithTag:3];
    
    if (!_own){
        if ([_object.currentUserVote isEqualToString:@"downVote"]) { //user has already down voted the question //user has changed his mind, so we increment it by 1.
            voteType = @"downVote";
            newCurrentuserVote = @"none";
            voteChange = [NSNumber numberWithInt:1];
            self.image = [UIImage imageNamed:@"tri-down"];
        } else if ([_object.currentUserVote isEqualToString:@"upVote"]) {
            voteType = @"upVote";
            newCurrentuserVote= @"downVote";
            voteChange = [NSNumber numberWithInt:-2];
            upImgView.image = [UIImage imageNamed:@"tri-up"];
            self.image = [UIImage imageNamed:@"tri-down-sel"];
        } else {
            // create relation.
            newCurrentuserVote = @"downVote";
            voteType = @"newDownVote";
            voteChange = [NSNumber numberWithInt:-1];
            self.image = [UIImage imageNamed:@"tri-down-sel"];
        }
        
        _object.upVotes = [NSNumber numberWithInt:[_object.upVotes intValue] + voteChange.intValue];
        _object.currentUserVote = newCurrentuserVote;
        voteLabel.text = [_object.upVotes stringValue];
        
        [UPObject downVote:_object.pfObject voteType:voteType objectType:_type byAmount:voteChange toUser:_object.author completionBlock:^(BOOL success, NSError *error) {
            if (success) {
                NSLog(@"%@", voteType);
            } else {
                NSLog(@"%@", error.userInfo[@"error"]);
            }
            wrapper.userInteractionEnabled = YES;
        }];
    }
    [self.delegate downVoteObject:_object];
}

@end
