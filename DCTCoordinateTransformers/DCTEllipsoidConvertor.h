//
//  DCTEllipsoidConvertor.h
//  DCTCoordinateTransformers
//
//  Created by Daniel Tull on 17.03.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCTCoordinate.h"
#import "DCTDatumTransform.h"

typedef NS_ENUM(NSInteger, DCTEllipsoidConvertorEllipse) {
	DCTEllipsoidConvertorEllipseWGS84,
	DCTEllipsoidConvertorEllipseGRS80,
	DCTEllipsoidConvertorEllipseAiry1830,
	DCTEllipsoidConvertorEllipseAiryModified,
	DCTEllipsoidConvertorEllipseIntl1924
};

@interface DCTEllipsoidConvertor : NSObject

+ (DCTCoordinate *)convertCoordinate:(DCTCoordinate *)coordinate
						 fromEllipse:(DCTEllipsoidConvertorEllipse)ellipse
						   toEllipse:(DCTEllipsoidConvertorEllipse)ellipse
				 usingDatumTransform:(DCTDatumTransform *)datumTransform;

@end
