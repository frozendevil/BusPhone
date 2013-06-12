//
//  BUSWebSocketManager.h
//  BusPhone
//
//  Created by Izzy Fraimow on 6/9/13.
//  Copyright (c) 2013 Izzy Fraimow. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BUSEventManager;

@protocol BUSEventManagerDelegate <NSObject>

- (void)eventManager:(BUSEventManager *)manager didReceiveNewVehicles:(NSArray *)vehicles;
- (void)eventManager:(BUSEventManager *)manager didUpdateVehicles:(NSArray *)vehicles;
- (void)eventManager:(BUSEventManager *)manager didRemoveVehicles:(NSArray *)vehicles;

@end

@interface BUSEventManager : NSObject

@property (nonatomic, weak) id<BUSEventManagerDelegate> delegate;

- (void)start;
- (void)stop;

@end
