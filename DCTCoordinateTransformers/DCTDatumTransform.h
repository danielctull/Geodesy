//
//  DCTDatumTransform.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCTDatumTransform : NSObject

+ (instancetype)WGS84toOSGB36DatumTransform;
+ (instancetype)OSGB36toWGS84DatumTransform;

- (id)initWithTransformX:(double)transformX
			  transformY:(double)transformY
			  transformZ:(double)transformZ
				 rotateX:(double)rotateX
				 rotateY:(double)rotateY
				 rotateZ:(double)rotateZ
				   scale:(double)scale;

@property (nonatomic, readonly) double transformX;
@property (nonatomic, readonly) double transformY;
@property (nonatomic, readonly) double transformZ;
@property (nonatomic, readonly) double rotateX;
@property (nonatomic, readonly) double rotateY;
@property (nonatomic, readonly) double rotateZ;
@property (nonatomic, readonly) double scale;

@end
