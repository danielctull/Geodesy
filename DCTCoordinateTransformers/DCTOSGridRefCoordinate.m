//
//  DCTOSGridRefCoordinate.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTOSGridRefCoordinate.h"
#import "DCTOSGB36Coordinate.h"

@implementation DCTOSGridRefCoordinate

- (id)initWithGridReference:(NSString *)gridReference {
	self = [self init];
	if (!self) return nil;
	return self;
}

- (id)initWithEasting:(NSInteger)easting northing:(NSInteger)northing {
	self = [self init];
	if (!self) return nil;
	_easting = easting;
	_northing = northing;
	return self;
}

- (NSString *)gridReferenceWithNumberOfFigures:(NSInteger)numberOfFigures {
	
	if (numberOfFigures == 0) numberOfFigures = 10;
	
	NSInteger easting = round((self.easting % 100000) / pow(10, 5 - numberOfFigures/2));
	NSInteger northing = round((self.northing % 100000) / pow(10, 5 - numberOfFigures/2));
	return [NSString stringWithFormat:@"%@ %@ %@", [self nationalGridSquare], @(easting), @(northing)];
}

- (NSString *)nationalGridSquare {
	
	// get the 100km-grid indices
	NSInteger easting100k = floor(self.easting/100000);
	NSInteger northing100k = floor(self.northing/100000);
		
	if (easting100k < 0) return nil;
	if (easting100k > 6) return nil;
	if (northing100k < 0) return nil;
	if (northing100k > 12) return nil;
	
	// translate those into numeric equivalents of the grid letters
	NSInteger eastingLetterValue = (19 - northing100k) - ((19 - northing100k) % 5) + floor((easting100k + 10) / 5);
	NSInteger northingLetterValue = (((19 - northing100k) * 5) % 25) + (easting100k % 5);
	
	// compensate for skipped 'I' and build grid letter-pairs
	if (eastingLetterValue > 7) eastingLetterValue++;
	if (northingLetterValue > 7) northingLetterValue++;
	
	NSString *eastingLetter = [NSString stringWithFormat:@"%c", (char)65+eastingLetterValue];
	NSString *northingLetter = [NSString stringWithFormat:@"%c", (char)65+northingLetterValue];

	return [NSString stringWithFormat:@"%@%@", eastingLetter, northingLetter];
}

@end
