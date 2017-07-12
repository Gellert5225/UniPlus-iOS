//
//  FavouriteView.m
//  UniPlus
//
//  Created by Jiahe Li on 28/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "FavouriteView.h"

#define IMG_TINT_COLOR [UIColor colorWithRed:129/255.0 green:129/255.0 blue:145/255.0 alpha:1]
#define COLOR_SCHEME [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0]

@implementation FavouriteView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        _markLabel = [self viewWithTag:1];
        _markImgView = [self viewWithTag:2];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didTap {
    [self markQuestion:_questionToFavourite];
}

- (void)setQuestionToFavourite:(PFObject *)questionToFavourite {
    _questionToFavourite = questionToFavourite;
}

- (void)setAlreadyMarked:(BOOL)alreadyMarked {
    _alreadyMarked = alreadyMarked;
    if (alreadyMarked) {
        _markLabel.text = @"Marked";
        _markLabel.font = [UIFont fontWithName:@"SFUIText-Bold" size:11];
        _markImgView.image = [_markImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_markImgView setTintColor:COLOR_SCHEME];
    } else {
        _markLabel.text = @"Mark";
        _markLabel.font = [UIFont fontWithName:@"SFUIText-Medium" size:11];
        _markImgView.image = [_markImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_markImgView setTintColor:IMG_TINT_COLOR];
    }
}

- (void)markQuestion:(PFObject *)question {
    //NSLog(@"Quesiton to fav: %@", question);
    [_delegate didTapFavouriteView];
    if (!_alreadyMarked) {
        _alreadyMarked = YES;
        _markLabel.text = @"Marked";
        _markLabel.font = [UIFont fontWithName:@"SFUIText-Bold" size:11];
        _markImgView.image = [_markImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_markImgView setTintColor:COLOR_SCHEME];
        
        PFRelation *rel = [[PFUser currentUser] relationForKey:@"favourites"];
        [rel addObject:question];
        [[PFUser currentUser] saveInBackground];
        
        NSMutableArray *markedUsers = [[NSMutableArray alloc]initWithArray:question[@"markedUsers"]];
        [markedUsers addObject:[PFUser currentUser].objectId];
        
        question[@"markedUsers"] = markedUsers;
        [question saveInBackground];
    } else {
        _alreadyMarked = NO;
        _markLabel.text = @"Mark";
        _markLabel.font = [UIFont fontWithName:@"SFUIText-Medium" size:11];
        _markImgView.image = [_markImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_markImgView setTintColor:IMG_TINT_COLOR];
        
        PFRelation *rel = [[PFUser currentUser] relationForKey:@"favourites"];
        [rel removeObject:question];
        [[PFUser currentUser] saveInBackground];
        
        NSMutableArray *markedUsers = [[NSMutableArray alloc]initWithArray:question[@"markedUsers"]];
        if ([markedUsers containsObject:[PFUser currentUser].objectId]) {
            [markedUsers removeObject:[PFUser currentUser].objectId];
        }
        
        question[@"markedUsers"] = markedUsers;
        [question saveInBackground];
    }
}

@end
