//
//  GDYCoordinate.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "GDYCoordinate.h"

@implementation GDYCoordinate

- (id)initWithLatitude:(double)latitude longitude:(double)longitude{
	GDYDatum *datum = [[GDYDatum alloc] initWithType:GDYDatumTypeWGS84];
	GDYEllipsoid *ellipsoid = [GDYEllipsoid WGS84Ellipsoid];
	GDYCoordinateSystem *coordinateSystem = [[GDYCoordinateSystem alloc] initWithDatum:datum ellipsoid:ellipsoid];
	return [self initWithLatitude:latitude longitude:longitude coordinateSystem:coordinateSystem];
}

- (id)initWithLatitude:(double)latitude longitude:(double)longitude coordinateSystem:(GDYCoordinateSystem *)coordinateSystem {
	self = [self init];
	if (!self) return nil;
	_latitude = latitude;
	_longitude = longitude;
	_coordinateSystem = coordinateSystem;
	return self;
}

- (GDYCoordinate *)convertToSystem:(GDYCoordinateSystem *)coordinateSystem {
	return [self.coordinateSystem convertCoordinate:self toSystem:coordinateSystem];
}

@end
