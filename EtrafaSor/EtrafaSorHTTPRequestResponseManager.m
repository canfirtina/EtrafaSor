//
//  EtrafaSorHTTPRequestResponseManager.m
//  EtrafaSor
//
//  Created by Can Firtina on 25/01/14.
//  Copyright (c) 2014 Can Firtina. All rights reserved.
//

#import "EtrafaSorHTTPRequestResponseManager.h"

@implementation EtrafaSorHTTPRequestResponseManager
@synthesize responseData = _responseData;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
    [self.delegate connectionHasFinishedWithData:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:nil];
    
    [self.delegate connectionHasFinishedWithData:result];
}

@end
