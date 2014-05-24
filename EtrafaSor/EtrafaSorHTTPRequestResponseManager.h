//
//  EtrafaSorHTTPRequestResponseManager.h
//  EtrafaSor
//
//  Created by Can Firtina on 25/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol EtrafaSorHTTPRequestHandlerDelegate <NSObject>

//if data is nil, then failed
- (void)connectionHasFinishedWithData:(NSDictionary *)data;
@end

@interface EtrafaSorHTTPRequestResponseManager : NSObject

@property (nonatomic) id<EtrafaSorHTTPRequestHandlerDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;

@end
