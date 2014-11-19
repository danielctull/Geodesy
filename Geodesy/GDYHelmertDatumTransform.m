//
//  GDYDatumTransform.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "GDYHelmertDatumTransform.h"

@implementation GDYHelmertDatumTransform

+ (instancetype)WGS84toOSGB36DatumTransform {
	return [[GDYHelmertDatumTransform alloc] initWithTransformX:-446.448
								 transformY:125.157
								 transformZ:-542.060
									rotateX:-0.1502
									rotateY:-0.2470
									rotateZ:-0.8421
									  scale:20.4894];
}

+ (instancetype)OSGB36toWGS84DatumTransform {
	return [[self WGS84toOSGB36DatumTransform] inverseTransform];
}

- (instancetype)inverseTransform {
	return [[[self class] alloc] initWithTransformX:-self.transformX
										 transformY:-self.transformY
										 transformZ:-self.transformZ
											rotateX:-self.rotateX
											rotateY:-self.rotateY
											rotateZ:-self.rotateZ
											  scale:-self.scale];
}

- (instancetype)initWithTransformX:(double)transformX
						transformY:(double)transformY
						transformZ:(double)transformZ
						   rotateX:(double)rotateX
						   rotateY:(double)rotateY
						   rotateZ:(double)rotateZ
							 scale:(double)scale {
	self = [self init];
	if (!self) return nil;
	_transformX = transformX;
	_transformY = transformY;
	_transformZ = transformZ;
	_rotateX = rotateX;
	_rotateY = rotateY;
	_rotateZ = rotateZ;
	_scale = scale;
	return self;
}

@end
