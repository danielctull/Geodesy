//
//  GDYCoordinate.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "GDYCoordinate.h"
#import "Geodesy.h"

@implementation GDYCoordinate

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude{
	GDYDatum *datum = [[GDYDatum alloc] initWithType:GDYDatumTypeWGS84];
	GDYEllipsoid *ellipsoid = [GDYEllipsoid WGS84Ellipsoid];
	GDYCoordinateSystem *coordinateSystem = [[GDYCoordinateSystem alloc] initWithDatum:datum ellipsoid:ellipsoid];
	return [self initWithLatitude:latitude longitude:longitude coordinateSystem:coordinateSystem];
}

- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude coordinateSystem:(GDYCoordinateSystem *)coordinateSystem {
	self = [self init];
	if (!self) return nil;
	_latitude = latitude;
	_longitude = longitude;
	_coordinateSystem = coordinateSystem;
	return self;
}

- (GDYCoordinate *)convertToCoordinateSystem:(GDYCoordinateSystem *)coordinateSystem {
	return [self.coordinateSystem convertCoordinate:self toSystem:coordinateSystem];
}

// http://www.movable-type.co.uk/scripts/latlong.html
- (double)initialHeadingToCoordinate:(GDYCoordinate *)coordinate {

	GDYCoordinateSystem *WGS84CoordinateSystem = [GDYCoordinateSystem WGS84CoordinateSystem];
	GDYCoordinate *fromCoordinate = [self convertToCoordinateSystem:WGS84CoordinateSystem];
	GDYCoordinate *toCoordinate = [coordinate convertToCoordinateSystem:WGS84CoordinateSystem];

	double fromLatitude = [Geodesy convertDegreesToRadians:fromCoordinate.latitude];
	double fromLongitude = [Geodesy convertDegreesToRadians:fromCoordinate.longitude];
	double toLatitude = [Geodesy convertDegreesToRadians:toCoordinate.latitude];
	double toLongitude = [Geodesy convertDegreesToRadians:toCoordinate.longitude];
	double dLongitude = toLongitude - fromLongitude;

	double y = sin(dLongitude) * cos(toLatitude);
	double x = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(dLongitude);
	return [Geodesy convertRadiansToDegrees:atan2(y, x)];
}

- (double)distanceToCoordinate:(GDYCoordinate *)coordinate {

	GDYCoordinateSystem *WGS84CoordinateSystem = [GDYCoordinateSystem WGS84CoordinateSystem];
	GDYCoordinate *fromCoordinate = [self convertToCoordinateSystem:WGS84CoordinateSystem];
	GDYCoordinate *toCoordinate = [coordinate convertToCoordinateSystem:WGS84CoordinateSystem];

	double r = 6371000; // Radius of Earth in meters
	double fromLatitude = [Geodesy convertDegreesToRadians:fromCoordinate.latitude];
	double fromLongitude = [Geodesy convertDegreesToRadians:fromCoordinate.longitude];
	double toLatitude = [Geodesy convertDegreesToRadians:toCoordinate.latitude];
	double toLongitude = [Geodesy convertDegreesToRadians:toCoordinate.longitude];
	double dLongitude = toLongitude - fromLongitude;
	double dLatitude =  toLatitude - fromLatitude;

	double sinDLatitude2 = sin(dLatitude/2);
	double sinDLongitude2 = sin(dLongitude/2);

	double a = sinDLatitude2 * sinDLatitude2 + sinDLongitude2 * sinDLongitude2 * cos(fromLatitude) * cos(toLatitude);
	double c = 2 * atan2(sqrt(a), sqrt(1-a));
	return r * c;
}

@end
