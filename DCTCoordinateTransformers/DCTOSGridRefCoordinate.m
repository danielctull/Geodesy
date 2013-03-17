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
	self = [self init];
	if (!self) return nil;
	_gridReference = gridReference;
	return self;
}

@end
