//
//  CMClosestPoint.m
//  CMSlider
//
//  Created by Chuck MA on 02/27/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//

#import "CMClosestPoint.h"

@implementation CMClosestPoint

+ (CMClosestPoint *)closestPointAtLineSegmentWithPointOne:(CGPoint)pt1 pointTwo:(CGPoint)pt2 fromPoint:(CGPoint)pt {
    CMClosestPoint *closestPoint = [[CMClosestPoint alloc] init];
    double maxY = MAX(pt1.y, pt2.y);
    double minY = MIN(pt1.y, pt2.y);
    double maxX = MAX(pt1.x, pt2.x);
    double minX = MIN(pt1.x, pt2.x);
    
    if ((pt2.x - pt1.x) < 0.0000001 && (pt2.x - pt1.x) > -0.0000001) { // k -> ∞
        double y = pt.y;
        double d = fabs(pt.x - pt1.x);
        if (y > maxY) {
            y = maxY;
            d = [CMClosestPoint distanceWithPointOne:pt pointTwo:CGPointMake(pt1.x, y)];
        } else if (y < minY) {
            y = minY;
            d = [CMClosestPoint distanceWithPointOne:pt pointTwo:CGPointMake(pt1.x, y)];
        }
        closestPoint.closestPoint = CGPointMake(pt1.x, y);
        closestPoint.distance = d;
        return closestPoint;
    }
    
    if ((pt2.y - pt1.y) < 0.0000001 && (pt2.y - pt1.y) > -0.0000001) { // k -> 0
        double x = pt.x;
        double d = fabs(pt.y - pt1.y);
        if (x > maxX) {
            x = maxX;
            d = [CMClosestPoint distanceWithPointOne:pt pointTwo:CGPointMake(x, pt1.y)];
        } else if (x < minX) {
            x = minX;
            d = [CMClosestPoint distanceWithPointOne:pt pointTwo:CGPointMake(x, pt1.y)];
        }
        closestPoint.closestPoint = CGPointMake(x, pt1.y);
        closestPoint.distance = d;
        return closestPoint;
    }
    
    // k != 0
    double k = (pt2.y - pt1.y) / (pt2.x - pt1.x);
    double x = (k * k *pt1.x + k * (pt.y - pt1.y) + pt.x) / (k * k + 1);
    double y = k * (x - pt1.x) + pt1.y;
    if (x < maxX && x > minX && y < maxY && y > minY) {
        closestPoint.closestPoint = CGPointMake(x, y);
        closestPoint.distance = [CMClosestPoint distanceWithPointOne:pt pointTwo:CGPointMake(x, y)];
        return closestPoint;
    }
    
    double d1 = [CMClosestPoint distanceWithPointOne:pt pointTwo:pt1];
    double d2 = [CMClosestPoint distanceWithPointOne:pt pointTwo:pt2];
    if (d1 < d2) {
        closestPoint.closestPoint = pt1;
        closestPoint.distance = [CMClosestPoint distanceWithPointOne:pt pointTwo:pt1];
        return closestPoint;
    } else {
        closestPoint.closestPoint = pt2;
        closestPoint.distance = [CMClosestPoint distanceWithPointOne:pt pointTwo:pt2];
        return closestPoint;
    }
}

+ (double)distanceWithPointOne:(CGPoint)pt1 pointTwo:(CGPoint)pt2 {
    double dx = pt2.x - pt1.x;
    double dy = pt2.y - pt1.y;
    double distance = sqrt((dx * dx + dy * dy));
    return distance;
}

@end
