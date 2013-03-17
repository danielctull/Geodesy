//
//  DCTEllipsoidConvertor.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GDYCoordinate.h"
#import "GDYDatumTransform.h"
#import "GDYEllipsoid.h"

@interface DCTEllipsoidConvertor : NSObject

+ (GDYCoordinate *)convertCoordinate:(GDYCoordinate *)coordinate
					   fromEllipsoid:(GDYEllipsoid *)fromEllipsoid
						 toEllipsoid:(GDYEllipsoid *)toEllipsoid
				 usingDatumTransform:(GDYDatumTransform *)datumTransform;

@end
