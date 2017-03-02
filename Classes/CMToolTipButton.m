//
//  CMToolTipButton.m
//  CMSlider
//
//  Created by Chuck MA on 02/28/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "CMToolTipButton.h"

IB_DESIGNABLE
@implementation CMToolTipButton

- (instancetype)init {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    
    // Initial values
    self.pointHeight = 8.0;
    self.pointWidth = 8.0;
    self.cornerRadius = 6.0;
    self.tipColor = [UIColor blackColor];
    self.tipTextColor = [UIColor whiteColor];
    self.textTitle = @"";
    self.fontSize = 14.0;
    
    return self;
}

#pragma mark - Setters & Getters
- (void)setPointHeight:(double)pointHeight {
    _pointHeight = pointHeight;
    [self setNeedsDisplay];
}

- (void)setPointWidth:(double)pointWidth {
    _pointWidth = pointWidth;
    [self setNeedsDisplay];
}

- (void)setCornerRadius:(double)cornerRadius {
    _cornerRadius = cornerRadius;
    [self setNeedsDisplay];
}

- (void)setTipColor:(UIColor *)tipColor {
    _tipColor = tipColor;
    [self setNeedsDisplay];
}

- (void)setTipTextColor:(UIColor *)tipTextColor {
    _tipTextColor = tipTextColor;
    [self setNeedsDisplay];
}

- (void)setTextTitle:(NSString *)textTitle {
    _textTitle = textTitle;
    [self setTitle:textTitle forState:UIControlStateNormal];
}

- (void)setFontSize:(double)fontSize {
    _fontSize = fontSize;
    self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
}

#pragma mark - Overrides
- (CGSize)intrinsicContentSize {
    const double EdgeInset = 28.0;
    CGSize size = super.intrinsicContentSize;
    size = CGSizeMake(size.width + EdgeInset, size.height + EdgeInset);
    return size;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [self.tipColor setFill];
    CGRect inset = CGRectMake(self.bounds.origin.x, self.bounds.origin.y + self.pointHeight, self.bounds.size.width, self.bounds.size.height - self.pointHeight * 2);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:inset cornerRadius:self.cornerRadius];
    [path fill];
    
    UIBezierPath *point = [UIBezierPath bezierPath];
    [point moveToPoint:CGPointMake(self.bounds.size.width * 0.5 - self.pointWidth * 0.5, self.pointHeight)];
    [point addLineToPoint:CGPointMake(self.bounds.size.width * 0.5, 0.0)];
    [point addLineToPoint:CGPointMake(self.bounds.size.width * 0.5 + self.pointWidth * 0.5, self.pointHeight)];
    [point fill];
}

@end
