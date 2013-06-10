//
//  BUSVehicleAnnotationView.m
//  BusPhone
//
//  Created by Izzy Fraimow on 6/8/13.
//  Copyright (c) 2013 Izzy Fraimow. All rights reserved.
//

#import "BUSVehicleAnnotationView.h"
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
	
	UILabel *title = [[UILabel alloc] initWithFrame:CGRectZero];
	title.text = [annotation title];
	title.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
	title.textColor = [UIColor whiteColor];
	title.backgroundColor = [UIColor clearColor];
	[title sizeToFit];
	CGRect frame = self.frame;
	frame.size.width = title.bounds.size.width + 6;
	frame.size.height = title.bounds.size.height + 6;
	self.frame = frame;
	
	title.center = self.center;
	title.frame = CGRectIntegral(title.frame);
	
	[self addSubview:title];
	
    return self;
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
