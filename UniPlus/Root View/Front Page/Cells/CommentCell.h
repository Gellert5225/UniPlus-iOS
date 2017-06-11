//
//  CommentCell.h
//  UniPlus
//
//  Created by Jiahe Li on 24/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Comment.h"

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UIView *wrapperView;
@property (strong, nonatomic) Comment *comment;

@end
