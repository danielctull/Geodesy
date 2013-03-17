//
//  DCTCoordinate.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTCoordinate.h"

@implementation DCTCoordinate

- (id)initWithLatitude:(double)latitude longitude:(double)longitude {
	self = [self init];
	if (!self) return nil;
	_latitude = latitude;
	_longitude = longitude;
	return self;
}

@end
