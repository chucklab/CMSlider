//
//  CMCircleSlider.m
//  CMSlider
//
//  Created by Chuck MA on 02/23/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "CMCircleSlider.h"

#pragma mark - Util macros
#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                         blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                        alpha:1.0]

@interface CMCircleSlider ()
@property (nonatomic, assign) CGPoint initialTouchLocation;
@property (nonatomic, assign) BOOL draggable;
@end

IB_DESIGNABLE
@implementation CMCircleSlider

#pragma mark - Initials
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    // Critical points
    self.criticalPoints = 5;
    
    // Toggle
    self.togglePosition = 0.5;
    
    // Background layer
    self.innerCircleColor = UIColorFromRGB(0xffffff);
    
    // Initial values
    self.initialTouchLocation = CGPointMake(0.0, 0.0);
    self.draggable = NO;
    
    return self;
}

#pragma mark - Setters & Getters
// Background layer
- (void)setInnerCircleColor:(UIColor *)innerCircleColor {
    _innerCircleColor = innerCircleColor;
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
    CGPoint circleCenter = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    double circleRadius = MIN(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    double innerCircleRadius = circleRadius * 0.5;
    double lineRadius = circleRadius * 0.75;
    
    // Background layer
    UIBezierPath *backgroundLayerPath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:circleRadius startAngle:-M_PI * 0.5 endAngle:M_PI * 1.5 clockwise:YES];
    [self.layerBackgroundColor setFill];
    [backgroundLayerPath fill];
    
    // Inner circle
    UIBezierPath *innerCirclePath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:innerCircleRadius startAngle:-M_PI * 0.5 endAngle:M_PI * 1.5 clockwise:YES];
    [self.innerCircleColor setFill];
    [innerCirclePath fill];
    
    // Line
    UIBezierPath *linePath = [UIBezierPath bezierPathWithArcCenter:circleCenter radius:lineRadius startAngle:-M_PI * 0.5 endAngle:M_PI * 1.5 clockwise:YES];
    [self.lineColor setStroke];
    [linePath stroke];
    
    // Toggle
    CGRect position = [self calcToggleFrame];
    UIBezierPath *togglePath = [UIBezierPath bezierPathWithRoundedRect:position cornerRadius:self.toggleRadius];
    [self.toggleColor setFill];
    [togglePath fill];
    
    // Critical points
    for (int i=0; i<self.criticalPoints; i++) {
        double aPositionSegments = M_PI * 2 / self.criticalPoints;
        double a = aPositionSegments * i - M_PI * 0.5;
        double xCenter = lineRadius * cos(a) + circleCenter.x;
        double yCenter = lineRadius * sin(a) + circleCenter.y;
        double dotRadius = 1.0;
        UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(xCenter, yCenter) radius:dotRadius startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
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
    CGPoint circleCenter = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    double circleRadius = MIN(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    double lineRadius = circleRadius * 0.75;
    
    double a = self.togglePosition * M_PI * 2 - M_PI * 0.5;
    
    double xCenter = lineRadius * cos(a) + circleCenter.x;
    double yCenter = lineRadius * sin(a) + circleCenter.y;
    
    CGRect toggleFrame = CGRectMake(xCenter - self.toggleWidth * 0.5, yCenter - self.toggleHeight * 0.5, self.toggleWidth, self.toggleHeight);
    return toggleFrame;
}

- (void)snapToPosition {
    int index = round(self.togglePosition * 100 / (100.0 / self.criticalPoints));
    self.selectedItemIndex = index % self.criticalPoints;
    self.togglePosition = index * (100.0 / self.criticalPoints) / 100;
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
    CGPoint circleCenter = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    UITouch *firstTouch = [touches anyObject];
    if (firstTouch == nil) {
        return;
    }
    
    if (!self.draggable) {
        return;
    }
    
    CGPoint nowLocation = [firstTouch locationInView:self];
    
    double offsetX = nowLocation.x - circleCenter.x;
    double offsetY = nowLocation.y - circleCenter.y;
    double a = atan(offsetY / offsetX);
    if (offsetX < 0) {
        a += M_PI;
    }
    double percentage = (a + M_PI * 0.5) / (M_PI * 2);
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
