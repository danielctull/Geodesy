//
//  DCTWGS84ToOSGB36TransformerTests.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTWGS84ToOSGB36TransformerTests.h"
#import <Geodesy/Geodesy.h>

@implementation DCTWGS84ToOSGB36TransformerTests

- (void)testTransform {
	GDYCoordinate *WGS84Coordinate = [[GDYCoordinate alloc] initWithLatitude:52.657977 longitude:1.716038];
	GDYCoordinate *OSGB36Coordinate = [WGS84Coordinate convertToCoordinateSystem:[GDYCoordinateSystem OSGB36CoordinateSystem]];
	XCTAssertTrue(OSGB36Coordinate.latitude > 52.6575 && OSGB36Coordinate.latitude < 52.6576, @"%@ should be between 52.6575 and 52.6576", @(OSGB36Coordinate.latitude));
	XCTAssertTrue(OSGB36Coordinate.longitude > 1.7179 && OSGB36Coordinate.longitude < 1.7180, @"%@ should be between 1.7179 and 1.7180", @(OSGB36Coordinate.longitude));
}

- (void)testReverseTransform {
	
	
	GDYCoordinate *OSGB36Coordinate = [[GDYCoordinate alloc] initWithLatitude:52.657568
																	longitude:1.717908
															 coordinateSystem:[GDYCoordinateSystem OSGB36CoordinateSystem]];
	
	GDYCoordinate *WGS84Coordinate = [OSGB36Coordinate convertToCoordinateSystem:[GDYCoordinateSystem WGS84CoordinateSystem]];
	
	XCTAssertTrue(WGS84Coordinate.latitude > 52.6579 && WGS84Coordinate.latitude < 52.6580, @"%@ should be between 52.6579 and 52.6580", @(WGS84Coordinate.latitude));
	XCTAssertTrue(WGS84Coordinate.longitude > 1.7160 && WGS84Coordinate.longitude < 1.7161, @"%@ should be between 1.7179 and 1.7180", @(WGS84Coordinate.longitude));
}

@end
