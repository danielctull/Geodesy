//
//  GDYDatum.m
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "GDYDatum.h"

@implementation GDYDatum

- (id)initWithType:(GDYDatumType)type {
	self = [self init];
	if (!self) return nil;
	_type = type;
	return self;
}

- (GDYHelmertDatumTransform *)transformToWGS84 {
	return [[self transformFromWGS84] inverseTransform];
}

- (GDYHelmertDatumTransform *)transformFromWGS84 {
	switch (self.type) {
		case GDYDatumTypeWGS84:
			return nil;
			break;
			
		case GDYDatumTypeOSGB36:
			return [[GDYHelmertDatumTransform alloc] initWithTransformX:-446.448
															 transformY:125.157
															 transformZ:-542.060
																rotateX:-0.1502
																rotateY:-0.2470
																rotateZ:-0.8421
																  scale:20.4894];
			break;
	}
}

@end
