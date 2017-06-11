//
//  EditView.m
//  UniPlus
//
//  Created by Jiahe Li on 28/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "EditView.h"

@implementation EditView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didTap)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)didTap {
    [_delegate didTapEditViewAtIndex:_index objectToEdit:_objectToEdit];
}

- (void)setIndex:(NSIndexPath *)index {
    _index = index;
}

- (void)setObjectToEdit:(PFObject *)objectToEdit {
    _objectToEdit = objectToEdit;
}

@end
