//
//  GeneralDiscussionCell.h
//  UniPlus
//
//  Created by Jiahe Li on 23/09/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SLExpandableTableView.h"

/*!
 @class GeneralDiscussionCell
 
 @brief The cell used for left menu
 */
@interface GeneralDiscussionCell : UITableViewCell<UIExpandingTableViewCell>

/*!
 * @brief The cell image
 */
@property (weak, nonatomic) IBOutlet UIImageView *cellImg;
/*!
 * @brief The cell text
 */
@property (weak, nonatomic) IBOutlet UILabel *cellText;
/*!
 * @brief Determine whether the cell is loading or not
 */
@property (nonatomic, assign, getter = isLoading) BOOL loading;

@property (nonatomic, readonly) UIExpansionStyle expansionStyle;
- (void)setExpansionStyle:(UIExpansionStyle)expansionStyle animated:(BOOL)animated;


@end
