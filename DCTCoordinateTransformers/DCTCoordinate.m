//
//  DCTCoordinate.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTCoordinate.h"

@implementation DCTCoordinate

- (id)initWithLatitude:(double)latitude longitude:(double)longitude{
	GDYDatum *datum = [[GDYDatum alloc] initWithType:GDYDatumTypeWGS84];
	GDYEllipsoid *ellipsoid = [GDYEllipsoid WGS84Ellipsoid];
	return [self initWithLatitude:latitude longitude:longitude datum:datum ellipsoid:ellipsoid];
}

- (id)initWithLatitude:(double)latitude longitude:(double)longitude datum:(GDYDatum *)datum ellipsoid:(GDYEllipsoid *)ellipsoid {
	self = [self init];
	if (!self) return nil;
	_latitude = latitude;
	_longitude = longitude;
	return self;
}


@end
