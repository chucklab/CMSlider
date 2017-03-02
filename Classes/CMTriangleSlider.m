//
//  CMTriangleSlider.m
//  CMSlider
//
//  Created by Chuck MA on 02/24/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "CMTriangleSlider.h"
#import "CMClosestPoint.h"

#pragma mark - Util macros
#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                         blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                        alpha:1.0]

#define CriticalPoints (3)

@interface CMTriangleSlider ()
@property (nonatomic, assign) CGPoint initialTouchLocation;
@property (nonatomic, assign) BOOL draggable;

@property (nonatomic, assign) CGPoint criticalPointOne;
@property (nonatomic, assign) CGPoint criticalPointTwo;
@property (nonatomic, assign) CGPoint criticalPointThree;
@end

IB_DESIGNABLE
@implementation CMTriangleSlider

#pragma mark - Initials
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self == nil) {
        return nil;
    }
    
    // Critical points
    self.criticalPoints = CriticalPoints;
    
    // Toggle
    self.togglePosition = 0.5;
    
    // Background layer
    self.innerTriangleColor = UIColorFromRGB(0xffffff);
    
    // Initial values
    self.initialTouchLocation = CGPointMake(0.0, 0.0);
    self.draggable = NO;
    
    return self;
}

#pragma mark - Setters & Getters
// Critical points
- (void)setCriticalPoints:(int)criticalPoints {
    super.criticalPoints = CriticalPoints;
    [self setNeedsDisplay];
}

