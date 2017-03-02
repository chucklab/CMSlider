# CMSlider #
A collection of draggable controls, have fun.

![Screenshot_01-w100](Screenshots/Screenshot_01.PNG)
![Screenshot_02-w100](Screenshots/Screenshot_02.PNG)
![Screenshot_03-w100](Screenshots/Screenshot_03.PNG)
![Screenshot_04-w100](Screenshots/Screenshot_04.PNG)

![LineSliderDemo-w100](Screenshots/LineSliderDemo.gif)

![TraingleSliderDemo-w100](Screenshots/TraingleSliderDemo.gif)

![CircleSliderDemo-w100](Screenshots/CircleSliderDemo.gif)

# Installation #
## Cocoapods: ##

1. Add `pod 'CMSlider', '~> 0.0.1'` to your Podfile.
2. Run `pod install` or `pod update`.

# Usage #

```objc
#import <CMLineSlider.h>
#import <CMTriangleSlider.h>
#import <CMCircleSlider.h>

self.lineSlider = [[CMLineSlider alloc] init];
[self.lineSlider addTarget:self action:@selector(lineSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

self.triangleSlider = [[CMTriangleSlider alloc] init];
[self.triangleSlider addTarget:self action:@selector(triangleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];

self.circleSlider = [[CMCircleSlider alloc] init];
[self.circleSlider addTarget:self action:@selector(circleSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
```

# Requirements #
This library requires a deployment target of iOS 6.0 or greater.

# LICENSE #
CMSlider is provided under the MIT license. See LICENSE file for details.

