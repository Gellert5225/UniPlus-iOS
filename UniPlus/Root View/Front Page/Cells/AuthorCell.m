//
//  AuthorCell.m
//  UniPlus
//
//  Created by Jiahe Li on 22/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "AuthorCell.h"

@interface AuthorCell ()

@end

@implementation AuthorCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _usernameLabel.backgroundColor = [UIColor whiteColor];
    _renownLabel.backgroundColor = [UIColor whiteColor];
    
    UIView *topSeparatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.5)];
    topSeparatorView.layer.borderColor = [UIColor colorWithRed:209/255.0 green:209/255.0 blue:214/255.0 alpha:1].CGColor;
    topSeparatorView.layer.borderWidth = 0.5;
    [self.contentView addSubview:topSeparatorView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentProfileView)];
    tap.delegate = self;
    [_authorInfoView addGestureRecognizer:tap];
}

- (void)setAuthor:(PFUser *)author {
    _author = author;
    [self updateUI];
}

- (void)updateUI {
    _profilePhotoView.file = _author[@"profilePhoto80"];
    [_profilePhotoView loadInBackground];
    _usernameLabel.text = _author[@"nickName"];
    _renownLabel.text = [_author[@"reputation"] stringValue];
}

- (void)setCreationDate:(NSDate *)creationDate {
    _creationDate = creationDate;
    _timeLabel.text = [self getTimeWithPostDate:creationDate];
}

- (void)presentProfileView {
    [_delegate didTapAuthorInfo:_author];
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

@end
