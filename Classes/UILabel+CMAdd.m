//
//  UILabel+CMAdd.m
//  CMSlider
//
//  Created by Chuck MA on 03/02/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "UILabel+CMAdd.h"
#import <objc/runtime.h>

#define IsNullString(string)        (string == nil || string == (id)[NSNull null] || string.length == 0)

static void * const ToTextKey = @"ToText";

static const double FadeDuration = 0.2;

@interface UILabel () <CAAnimationDelegate>
@end

@implementation UILabel (CMAdd)

// Fade out and in with different text
- (void)fadeOutAndInFromText:(NSAttributedString *)fromText toText:(NSAttributedString *)toText {
    objc_setAssociatedObject(self, ToTextKey, toText, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    if (!IsNullString(fromText)) {
        [self fadeOutWithText:fromText];
    } else {
        [self fadeInWithText:toText];
    }
}

#pragma mark - Animations
- (void)fadeOutWithText:(NSAttributedString *)text {
    self.attributedText = text;
    self.layer.opacity = 0.0;
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeOutAnimation.duration = FadeDuration;
    fadeOutAnimation.fromValue = @(1.0);
    fadeOutAnimation.toValue = @(0.0);
    fadeOutAnimation.delegate = self;
    [self.layer addAnimation:fadeOutAnimation forKey:@"fadeOut"];
}

- (void)fadeInWithText:(NSAttributedString *)text {
    self.attributedText = text;
    self.layer.opacity = 1.0;
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeInAnimation.duration = FadeDuration;
    fadeInAnimation.fromValue = @(0.0);
    fadeInAnimation.toValue = @(1.0);
    [self.layer addAnimation:fadeInAnimation forKey:@"fadeIn"];
}

#pragma mark - CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSAttributedString *toText = objc_getAssociatedObject(self, ToTextKey);
    if (!IsNullString(toText)) {
        [self fadeInWithText:toText];
    }
}

@end
