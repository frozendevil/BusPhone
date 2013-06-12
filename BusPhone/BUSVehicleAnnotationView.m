//
//  BUSVehicleAnnotationView.m
//  BusPhone
//
//  Created by Izzy Fraimow on 6/8/13.
//  Copyright (c) 2013 Izzy Fraimow. All rights reserved.
//

#import "BUSVehicleAnnotationView.h"
#import "BUSVehicle.h"
#import <QuartzCore/QuartzCore.h>

@interface BUSVehicleAnnotationView ()
@end

@implementation BUSVehicleAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
	
	self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bus-dot"]];//[[UIColor darkGrayColor] colorWithAlphaComponent:0.75];
	self.opaque = NO;
	self.layer.cornerRadius = 5;
	self.clipsToBounds = NO;
	
	CGRect frame = self.frame;
	CGPoint center = self.center;
	frame.size.width = 19;
	frame.size.height = 19;
	self.frame = frame;
	self.center = center;
	
	[self setAnnotation:annotation];
	
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation; {
	[super setAnnotation:annotation];
	
	if(![annotation isKindOfClass:[BUSVehicle class]]) {
		return;
	}
	
	static UIImage *busDotImage;
	busDotImage = [UIImage imageNamed:@"bus-dot"];
	
	static UIImage *boatDotImage;
	boatDotImage = [UIImage imageNamed:@"boat-dot"];
	
	static UIImage *trainDotImage;
	trainDotImage = [UIImage imageNamed:@"train-dot"];

	BUSVehicle *vehicle = (BUSVehicle *)annotation;
	switch (vehicle.vehicleType) {
		case BUSVehicleTypeBus:
			self.backgroundColor = [UIColor colorWithPatternImage:busDotImage];
			break;
		case BUSVehicleTypeFerry:
			self.backgroundColor = [UIColor colorWithPatternImage:boatDotImage];
			break;
		case BUSVehicleTypeStreetCar:
			self.backgroundColor = [UIColor colorWithPatternImage:trainDotImage];
			break;
		case BUSVehicleTypeTrain:
			self.backgroundColor = [UIColor colorWithPatternImage:trainDotImage];
			break;
		case BUSVehicleTypeLunarRover:
		default:
			self.backgroundColor = [UIColor colorWithPatternImage:busDotImage];
			break;
	}
	
//	self.annotationLabel.text = [annotation title];
//	[self.annotationLabel sizeToFit];

//	
//	self.annotationLabel.center = self.center;
//	self.annotationLabel.frame = CGRectIntegral(self.annotationLabel.frame);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
