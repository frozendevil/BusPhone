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
@property (nonatomic, strong) UILabel *annotationLabel;
@end

@implementation BUSVehicleAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier; {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
	
	self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.75];
	self.opaque = NO;
	self.layer.cornerRadius = 5;
	self.clipsToBounds = NO;
	
	self.annotationLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	[self addSubview:self.annotationLabel];
	
	[self setAnnotation:annotation];
	
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation; {
	[super setAnnotation:annotation];
	
	if(![annotation isKindOfClass:[BUSVehicle class]]) {
		return;
	}

	BUSVehicle *vehicle = (BUSVehicle *)annotation;
	switch (vehicle.vehicleType) {
		case BUSVehicleTypeBus:
			self.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.75];
			self.annotationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
			break;
		case BUSVehicleTypeFerry:
			self.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.75];
			self.annotationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
			break;
		case BUSVehicleTypeStreetCar:
			self.backgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.75];
			self.annotationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
			break;
		case BUSVehicleTypeTrain:
			self.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.75];
			self.annotationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
			break;
		case BUSVehicleTypeLunarRover:
			self.backgroundColor = [[UIColor magentaColor] colorWithAlphaComponent:0.75];
			self.annotationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
			break;
		default:
			self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.75];
			self.annotationLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:10];
			break;
			break;
	}
	
	self.annotationLabel.text = [annotation title];
	self.annotationLabel.textColor = [UIColor whiteColor];
	self.annotationLabel.backgroundColor = [UIColor clearColor];
	[self.annotationLabel sizeToFit];
	CGRect frame = self.frame;
	frame.size.width = self.annotationLabel.bounds.size.width + 6;
	frame.size.height = self.annotationLabel.bounds.size.height + 6;
	self.frame = frame;
	
	self.annotationLabel.center = self.center;
	self.annotationLabel.frame = CGRectIntegral(self.annotationLabel.frame);
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
