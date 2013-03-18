//
//  DCTOSGridRefCoordinate.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDYCoordinate.h"

@interface GDYOSGridReference : NSObject

- (id)initWithGridReference:(NSString *)gridReference;
- (id)initWithEasting:(NSInteger)easting northing:(NSInteger)northing;

@property (readonly) NSString *gridSquareLetters;
@property (nonatomic, readonly) NSInteger easting;
@property (nonatomic, readonly) NSInteger northing;

- (NSString *)gridReferenceWithNumberOfFigures:(NSInteger)numberOfFigures;

- (id)initWithCoordinate:(GDYCoordinate *)coordinate;
- (GDYCoordinate *)convertToCoordinateSystem:(GDYCoordinateSystem *)coordinateSystem;

@end
