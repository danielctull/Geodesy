//
//  GDYEllipsoid.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GDYEllipsoid : NSObject

+ (instancetype)WGS84Ellipsoid;
+ (instancetype)GRS80Ellipsoid;
+ (instancetype)Airy1830Ellipsoid;
+ (instancetype)AiryModifiedEllipsoid;
+ (instancetype)Intl1924Ellipsoid;

- (id)initWithA:(double)a b:(double)b f:(double)f;
@property (nonatomic, readonly) double a;
@property (nonatomic, readonly) double b;
@property (nonatomic, readonly) double f;

@end
