//
//  GDYCoordinateTests.m
//  Geodesy
//
//  Created by Daniel Tull on 30/03/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "GDYCoordinateTests.h"
#import <Geodesy/Geodesy.h>

@implementation GDYCoordinateTests

- (void)testGridLetterGeneration {
	GDYCoordinate *fromCoordinate = [[GDYCoordinate alloc] initWithLatitude:50.405018 longitude:8.437500];
	GDYCoordinate *toCoordinate = [[GDYCoordinate alloc] initWithLatitude:51.339802 longitude:12.403340];

	double expectedBearing = 67.9875;
	double bearing = floor([fromCoordinate initialHeadingToCoordinate:toCoordinate]*10000)/10000;
	STAssertTrue(bearing == expectedBearing, @"%@ should be %@", @(bearing), @(expectedBearing));

	double expectedDistance = 297; // in km
	double distance = floor([fromCoordinate distanceToCoordinate:toCoordinate]/1000); // returns metres
	STAssertTrue(distance == expectedDistance, @"%@ should be %@", @(distance), @(expectedDistance));
	
}

@end
