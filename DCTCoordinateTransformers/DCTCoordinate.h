//
//  DCTCoordinate.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef double DCTCoordinateDegrees;

@interface DCTCoordinate : NSObject

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
