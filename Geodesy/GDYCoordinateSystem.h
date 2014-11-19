//
//  GDYCoordinateSystem.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 18.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import Foundation;
#import "GDYDatum.h"
#import "GDYEllipsoid.h"
@class GDYCoordinate;

@interface GDYCoordinateSystem : NSObject

- (instancetype)initWithDatum:(GDYDatum *)datum ellipsoid:(GDYEllipsoid *)ellipsoid;
@property (nonatomic, readonly) GDYDatum *datum;
@property (nonatomic, readonly) GDYEllipsoid *ellipsoid;

- (GDYCoordinate *)convertCoordinate:(GDYCoordinate *)coordinate toSystem:(GDYCoordinateSystem *)system;
+ (instancetype)WGS84CoordinateSystem;
+ (instancetype)OSGB36CoordinateSystem;

@end
