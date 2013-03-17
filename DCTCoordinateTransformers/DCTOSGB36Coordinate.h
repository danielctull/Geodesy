//
//  DCTOSGB36Coordinate.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCTOSGB36Coordinate : NSObject

- (id)initWithLatitude:(double)latitude longitude:(double)longitude;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

@end
