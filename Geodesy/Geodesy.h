//
//  Geodesy.h
//  Geodesy
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import Foundation;
#import "GDYOSGridReference.h"
#import "GDYCoordinate.h"

@interface Geodesy : NSObject
+ (double)convertRadiansToDegrees:(double)radians;
+ (double)convertDegreesToRadians:(double)degrees;
@end
