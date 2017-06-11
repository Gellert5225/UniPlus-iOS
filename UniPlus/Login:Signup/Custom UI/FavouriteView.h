//
//  FavouriteView.h
//  UniPlus
//
//  Created by Jiahe Li on 28/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Question.h"

@class FavouriteView;
/**
 Event controller for marking the question as favourite.
 */
@protocol FavouriteViewDelegate <NSObject>

/**
 Handle the marking action.
 */
- (void)didTapFavouriteView;

@end

/**
 A custom view that handles the mark event.
 */
@interface FavouriteView : UIView<UIGestureRecognizerDelegate>

/**
 @name Properties
 */

/**
 The FavouriteView delegate
 */
@property (weak, nonatomic) id <FavouriteViewDelegate>delegate;
/**
 The UIImage view where shows the mark flag.
 */
@property (strong, nonatomic) UIImageView *markImgView;
/**
 The UILabel which display whether the user marked the question or not.
 */
@property (strong, nonatomic) UILabel *markLabel;
/**
 The question object to be marked.
 */
@property (strong, nonatomic) PFObject *questionToFavourite;
/**
 Whether or not the user has already marked the question.
 */
@property (nonatomic) BOOL alreadyMarked;

@end
