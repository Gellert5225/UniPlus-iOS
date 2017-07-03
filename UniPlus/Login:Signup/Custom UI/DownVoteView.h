//
//  DownVoteView.h
//  UniPlus
//
//  Created by Jiahe Li on 12/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPObject.h"

@class DownVoteView;
@protocol DownVoteViewDelegate
@optional
- (void)downVoteObject:(UPObject *)object;
@end

@interface DownVoteView : UIImageView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UPObject *object;
@property (weak, nonatomic) id <DownVoteViewDelegate> delegate;
@property (strong, nonatomic) NSString *type;
@property (nonatomic) BOOL own;

@end
