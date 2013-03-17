//
//  DCTOSGridRefCoordinate.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTCoordinate.h"

@interface DCTOSGridRefCoordinate : DCTCoordinate

- (id)initWithGridReference:(NSString *)gridReference;
@property (nonatomic, readonly) NSString *gridReference;

@end
