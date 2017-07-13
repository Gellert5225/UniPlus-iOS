//
//  AccessoryCell.h
//  UniPlus
//
//  Created by Jiahe Li on 21/10/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavouriteView.h"
#import "EditView.h"

@interface AccessoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *flagImageView;
@property (weak, nonatomic) IBOutlet UIImageView *editImageView;
@property (weak, nonatomic) IBOutlet UIImageView *reportImageView;
@property (weak, nonatomic) IBOutlet UIImageView *moreImageView;
@property (weak, nonatomic) IBOutlet UILabel *markLabel;
@property (weak, nonatomic) IBOutlet UILabel *editLabel;
@property (weak, nonatomic) IBOutlet UILabel *reportLabel;
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;
@property (weak, nonatomic) IBOutlet FavouriteView *markView;
@property (weak, nonatomic) IBOutlet EditView *editView;

@property (nonatomic) BOOL belongsToAuthor;

@end
