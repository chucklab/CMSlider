//
//  Utils.h
//  CMSliderDemo
//
//  Created by Chuck MA on 02/24/2017.
//  Copyright © 2017 Chuck's Lab. All rights reserved.
//


#define UIColorFromRGB(rgbValue) \
        [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                        green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
                         blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
                        alpha:1.0]

#define IsNullString(string)        (string == nil || string == (id)[NSNull null] || string.length == 0)
