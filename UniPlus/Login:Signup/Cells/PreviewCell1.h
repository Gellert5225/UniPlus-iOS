//
//  PreviewCell1.h
//  Shutteradio
//
//  Created by Jiahe Li on 11/10/2015.
//  Copyright © 2015 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParseUI.h"

/*!
 @class PreviewCell1
 
 @brief The cell displayed at indexPath.row:0
 
 @discussion It has 2 "rows", separated by a thin line.
 */
@interface PreviewCell1 : UITableViewCell
/*!
 * @brief Used for display the profile photo
 */
@property (weak, nonatomic) IBOutlet PFImageView *profilePhotoView;
/*!
 * @brief User's nick name
 */
@property (weak, nonatomic) IBOutlet UITextField *nameField;
/*!
 * @brief User's username which is used for login
 */
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
/*!
 * @brief A button used for edit the profile photo
 */
@property (weak, nonatomic) IBOutlet UIButton *editButton;

@end
