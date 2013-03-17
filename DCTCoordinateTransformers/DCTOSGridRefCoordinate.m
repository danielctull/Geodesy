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
	
	gridReference = [gridReference uppercaseString];
	NSMutableCharacterSet *characterSet = [NSMutableCharacterSet uppercaseLetterCharacterSet];
	[characterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
	[characterSet invert];
	NSArray *array = [gridReference componentsSeparatedByCharactersInSet:characterSet];
	gridReference = [array componentsJoinedByString:@""];
	
	if (gridReference.length < 2) return 0;
	
	// get numeric values of letter references, mapping A->0, B->1, C->2, etc:
	unichar eastingChar = [gridReference characterAtIndex:0];
	unichar northingChar = [gridReference characterAtIndex:1];
	eastingChar -= 'A';
	northingChar -= 'A';
	
	// shuffle down letters after 'I' since 'I' is not used in grid:
	if (eastingChar > 7) eastingChar--;
	if (northingChar > 7) northingChar--;
	
	// convert grid letters into 100km-square indexes from false origin (grid square SV):
	NSInteger easting = ((eastingChar-2)%5)*5 + (northingChar%5);
	NSInteger northing = (19-floor(eastingChar/5)*5) - floor(northingChar/5);
	if (easting < 0 || easting > 6 || northing < 0 || northing > 12) return 0;
	
	gridReference = [gridReference substringFromIndex:2];
	NSInteger figures = (gridReference.length/2);
	
	NSString *eastingString = [gridReference substringToIndex:figures];
	NSString *northingString = [gridReference substringFromIndex:figures];
	
	NSString *padding = @"50000";
	padding = [padding substringToIndex:(5-figures)];
	
	eastingString = [NSString stringWithFormat:@"%@%@%@", @(easting), eastingString, padding];
	northingString = [NSString stringWithFormat:@"%@%@%@", @(northing), northingString, padding];
	
	return [self initWithEasting:[eastingString integerValue] northing:[northingString integerValue]];
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
	return [NSString stringWithFormat:@"%@ %@ %@", self.gridSquareLetters, @(easting), @(northing)];
}

- (NSString *)gridSquareLetters {
	
	// get the 100km-grid indices
	NSInteger easting100k = floor(self.easting/100000);
	NSInteger northing100k = floor(self.northing/100000);
		
	if (easting100k < 0) return nil;
	if (easting100k > 6) return nil;
	if (northing100k < 0) return nil;
	if (northing100k > 12) return nil;
	
	// translate those into numeric equivalents of the grid letters
	unichar eastingLetterValue = (19 - northing100k) - ((19 - northing100k) % 5) + floor((easting100k + 10) / 5);
	unichar northingLetterValue = (((19 - northing100k) * 5) % 25) + (easting100k % 5);
	
	// compensate for skipped 'I' and build grid letter-pairs
	if (eastingLetterValue > 7) eastingLetterValue++;
	if (northingLetterValue > 7) northingLetterValue++;
	
	eastingLetterValue+= 'A';
	northingLetterValue+= 'A';
	
	NSString *eastingLetter = [NSString stringWithFormat:@"%c", eastingLetterValue];
	NSString *northingLetter = [NSString stringWithFormat:@"%c", northingLetterValue];

	return [NSString stringWithFormat:@"%@%@", eastingLetter, northingLetter];
}

@end
