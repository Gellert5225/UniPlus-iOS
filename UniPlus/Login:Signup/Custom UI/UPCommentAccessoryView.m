//
//  UPCommentAccessoryView.m
//  UniPlus
//
//  Created by Jiahe Li on 14/11/2016.
//  Copyright © 2016 Quicky Studio. All rights reserved.
//

#import "UPCommentAccessoryView.h"

@interface UPCommentAccessoryView ()

@property (strong, nonatomic) NSNumber *characterLimit;
@property (nonatomic) CGSize currentTextViewSize;
@property (strong, nonatomic) UIPanGestureRecognizer *pan;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;

@end

@implementation UPCommentAccessoryView

static CGFloat const kBounceValue = 0.0f;

#pragma - mark Life Cycle

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nib {
    self = [super init];
    
    if (self) {
        CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
        
        self = [[[NSBundle mainBundle] loadNibNamed:nib owner:self options:nil] objectAtIndex:0];
        self.frame = CGRectMake(0, 0, screenWidth, self.frame.size.height);
        
        [self addGestures];
        
        _currentTextViewSize = _commentView.frame.size;
        self.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self sizeToFit];
        [self layOutViews];
    }
    
    return self;
}

- (void)addGestures {
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisView:)];
    _pan.delegate = self;
    [_frontView addGestureRecognizer:_pan];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(discard)];
    tap.delegate = self;
    [_discardView addGestureRecognizer:tap];
}

- (void)discard {
    [_delegate userDidTapDiscardView];
}

- (void)layOutViews {
    _commentView.delegate = self;
    _commentView.layer.cornerRadius = 3.0f;
    _commentView.textContainerInset = UIEdgeInsetsMake(7.5, 0, 7.5, 0);
    _commentView.backgroundColor = [UIColor whiteColor];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineHeightMultiple = 16.0f;
    paragraphStyle.maximumLineHeight  = 16.0f;
    
    NSDictionary *titleAtrribute = @{
         NSParagraphStyleAttributeName: paragraphStyle,
         NSForegroundColorAttributeName: [UIColor colorWithWhite:0 alpha:0.9],
         NSFontAttributeName: [UIFont fontWithName:@"SFUIText-Regular" size:13]
    };
    
    _commentView.typingAttributes = titleAtrribute;
}

- (CGSize)intrinsicContentSize {
    return self.bounds.size;
}

#pragma - mark UITextView Delegates

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if([text isEqualToString:@"\n"]) {
        [_delegate userShouldChangeText:NO withText:textView.text];
        return NO;
    } else {
        [_delegate userShouldChangeText:textView.text.length + (text.length - range.length) <= 200 withText:textView.text];
        return textView.text.length + (text.length - range.length) <= 200;
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(userDidEnterText)]) {
        [_delegate userDidEnterText];
    }
    _characterLimit = [NSNumber numberWithInt:200 - (int)textView.text.length];
    _charLimitLabel.text = [NSString stringWithFormat:@"%i characters left", [_characterLimit intValue]];
    
    CGFloat maxHeight = CGFLOAT_MAX;
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, CGFLOAT_MAX)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), fminf(newSize.height, maxHeight));
    
    //change the row height
    if (newFrame.size.height < 90) {
        textView.frame = newFrame;
        [textView setFrame:newFrame];
        [textView sizeThatFits:newFrame.size];
        
        if (_currentTextViewSize.height != newFrame.size.height) {
            [self setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + newFrame.size.height - _currentTextViewSize.height)];
            [self sizeThatFits:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height + newFrame.size.height - _currentTextViewSize.height).size];
            [self invalidateIntrinsicContentSize];
        }
        _currentTextViewSize = newFrame.size;
    } else {
    }
    [UIView setAnimationsEnabled:YES];
}

