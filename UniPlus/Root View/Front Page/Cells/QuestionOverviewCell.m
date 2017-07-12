//
//  QuestionOverviewCell.m
//  UniPlus
//
//  Created by Jiahe Li on 26/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "QuestionOverviewCell.h"

#define IMG_TINT_COLOR [UIColor colorWithRed:129/255.0 green:129/255.0 blue:145/255.0 alpha:1]
#define STATS_TEXT_COLOR [UIColor colorWithRed:169/255.0 green:169/255.0 blue:185/255.0 alpha:1]
#define COLOR_SCHEME [UIColor colorWithRed:25/255.0 green:140/255.0 blue:212/255.0 alpha:1.0]

@implementation QuestionOverviewCell {
    NSMutableParagraphStyle *paragraphStyle;
    NSDictionary *titleAtrribute;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    //label fonts and colors
    
    //[_profileImageView zy_cornerRadiusAdvance:5.0f rectCornerType:UIRectCornerAllCorners];
    
    _questionTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _questionTitleLabel.numberOfLines = 3;
    _questionTitleLabel.textColor     = [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0];
    _questionTitleLabel.font          = [UIFont fontWithName:@"SFUIText-Regular" size:13];//[UIFont fontWithName:@"OpenSans" size:13];
    [_questionTitleLabel sizeToFit];
    
    _timeLabel.font      = [UIFont fontWithName:@"SFUIText-Regular" size:11];//[UIFont fontWithName:@"OpenSans" size:11];//
    _timeLabel.textColor = STATS_TEXT_COLOR;
    [_timeLabel sizeToFit];
    
    _tagLabel.font      = [UIFont fontWithName:@"SFUIText-Regular" size:12];//[UIFont fontWithName:@"OpenSans" size:12];
    _tagLabel.textColor = STATS_TEXT_COLOR;
    [_tagLabel sizeToFit];
    
    _userNameLabel.font      = [UIFont fontWithName:@"SFUIText-Medium" size:12];//[UIFont fontWithName:@"OpenSans-Semibold" size:12];//[UIFont fontWithName:@"SFUIText-Medium" size:12];
    _userNameLabel.textColor = [UIColor colorWithWhite:0 alpha:0.7];
    [_userNameLabel sizeToFit];
    
    _upvoteLabel.textColor = STATS_TEXT_COLOR;
    _replyLabel.textColor  = STATS_TEXT_COLOR;
    _viewLabel.textColor   = STATS_TEXT_COLOR;
    
    //image tint
    _thumbupImgView.image = [_thumbupImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_thumbupImgView setTintColor:IMG_TINT_COLOR];
    
    _replyImgView.image = [_replyImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_replyImgView setTintColor:IMG_TINT_COLOR];
    
    _viewImgView.image = [_viewImgView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_viewImgView setTintColor:IMG_TINT_COLOR];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:219/255.0 green:219/255.0 blue:224/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    _questionTitleLabel.backgroundColor = [UIColor whiteColor];
    _userNameLabel.backgroundColor      = [UIColor whiteColor];
    _upvoteLabel.backgroundColor        = [UIColor whiteColor];
    _replyLabel.backgroundColor         = [UIColor whiteColor];
    _viewLabel.backgroundColor          = [UIColor whiteColor];
    _timeLabel.backgroundColor          = [UIColor whiteColor];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
    [self setSelectedBackgroundView:bgColorView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setQuestionObject:(PFObject *)questionObject {
    _questionObject = questionObject;
    [self updateUI];
}

- (void)updateUI {
    PFUser *questionAuthor = [_questionObject objectForKey:@"user"];
    
    _profileImageView.image = [UIImage imageNamed:@"empty-profile-small"];//placeholder
    _profileImageView.file  = [questionAuthor objectForKey:@"profilePhoto80"];
    [_profileImageView loadInBackground];
    
    _profileImageView.layer.masksToBounds = YES;
    _profileImageView.layer.cornerRadius  = 5.0f;
    _profileImageView.layer.shouldRasterize = YES;
    _profileImageView.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    
    _userNameLabel.text = questionAuthor[@"nickName"];
    _upvoteLabel.text   = [_questionObject[@"upVotes"]          stringValue];
    _replyLabel.text    = [_questionObject[@"numberOfComments"] stringValue];
    _viewLabel.text     = [_questionObject[@"views"]            stringValue];
    _timeLabel.text     = [self getTimeWithPostDate:_questionObject.createdAt];
    
    [_questionTitleLabel sizeToFit];
    _questionTitleLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:_questionObject[@"title"] attributes:titleAtrribute];
}

- (NSString *)getTimeWithPostDate:(NSDate *)postDate {
    NSDate *currentDate = [NSDate date];
    long min  = (long)([currentDate timeIntervalSinceDate:postDate]/60);
    long hour = min/60;
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    NSString *date = [dateFormat stringFromDate:postDate];
    
    NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
    [timeFormat setDateFormat:@"HH:mm"];
    NSString *time = [timeFormat stringFromDate:postDate];
    
    if ([currentDate timeIntervalSinceDate:postDate]<60) {
        return [NSString stringWithFormat:@"Just now"];
    } else {
        if (hour < 24) {
            return [NSString stringWithFormat:@"%@", time];
        } else {
            return [NSString stringWithFormat:@"%@", date];
        }
    }
}

- (void)setAttributes {
    paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 17.0f;
    paragraphStyle.maximumLineHeight  = 17.0f;
    paragraphStyle.lineBreakMode      = NSLineBreakByTruncatingTail;
    
    titleAtrribute = @{
         NSParagraphStyleAttributeName : paragraphStyle,
         NSForegroundColorAttributeName: [UIColor colorWithRed:53/255.0 green:111/255.0 blue:177/255.0 alpha:1.0],
         NSFontAttributeName           : [UIFont fontWithName:@"SFUIText-Regular" size:13]
    };
}

- (UIImage *)optimizedImageFromImage:(UIImage *)image {
    CGSize imageSize = image.size;
    UIGraphicsBeginImageContextWithOptions( imageSize, YES, 1.0 );
    [image drawInRect: CGRectMake( 0, 0, imageSize.width, imageSize.height )];
    UIImage *optimizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return optimizedImage;
}

@end
