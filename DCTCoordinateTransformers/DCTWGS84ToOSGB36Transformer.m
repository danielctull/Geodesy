//
//  DCTWGS84ToOSGB36Transformer.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTWGS84ToOSGB36Transformer.h"
#import "DCTWGS84Coordinate.h"
#import "DCTOSGB36Coordinate.h"
#import "DCTEllipsoidConvertor.h"

@implementation DCTWGS84ToOSGB36Transformer

+ (Class)transformedValueClass {
	return [DCTOSGB36Coordinate class];
}

+ (BOOL)allowsReverseTransformation {
	return YES;
}

- (id)transformedValue:(id)value {
	NSAssert([value isKindOfClass:[DCTWGS84Coordinate class]], @"%@ should be a DCTWGS84Coordinate", value);
	
	DCTWGS84Coordinate *WGS84Coordinate = value;

	DCTCoordinate *coordinate = [[DCTCoordinate alloc] initWithLatitude:WGS84Coordinate.latitude
															  longitude:WGS84Coordinate.longitude];
	
	DCTCoordinate *transformedCoordinate = [DCTEllipsoidConvertor convertCoordinate:coordinate
																	  fromEllipsoid:[GDYEllipsoid WGS84Ellipsoid]
																		toEllipsoid:[GDYEllipsoid Airy1830Ellipsoid]
																usingDatumTransform:[DCTDatumTransform WGS84toOSGB36DatumTransform]];
	
	return [[DCTOSGB36Coordinate alloc] initWithLatitude:transformedCoordinate.latitude longitude:transformedCoordinate.longitude];
}

- (id)reverseTransformedValue:(id)value {
	NSAssert([value isKindOfClass:[DCTOSGB36Coordinate class]], @"%@ should be a DCTOSGB36Coordinate", value);
	
	DCTOSGB36Coordinate *OSGB36Coordinate = value;
	
	DCTCoordinate *coordinate = [[DCTCoordinate alloc] initWithLatitude:OSGB36Coordinate.latitude
															  longitude:OSGB36Coordinate.longitude];
	
	DCTCoordinate *transformedCoordinate = [DCTEllipsoidConvertor convertCoordinate:coordinate
																	  fromEllipsoid:[GDYEllipsoid Airy1830Ellipsoid]
																		toEllipsoid:[GDYEllipsoid WGS84Ellipsoid]
																usingDatumTransform:[DCTDatumTransform OSGB36toWGS84DatumTransform]];
	
	return [[DCTWGS84Coordinate alloc] initWithLatitude:transformedCoordinate.latitude longitude:transformedCoordinate.longitude];
}

- (double)radiansToDegrees:(double)radians {
	return radians * 180.0 / M_PI;
}

- (double)degreesToRadians:(double)degrees {
	return degrees / 180.0f * M_PI;
}

@end
