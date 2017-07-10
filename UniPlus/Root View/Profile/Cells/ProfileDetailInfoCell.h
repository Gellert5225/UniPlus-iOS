//
//  ProfileDetailInfoCell.h
//  UniPlus
//
//  Created by Jiahe Li on 09/06/2017.
//  Copyright © 2017 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileDetailInfoCell;

@protocol ProfileDetailInfoCellDelegate

- (void)didTapQuestionView;
- (void)didTapAnswerView;

@end

@interface ProfileDetailInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *questionView;
@property (weak, nonatomic) IBOutlet UIView *answerView;
@property (weak, nonatomic) id <ProfileDetailInfoCellDelegate>delegate;

@end
