//
//  GDYCoordinate.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "GDYCoordinateSystem.h"

@interface GDYCoordinate : NSObject

/** Returns a coordinate in the WGS84 coordinate space.
 */
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude;

/** Returns a coordinate with the given datum and ellipsoid.
 
 */
- (instancetype)initWithLatitude:(double)latitude longitude:(double)longitude coordinateSystem:(GDYCoordinateSystem *)coordinateSystem;
@property (nonatomic, readonly) double latitude;
@property (nonatomic, readonly) double longitude;
@property (nonatomic, readonly) GDYCoordinateSystem *coordinateSystem;

- (GDYCoordinate *)convertToCoordinateSystem:(GDYCoordinateSystem *)coordinateSystem;

- (double)initialHeadingToCoordinate:(GDYCoordinate *)coordinate;
- (double)distanceToCoordinate:(GDYCoordinate *)coordinate;

@end
