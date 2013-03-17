//
//  DCTOSGridRefCoordinateTests.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTOSGridRefCoordinateTests.h"
#import <DCTCoordinateTransformers/DCTOSGridRefCoordinate.h>

@implementation DCTOSGridRefCoordinateTests

- (void)testNormalizeGridReference {
	
	DCTOSGridRefCoordinate *coordinate = [[DCTOSGridRefCoordinate alloc] initWithGridReference:@"TG 51409 13177"];
	
	NSString *gridReference = [coordinate gridReferenceWithNumberOfFigures:2];
	NSString *expectedGridReference = @"TG 5 1";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:4];
	expectedGridReference = @"TG 51 13";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:6];
	expectedGridReference = @"TG 514 132";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:8];
	expectedGridReference = @"TG 5141 1318";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:10];
	expectedGridReference = @"TG 51409 13177";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
}

- (void)testGridLetterGeneration {
	DCTOSGridRefCoordinate *coordinate = [[DCTOSGridRefCoordinate alloc] initWithEasting:651409 northing:313177];
	NSString *nationalGridSquare = [coordinate nationalGridSquare];
	STAssertTrue([nationalGridSquare isEqualToString:@"TG"], @"%@ should be TG", nationalGridSquare);
}

- (void)testGridReferenceGeneration {
	DCTOSGridRefCoordinate *coordinate = [[DCTOSGridRefCoordinate alloc] initWithEasting:651409 northing:313177];
	NSString *gridReference = [coordinate gridReferenceWithNumberOfFigures:2];
	NSString *expectedGridReference = @"TG 5 1";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:4];
	expectedGridReference = @"TG 51 13";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:6];
	expectedGridReference = @"TG 514 132";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:8];
	expectedGridReference = @"TG 5141 1318";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
	
	gridReference = [coordinate gridReferenceWithNumberOfFigures:10];
	expectedGridReference = @"TG 51409 13177";
	STAssertTrue([gridReference isEqualToString:expectedGridReference], @"%@ should be %@", gridReference, expectedGridReference);
}

@end