// Background layer
- (void)setInnerTriangleColor:(UIColor *)innerTriangleColor {
    _innerTriangleColor = innerTriangleColor;
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
    double radius = 20.0;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.bounds.size.width * 0.5, 0.0);
    CGPathAddArcToPoint(path, NULL, self.bounds.size.width, self.bounds.size.height, 0.0, self.bounds.size.height, radius);
    CGPathAddArcToPoint(path, NULL, 0, self.bounds.size.height, self.bounds.size.width * 0.5, 0.0, radius);
    CGPathAddArcToPoint(path, NULL, self.bounds.size.width * 0.5, 0.0, self.bounds.size.width, self.bounds.size.height, radius);
    CGPathCloseSubpath(path);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
    [self.layerBackgroundColor setFill];
    [bezierPath fill];
    
    // Inner triangle
    radius = 0.0;
    double d = MAX(self.toggleWidth, self.toggleHeight) + 10.0;
    double a = atan(self.bounds.size.height / (self.bounds.size.width * 0.5));
    double b = M_PI * 0.5 - a;
    CGRect boundRect = CGRectMake(d / sin(a) + d / tan(a), d / sin(b), (self.bounds.size.width * 0.5 - (d / sin(a) + d / tan(a))) * 2, self.bounds.size.height - d - d / sin(b));
    CGPoint pointOne = CGPointMake(boundRect.origin.x + boundRect.size.width * 0.5, boundRect.origin.y);
    CGPoint pointTwo = CGPointMake(boundRect.origin.x + boundRect.size.width, boundRect.origin.y + boundRect.size.height);
    CGPoint pointThree = CGPointMake(boundRect.origin.x, boundRect.origin.y + boundRect.size.height);
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, pointOne.x, pointOne.y);
    CGPathAddArcToPoint(path, NULL, pointTwo.x, pointTwo.y, pointThree.x, pointThree.y, radius);
    CGPathAddArcToPoint(path, NULL, pointThree.x, pointThree.y, pointOne.x, pointOne.y, radius);
    CGPathAddArcToPoint(path, NULL, pointOne.x, pointOne.y, pointTwo.x, pointTwo.y, radius);
    CGPathCloseSubpath(path);
    
    UIBezierPath *innerTrianglePath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
    [self.innerTriangleColor setFill];
    [innerTrianglePath fill];
    
    // Line
    d *= 0.5;
    boundRect = CGRectMake(d / sin(a) + d / tan(a), d / sin(b), (self.bounds.size.width * 0.5 - (d / sin(a) + d / tan(a))) * 2, self.bounds.size.height - d - d / sin(b));
    pointOne = CGPointMake(boundRect.origin.x + boundRect.size.width * 0.5, boundRect.origin.y);
    pointTwo = CGPointMake(boundRect.origin.x + boundRect.size.width, boundRect.origin.y + boundRect.size.height);
    pointThree = CGPointMake(boundRect.origin.x, boundRect.origin.y + boundRect.size.height);
    path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, pointOne.x, pointOne.y);
    CGPathAddArcToPoint(path, NULL, pointTwo.x, pointTwo.y, pointThree.x, pointThree.y, radius);
    CGPathAddArcToPoint(path, NULL, pointThree.x, pointThree.y, pointOne.x, pointOne.y, radius);
    CGPathAddArcToPoint(path, NULL, pointOne.x, pointOne.y, pointTwo.x, pointTwo.y, radius);
    CGPathCloseSubpath(path);
    
    UIBezierPath *linePath = [UIBezierPath bezierPathWithCGPath:path];
    CGPathRelease(path);
    [self.lineColor setStroke];
    [linePath stroke];
    
    // Critical points
    double xCenter = boundRect.origin.x + boundRect.size.width * 0.5;
    double yCenter = boundRect.origin.y;
    self.criticalPointOne = CGPointMake(xCenter, yCenter);
    double dotRadius = 1.0;
    UIBezierPath *dotPath = [UIBezierPath bezierPathWithArcCenter:self.criticalPointOne radius:dotRadius startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
    [self.toggleColor setFill];
    [dotPath fill];
    
    xCenter = boundRect.origin.x + boundRect.size.width;
    yCenter = boundRect.origin.y + boundRect.size.height;
    self.criticalPointTwo = CGPointMake(xCenter, yCenter);
    dotPath = [UIBezierPath bezierPathWithArcCenter:self.criticalPointTwo radius:dotRadius startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
    [dotPath fill];
    
    xCenter = boundRect.origin.x;
    yCenter = boundRect.origin.y + boundRect.size.height;
    self.criticalPointThree = CGPointMake(xCenter, yCenter);
    dotPath = [UIBezierPath bezierPathWithArcCenter:self.criticalPointThree radius:dotRadius startAngle:0.0 endAngle:M_PI * 2 clockwise:YES];
    [dotPath fill];
    
    // Toggle
    CGRect position = [self calcToggleFrame];
    UIBezierPath *togglePath = [UIBezierPath bezierPathWithRoundedRect:position cornerRadius:self.toggleRadius];
    [self.toggleColor setFill];
    [togglePath fill];
    
    // Strips
    [self.stripColor setFill];
    for (int i=0; i<3; i++) {
        UIBezierPath *stripPath = [UIBezierPath bezierPathWithRect:CGRectMake(position.origin.x + position.size.width * 0.5 - self.stripDistance + i * self.stripDistance, position.origin.y + position.size.height * 0.5 - self.toggleHeight / 6, 1.0, self.toggleHeight / 3)];
        [stripPath fill];
    }
}

#pragma mark - Util calculate
- (CGRect)calcToggleFrame {
    double xCenter = 0.0;
    double yCenter = 0.0;
    
    if (self.togglePosition > 0.0 && self.togglePosition < 1/3.0) { // First line segment
        double p = self.togglePosition;
        p /= 1/3.0;
        double dx = self.criticalPointTwo.x - self.criticalPointOne.x;
        double dy = self.criticalPointTwo.y - self.criticalPointOne.y;
        dx *= p;
        dy *= p;
        
        xCenter = self.criticalPointOne.x + dx;
        yCenter = self.criticalPointOne.y + dy;
    } else if (self.togglePosition > 1/3.0 && self.togglePosition < 2/3.0) { // Second line segment
        double p = self.togglePosition - 1/3.0;
        p /= 1/3.0;
        double dx = self.criticalPointThree.x - self.criticalPointTwo.x;
        double dy = self.criticalPointThree.y - self.criticalPointTwo.y;
        dx *= p;
        dy *= p;
        
        xCenter = self.criticalPointTwo.x + dx;
        yCenter = self.criticalPointTwo.y + dy;
    } else if (self.togglePosition > 2/3.0 && self.togglePosition < 1.0) { // Third line segment
        double p = self.togglePosition - 2/3.0;
        p /= 1/3.0;
        double dx = self.criticalPointOne.x - self.criticalPointThree.x;
        double dy = self.criticalPointOne.y - self.criticalPointThree.y;
        dx *= p;
        dy *= p;
        
        xCenter = self.criticalPointThree.x + dx;
        yCenter = self.criticalPointThree.y + dy;
    } else if (self.togglePosition > -0.0000001 && self.togglePosition < 0.0000001) { // Point One
        xCenter = self.criticalPointOne.x;
        yCenter = self.criticalPointOne.y;
    } else if (self.togglePosition > 1 / 3.0 -0.0000001 && self.togglePosition < 1 / 3.0 + 0.0000001) { // Point Two
        xCenter = self.criticalPointTwo.x;
        yCenter = self.criticalPointTwo.y;
    } else if (self.togglePosition > 2 / 3.0 -0.0000001 && self.togglePosition < 2 / 3.0 + 0.0000001) { // Point Three
        xCenter = self.criticalPointThree.x;
        yCenter = self.criticalPointThree.y;
    } else {
        xCenter = self.criticalPointOne.x;
        yCenter = self.criticalPointOne.y;
    }
    
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
    UITouch *firstTouch = [touches anyObject];
    if (firstTouch == nil) {
        return;
    }
    
    if (!self.draggable) {
        return;
    }
    
    CGPoint nowLocation = [firstTouch locationInView:self];
    
    CMClosestPoint *closestPointOne = [CMClosestPoint closestPointAtLineSegmentWithPointOne:self.criticalPointOne pointTwo:self.criticalPointTwo fromPoint:nowLocation];
    CMClosestPoint *closestPointTwo = [CMClosestPoint closestPointAtLineSegmentWithPointOne:self.criticalPointTwo pointTwo:self.criticalPointThree fromPoint:nowLocation];
    CMClosestPoint *closestPointThree = [CMClosestPoint closestPointAtLineSegmentWithPointOne:self.criticalPointThree pointTwo:self.criticalPointOne fromPoint:nowLocation];
    
    double percentage = 0.0;
    double minDistance = MIN(MIN(closestPointOne.distance, closestPointTwo.distance), closestPointThree.distance);
    if (closestPointOne.distance < minDistance + 0.0000001 && closestPointOne.distance > minDistance - 0.0000001) {
        percentage = (closestPointOne.closestPoint.x - self.criticalPointOne.x) / (self.criticalPointTwo.x - self.criticalPointOne.x);
        percentage = fabs(percentage);
        percentage *= 1 / 3.0;
        if (percentage < 0.0000001) {
            percentage = 0.0;
        }
        if (percentage > 1/3.0 - 0.0000001) {
            percentage = 1/3.0;
        }
    } else if (closestPointTwo.distance < minDistance + 0.0000001 && closestPointTwo.distance > minDistance - 0.0000001) {
        percentage = (closestPointTwo.closestPoint.x - self.criticalPointTwo.x) / (self.criticalPointThree.x - self.criticalPointTwo.x);
        percentage = fabs(percentage);
        percentage *= 1 / 3.0;
        if (percentage < 0.0000001) {
            percentage = 0.0;
        }
        if (percentage > 1/3.0 - 0.0000001) {
            percentage = 1/3.0;
        }
        percentage += 1 / 3.0;
    } else if (closestPointThree.distance < minDistance + 0.0000001 && closestPointThree.distance > minDistance - 0.0000001) {
        percentage = (closestPointThree.closestPoint.x - self.criticalPointThree.x) / (self.criticalPointOne.x - self.criticalPointThree.x);
        percentage = fabs(percentage);
        percentage *= 1 / 3.0;
        if (percentage < 0.0000001) {
            percentage = 0.0;
        }
        if (percentage > 1/3.0 - 0.0000001) {
            percentage = 1/3.0;
        }
        percentage += 2 / 3.0;
    }
    
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