- (void)panThisView:(UIPanGestureRecognizer *)recognizer {
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPoint = [recognizer translationInView:_frontView];
            self.startingRightLayoutConstraintConstant = _frontViewTrailingConstraint.constant;
            break;
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPoint = [recognizer translationInView:_frontView];
            CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
            BOOL panningLeft = NO;
            if (currentPoint.x < self.panStartPoint.x) {
                panningLeft = YES;
            }
            
            if (self.startingRightLayoutConstraintConstant == 0) {
                //The cell was closed and is now opening
                if (!panningLeft) {
                    CGFloat constant = MAX(-deltaX, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        _frontViewTrailingConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(-deltaX, _discardView.frame.size.width);
                    if (constant == _discardView.frame.size.width) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        _frontViewTrailingConstraint.constant = constant;
                    }
                }
            } else {
                //The cell was at least partially open.
                CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
                if (!panningLeft) {
                    CGFloat constant = MAX(adjustment, 0);
                    if (constant == 0) {
                        [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:NO];
                    } else {
                        _frontViewTrailingConstraint.constant = constant;
                    }
                } else {
                    CGFloat constant = MIN(adjustment, _discardView.frame.size.width);
                    if (constant == _discardView.frame.size.width) {
                        [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:NO];
                    } else {
                        _frontViewTrailingConstraint.constant = constant;
                    }
                }
            }
            
            _frontViewLeadingConstraint.constant = -_frontViewTrailingConstraint.constant;
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was opening
                CGFloat halfOfButtonOne = CGRectGetWidth(_discardView.frame)/4;
                if (_frontViewTrailingConstraint.constant >= halfOfButtonOne) {
                    //Open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Re-close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            } else {
                //Cell was closing
                CGFloat buttonOnePlusHalfOfButton2 = CGRectGetWidth(_discardView.frame)/1.1;
                if (_frontViewTrailingConstraint.constant >= buttonOnePlusHalfOfButton2) {
                    //Re-open all the way
                    [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
                } else {
                    //Close
                    [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
                }
            }
            break;
        case UIGestureRecognizerStateCancelled:
            if (self.startingRightLayoutConstraintConstant == 0) {
                //Cell was closed - reset everything to 0
                [self resetConstraintContstantsToZero:YES notifyDelegateDidClose:YES];
            } else {
                //Cell was open - reset to the open state
                [self setConstraintsToShowAllButtons:YES notifyDelegateDidOpen:YES];
            }
            break;
        default:
            break;
    }
}

- (void)resetConstraintContstantsToZero:(BOOL)animated notifyDelegateDidClose:(BOOL)endEditing {
    if (self.startingRightLayoutConstraintConstant == 0 && _frontViewTrailingConstraint.constant == 0) {
        //Already all the way closed, no bounce necessary
        return;
    }
    
    _frontViewTrailingConstraint.constant = -kBounceValue;
    _frontViewLeadingConstraint.constant = kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self->_frontViewTrailingConstraint.constant = 0;
        self->_frontViewLeadingConstraint.constant = 0;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self->_frontViewTrailingConstraint.constant;
        }];
    }];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated notifyDelegateDidOpen:(BOOL)notifyDelegate {
    if (self.startingRightLayoutConstraintConstant ==  _discardView.frame.size.width &&
        _frontViewTrailingConstraint.constant ==  _discardView.frame.size.width) {
        return;
    }
    
    _frontViewLeadingConstraint.constant = -_discardView.frame.size.width - kBounceValue;
    _frontViewTrailingConstraint.constant = _discardView.frame.size.width + kBounceValue;
    
    [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
        self->_frontViewLeadingConstraint.constant = -self->_discardView.frame.size.width;
        self->_frontViewTrailingConstraint.constant = self->_discardView.frame.size.width;
        
        [self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
            self.startingRightLayoutConstraintConstant = self->_frontViewTrailingConstraint.constant;
        }];
    }];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion {
    float duration = 0;
    if (animated) {
        duration = 0.15;
    }
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self layoutIfNeeded];
    } completion:completion];
}

@end
