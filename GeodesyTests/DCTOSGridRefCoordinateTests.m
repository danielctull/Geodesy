//
//  DCTOSGridRefCoordinateTests.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTOSGridRefCoordinateTests.h"
#import <Geodesy/Geodesy.h>

@implementation DCTOSGridRefCoordinateTests

- (void)testNormalizeGridReference {
	GDYOSGridReference *coordinate = [[GDYOSGridReference alloc] initWithGridReference:@"TG 51409 13177"];
	XCTAssertTrue([coordinate.gridSquareLetters isEqualToString:@"TG"], @"%@ should be TG", coordinate.gridSquareLetters);
	XCTAssertTrue(coordinate.easting == 651409, @"%@ should equal 651409", @(coordinate.easting));
	XCTAssertTrue(coordinate.northing == 313177, @"%@ should equal 313177", @(coordinate.easting));
	
	coordinate = [[GDYOSGridReference alloc] initWithGridReference:@"TG51"];
	XCTAssertTrue([coordinate.gridSquareLetters isEqualToString:@"TG"], @"%@ should be TG", coordinate.gridSquareLetters);
	XCTAssertTrue(coordinate.easting == 655000, @"%@ should equal 655000", @(coordinate.easting));
	XCTAssertTrue(coordinate.northing == 315000, @"%@ should equal 315000", @(coordinate.easting));
}

- (void)testGridLetterGeneration {
	GDYOSGridReference *coordinate = [[GDYOSGridReference alloc] initWithEasting:651409 northing:313177];
	XCTAssertTrue([coordinate.gridSquareLetters isEqualToString:@"TG"], @"%@ should be TG", coordinate.gridSquareLetters);
}

- (void)testGridReferenceGeneration {
	GDYOSGridReference *coordinate = [[GDYOSGridReference alloc] initWithEasting:651409 northing:313177];
	NSString *gridReference = [coordinate gridReferenceWithNumberOfFigures:2];
	NSString *expectedGridReference = @"TG 5 1";
	XCTAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:4];
	expectedGridReference = @"TG 51 13";
	XCTAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:6];
	expectedGridReference = @"TG 514 132";
	XCTAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:8];
	expectedGridReference = @"TG 5141 1318";
	XCTAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:10];
	expectedGridReference = @"TG 51409 13177";
	XCTAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
}

@end
