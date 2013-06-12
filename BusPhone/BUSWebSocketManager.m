//
//  BUSWebSocketManager.m
//  BusPhone
//
//  Created by Izzy Fraimow on 6/9/13.
//  Copyright (c) 2013 Izzy Fraimow. All rights reserved.
//

#import "BUSWebSocketManager.h"
#import "Reachability.h"
#import "SRWebSocket.h"

@interface BUSWebSocketManager () <SRWebSocketDelegate>

@property (nonatomic, strong) Reachability *reachability;
@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSOperationQueue *socketQueue;

@end

@implementation BUSWebSocketManager 

- (instancetype)init; {
	self = [super init];
	if(!self) return nil;
	
	self.socketQueue = [[NSOperationQueue alloc] init];
	self.socketQueue.name = @"com.anathemacalculus.busphone.socketqueue";
	
	self.reachability = [Reachability reachabilityWithHostname:@"busdrone.com"];
	
	NSURL *busDroneURL = [NSURL URLWithString:@"ws://busdrone.com:28737/"];
	self.webSocket = [[SRWebSocket alloc] initWithURL:busDroneURL];
	[self.webSocket setDelegateOperationQueue:self.socketQueue];
	self.webSocket.delegate = self;
	
	__weak typeof(self) weakSelf = self;
	self.reachability.reachableBlock = ^(Reachability *reach) {
		__strong typeof(self) strongSelf = weakSelf;
		[strongSelf startSocket];
	};
	
	self.reachability.unreachableBlock = ^(Reachability *reach) {
		__strong typeof(self) strongSelf = weakSelf;
		[strongSelf stopSocket];
	};
	
	return self;
}

- (void)start; {
	[self.reachability startNotifier];
}

- (void)stop; {
	[self.reachability stopNotifier];
	[self stopSocket];
}

- (void)startSocket; {
	SRReadyState socketState = [self.webSocket readyState];
	if(socketState == SR_OPEN || socketState == SR_CONNECTING) return;
	
	[self.webSocket open];
}

- (void)stopSocket; {
	[self.webSocket close];
}

#pragma mark - SRWebSocketDelegate

static NSString * const BUSSocketEventTypeInit = @"init";
static NSString * const BUSSocketEventTypeUpdateVehicle = @"update_vehicle";
static NSString * const BUSSocketEventTypeRemoveVehicle = @"remove_vehicle";

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message; {
	NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
	NSError *error = nil;
	NSDictionary *busEventDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if(!busEventDict) {
		NSLog(@"JSON parsing error: %@", error);
	}
	
	NSString *eventType = busEventDict[@"type"];
	
//	if([eventType isEqualToString:BUSSocketEventTypeInit]) {
//		[self createVehiclesWithJSONArray:busEventDict[@"vehicles"]];
//	} else if([eventType isEqualToString:BUSSocketEventTypeUpdateVehicle]) {
//		[self updateVehicleWithJSONDict:busEventDict[@"vehicle"]];
//	} else if([eventType isEqualToString:BUSSocketEventTypeUpdateVehicle]) {
//		[self removeVehicleWithJSONDict:busEventDict[@"vehicle"]];
//	}
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error; {
	
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean; {
	// be naive and just try to re-open the socket
	if([self.reachability isReachable]) {
		[self.webSocket open];
	}
}

@end
