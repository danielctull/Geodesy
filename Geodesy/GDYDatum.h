//
//  GDYDatum.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import Foundation;
#import "GDYHelmertDatumTransform.h"

typedef NS_ENUM(NSInteger, GDYDatumType) {
	GDYDatumTypeWGS84,
	GDYDatumTypeOSGB36
};

@interface GDYDatum : NSObject

- (instancetype)initWithType:(GDYDatumType)type;
@property (nonatomic, readonly) GDYDatumType type;

- (GDYHelmertDatumTransform *)transformToWGS84;
- (GDYHelmertDatumTransform *)transformFromWGS84;

@end
