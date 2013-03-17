//
//  DCTCoordinate.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTCoordinate.h"

@implementation DCTCoordinate

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate {
	self = [self init];
	if (!self) return nil;
	_coordinate = coordinate;
	return self;
}

@end
