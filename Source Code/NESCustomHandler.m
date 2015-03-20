//  NESCustomHandler.m
//  NESDynamicWrapper
//
//  Created by Nestor on 15/3/18.
//  Copyright (c) 2015年 NesTalk. All rights reserved.
//

#import "NESCustomHandler.h"

@implementation NESCustomHandler

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.enable = YES;
    }
    return self;
}

+(NESCustomHandler *)handlerWith:(void (^)(NSInvocation *))handler prefix:(NSString *)prefix
{
    NESCustomHandler *customHandler = [[NESCustomHandler alloc] init];
    customHandler.handler = handler;
    
    if (![prefix hasSuffix:@"_"]) {
        prefix = [prefix stringByAppendingString:@"_"];
    }
    
    customHandler.prefix = prefix;
    
    return customHandler;
}

- (BOOL)isEqual:(id)other
{
    if (other == self) {
        return YES;
    } else if (![other isKindOfClass:[NESCustomHandler class]]){
        return NO;
    }
    
    NESCustomHandler *handler = other;
    return [self.prefix isEqualToString:handler.prefix]; 
}

- (NSUInteger)hash
{
    return self.prefix.hash;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"%@--%@ ",[super description],self.prefix];
}

@end
