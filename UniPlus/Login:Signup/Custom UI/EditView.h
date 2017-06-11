//
//  EditView.h
//  UniPlus
//
//  Created by Jiahe Li on 28/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@class EditView;

@protocol EditViewDelegate <NSObject>

- (void)didTapEditViewAtIndex:(NSIndexPath *)index objectToEdit:(PFObject *)object;

@end

@interface EditView : UIView<UIGestureRecognizerDelegate>

@property (weak, nonatomic) id <EditViewDelegate>delegate;
@property (strong, nonatomic) NSIndexPath *index;
@property (strong, nonatomic) PFObject *objectToEdit;

@end
