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
	return [[self alloc] initWithA:6378137 b:6356752.3142 f:1/298.257223563];
}

+ (instancetype)GRS80Ellipsoid {
	return [[self alloc] initWithA:6378137 b:6356752.314140 f:1/298.257222101];
}

+ (instancetype)Airy1830Ellipsoid {
	return [[self alloc] initWithA:6377563.396 b:6356256.910 f:1/299.3249646];
}

+ (instancetype)AiryModifiedEllipsoid {
	return [[self alloc] initWithA:6377340.189 b:6356034.448 f:1/299.32496];
}

+ (instancetype)Intl1924Ellipsoid {
	return [[self alloc] initWithA:6378388.000 b:6356911.946 f:1/297.0];
}

- (id)initWithA:(double)a b:(double)b f:(double)f {
	self = [self init];
	if (!self) return nil;
	_a = a;
	_b = b;
	_f = f;
	return self;
}

@end
