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

@end
