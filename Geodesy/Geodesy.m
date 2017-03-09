//
//  Geodesy.m
//  Geodesy
//
//  Created by Daniel Tull on 25.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "Geodesy.h"

@implementation Geodesy

+ (double)convertRadiansToDegrees:(double)radians {
	return radians * 180.0 / M_PI;
}

+ (double)convertDegreesToRadians:(double)degrees {
	return degrees / 180.0 * M_PI;
}

@end
