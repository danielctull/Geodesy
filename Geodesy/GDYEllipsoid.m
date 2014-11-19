//
//  GDYEllipsoid.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "GDYEllipsoid.h"

@implementation GDYEllipsoid

+ (instancetype)WGS84Ellipsoid {
	return [[self alloc] initWithSemiMajorAxis:6378137 semiMinorAxis:6356752.3142 inverseFlattening:1/298.257223563];
}

+ (instancetype)GRS80Ellipsoid {
	return [[self alloc] initWithSemiMajorAxis:6378137 semiMinorAxis:6356752.314140 inverseFlattening:1/298.257222101];
}

+ (instancetype)Airy1830Ellipsoid {
	return [[self alloc] initWithSemiMajorAxis:6377563.396 semiMinorAxis:6356256.910 inverseFlattening:1/299.3249646];
}

+ (instancetype)AiryModifiedEllipsoid {
	return [[self alloc] initWithSemiMajorAxis:6377340.189 semiMinorAxis:6356034.448 inverseFlattening:1/299.32496];
}

+ (instancetype)Intl1924Ellipsoid {
	return [[self alloc] initWithSemiMajorAxis:6378388.000 semiMinorAxis:6356911.946 inverseFlattening:1/297.0];
}

- (instancetype)initWithSemiMajorAxis:(double)semiMajorAxis semiMinorAxis:(double)semiMinorAxis inverseFlattening:(double)inverseFlattening {
	self = [self init];
	if (!self) return nil;
	_semiMajorAxis = semiMajorAxis;
	_semiMinorAxis = semiMinorAxis;
	_inverseFlattening = inverseFlattening;
	return self;
}

@end
