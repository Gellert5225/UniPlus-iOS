//
//  UpVoteView.h
//  UniPlus
//
//  Created by Jiahe Li on 11/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UPObject.h"

@class UpVoteView;
@protocol UpVoteViewDelegate
@optional
- (void)upVoteObject:(UPObject *)object;
@end

@interface UpVoteView : UIImageView<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UPObject *object;
@property (nonatomic, weak) id <UpVoteViewDelegate> delegate;
@property (strong, nonatomic) NSString *type;
@property (nonatomic) BOOL own;

@end
