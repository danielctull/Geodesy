//
//  DCTOSGB36ToGridRefTransformerTests.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTOSGB36ToGridRefTransformerTests.h"
#import <Geodesy/Geodesy.h>

@implementation DCTOSGB36ToGridRefTransformerTests

- (void)testTransform {
	GDYCoordinate *OSGB36Coordinate = [[GDYCoordinate alloc] initWithLatitude:52.657568 longitude:1.717908 coordinateSystem:[GDYCoordinateSystem OSGB36CoordinateSystem]];
	GDYOSGridReference *gridReference = [[GDYOSGridReference alloc] initWithCoordinate:OSGB36Coordinate];
	XCTAssertTrue(gridReference.easting > 651400 && gridReference.easting < 651410, @"%@ should be between 65140 and 65141", @(gridReference.easting));
	XCTAssertTrue(gridReference.northing > 313170 && gridReference.northing < 313180, @"%@ should be between 313170 and 313180", @(gridReference.northing));
}

- (void)testReverseTransform {
	GDYOSGridReference *gridReference = [[GDYOSGridReference alloc] initWithEasting:651409 northing:313177];
	GDYCoordinate *OSGB36Coordinate = [gridReference convertToCoordinateSystem:[GDYCoordinateSystem OSGB36CoordinateSystem]];
	XCTAssertTrue(OSGB36Coordinate.latitude > 52.6575 && OSGB36Coordinate.latitude < 52.6576, @"%@ should be between 52.6575 and 52.6576", @(OSGB36Coordinate.latitude));
	XCTAssertTrue(OSGB36Coordinate.longitude > 1.7179 && OSGB36Coordinate.longitude < 1.7180, @"%@ should be between 1.7179 and 1.7180", @(OSGB36Coordinate.longitude));
}

@end
