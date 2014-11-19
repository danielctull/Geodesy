//
//  GDYEllipsoid.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import Foundation;

@interface GDYEllipsoid : NSObject

+ (instancetype)WGS84Ellipsoid;
+ (instancetype)GRS80Ellipsoid;
+ (instancetype)Airy1830Ellipsoid;
+ (instancetype)AiryModifiedEllipsoid;
+ (instancetype)Intl1924Ellipsoid;

- (instancetype)initWithSemiMajorAxis:(double)semiMajorAxis semiMinorAxis:(double)semiMinorAxis inverseFlattening:(double)inverseFlattening;
@property (nonatomic, readonly) double semiMajorAxis;
@property (nonatomic, readonly) double semiMinorAxis;
@property (nonatomic, readonly) double inverseFlattening;

@end
