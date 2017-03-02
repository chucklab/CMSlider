//
//  CMLineSlider.m
//  CMSlider
//
//  Created by Chuck MA on 02/22/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "CMLineSlider.h"

#pragma mark - Util macros
#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                         blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                        alpha:1.0]

@interface CMLineSlider ()
@property (nonatomic, assign) CGPoint initialTouchLocation;
@property (nonatomic, assign) BOOL draggable;
@end

IB_DESIGNABLE
@implementation CMLineSlider

#pragma mark - Initials
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    // Line
    self.lineXInset = 30.0;
    
    // Critical points
    self.criticalPoints = 4;
    
    // Toggle
    self.togglePosition = 0.5;
    
    // Initial values
    self.initialTouchLocation = CGPointMake(0.0, 0.0);
    self.draggable = NO;
    
    return self;
}

#pragma mark - Setters & Getters
// Line
- (void)setLineXInset:(double)lineXInset {
    _lineXInset = lineXInset;
    [self setNeedsDisplay];
}

// Private
- (void)setInitialTouchLocation:(CGPoint)initialTouchLocation {
    _initialTouchLocation = initialTouchLocation;
    [self setNeedsDisplay];
}

- (void)setDraggable:(BOOL)draggable {
    _draggable = draggable;
    [self setNeedsDisplay];
}

#pragma mark - Main draw
- (void)drawRect:(CGRect)rect {
    // Background layer
    UIBezierPath *backgroundLayerPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.height * 0.5];
    [self.layerBackgroundColor setFill];
    [backgroundLayerPath fill];
    
    // Line
    UIBezierPath *linePath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(self.lineXInset, (self.bounds.size.height - self.lineWidth) * 0.5, self.bounds.size.width - self.lineXInset * 2, self.lineWidth) cornerRadius:self.lineWidth * 0.5];
    [self.lineColor setFill];
    [linePath fill];
    
    // Toggle
    CGRect position = [self calcToggleFrame];
    UIBezierPath *togglePath = [UIBezierPath bezierPathWithRoundedRect:position cornerRadius:self.toggleRadius];
    [self.toggleColor setFill];
    [togglePath fill];
    
    // Critical points
    for (int i=0; i<self.criticalPoints; i++) {
        double xPositionSegments = (self.bounds.size.width - self.lineXInset * 2) / (self.criticalPoints - 1);
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xPositionSegments * i + self.lineXInset, self.bounds.size.height * 0.5) radius:1.0 startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
        [dotPath fill];
    }
    
    // Strips
    [self.stripColor setFill];
    for (int i=0; i<3; i++) {
        UIBezierPath *stripPath = [UIBezierPath bezierPathWithRect:CGRectMake(position.origin.x + position.size.width * 0.5 - self.stripDistance + i * self.stripDistance, position.origin.y + position.size.height * 0.5 - self.toggleHeight / 6, 1.0, self.toggleHeight / 3)];
        [stripPath fill];
    }
}

#pragma mark - Util calculate
- (CGRect)calcToggleFrame {
    double xPostion = (self.bounds.size.width - 2 * self.lineXInset) * self.togglePosition - (self.toggleWidth * 0.5) + self.lineXInset;
    double yPosition = self.bounds.size.height * 0.5 - self.toggleHeight * 0.5;
    CGRect toggleFrame = CGRectMake(xPostion, yPosition, self.toggleWidth, self.toggleHeight);
    return toggleFrame;
}

- (void)snapToPosition {
    int index = round(self.togglePosition * 100 / (100.0 / (self.criticalPoints - 1)));
    self.selectedItemIndex = index % self.criticalPoints;
    self.togglePosition = index * (100.0 / (self.criticalPoints - 1)) / 100;
}

#pragma mark - Handle touches
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *firstTouch = [touches anyObject];
    if (firstTouch == nil) {
        return;
    }
    
    CGRect toggleFrame = [self calcToggleFrame];
    CGPoint location = [firstTouch locationInView:self];
    if (CGRectContainsPoint(toggleFrame, location)) {
        self.draggable = YES;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *firstTouch = [touches anyObject];
    if (firstTouch == nil) {
        return;
    }
    
    if (!self.draggable) {
        return;
    }
    
    CGPoint nowLocation = [firstTouch locationInView:self];
    double percentage = nowLocation.x / self.bounds.size.width;
    if (percentage > 0.0 + 0.0000001 && percentage < 1.0 - 0.0000001) {
        self.togglePosition = percentage;
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.draggable = NO;
    [self snapToPosition];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.draggable = NO;
}

@end
