//
//  AnswerAccessoryCell.h
//  UniPlus
//
//  Created by Jiahe Li on 28/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditView.h"

@interface AnswerAccessoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UIImageView *reportImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet EditView *editView;
@property (weak, nonatomic) IBOutlet UILabel *reportLabel;

@property (nonatomic) BOOL belongsToAuthor;

@end
