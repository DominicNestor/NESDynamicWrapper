//
//  NESDynamicWrapper.m
//  NESDynamicWrapper
//
//  Created by Nestor on 15/3/12.
//  Copyright (c) 2015年 NesTalk. All rights reserved.
//

#import "NESDynamicWrapper.h"
#import <objc/runtime.h>

#pragma util

NSString *getPrefix(id target,NSString *selName)
{
    Class clz = [target class];
    Method m = nil;

    NSArray *prefixes = [[NESDynamicWrapper sharedInstance] allPrefix];
    
    for (NSString *prefix in prefixes) {
        NSString *name = [prefix stringByAppendingString:selName];
        m = class_getInstanceMethod(clz, NSSelectorFromString(name));
        if (m) return prefix;
    }
    
    return nil;
}

#pragma replace imps

NSMethodSignature *realMethodSignature(id self, SEL _cmd, SEL aSelector)
{
    NSMethodSignature *sig = nil;
    NSString *selName = NSStringFromSelector(aSelector);
    NSString *prefix = getPrefix(self,selName);
    selName = [prefix stringByAppendingString:selName];
    Method m = class_getInstanceMethod([self class], NSSelectorFromString(selName));
    
    objc_setAssociatedObject(self, "wrapper_prefix", prefix, OBJC_ASSOCIATION_COPY);
    
    if (m) {
        const char * methodType = method_getTypeEncoding(m);
        sig = [NSMethodSignature signatureWithObjCTypes:methodType];
    }
    
    return sig;
}

void realForwardInvocation(id self, SEL _cmd,NSInvocation *anInvocation)
{
    NSString *oriName = NSStringFromSelector([anInvocation selector]);
    NSString *prefix = objc_getAssociatedObject(self, "wrapper_prefix");
    NSString *selName = [prefix stringByAppendingString:oriName];
    [anInvocation setSelector:NSSelectorFromString(selName)];
    
    NESDynamicWrapper *wrapper = [NESDynamicWrapper sharedInstance];
    
    NESCustomHandler *handler = [NESCustomHandler handlerWith:nil prefix:prefix];

    NSUInteger index = [wrapper.handlers indexOfObject:handler];
    if (index != NSNotFound) {
        handler = [wrapper.handlers objectAtIndex:index];
        if (handler.isEnable && wrapper.isEnable) {
            void (^ptr)(NSInvocation *) = [handler handler];
            ptr(anInvocation);
        }
        else
        {
            [anInvocation invoke];
        }
    }
    else
    {
        [NSException raise:@"Handler not found Exception" format:@"Can not find any handler for SEL: '%@' with prefix: '%@' in target: '%@' ",oriName,prefix,anInvocation.target];
    }
    
}

@interface NESDynamicWrapper ()

@end

@implementation NESDynamicWrapper

#pragma mark -
#pragma mark APIs

-(NSArray *)allPrefix
{
    return [self valueForKeyPath:@"handlers.prefix"];
}

-(void)addHandler:(NESCustomHandler *)handler, ...
{
    va_list args;
    va_start(args, handler);
    NSArray *allPrefix = [self allPrefix];
    if (handler) {
        while (1) {
            NSString *prefix = handler.prefix;
            NSAssert([allPrefix indexOfObject:prefix] == NSNotFound, @"Custom prefix: '%@' has already exist. Please chose some other prefix to replace.",prefix);
            [self.handlers addObject:handler];
            handler = va_arg(args, NESCustomHandler *);
            if (!handler) break;
        }
    }
    
    va_end(args);
}

-(void)removeHandlerWithPrefix:(NSString *)prefix
{
    NESCustomHandler *handler = [NESCustomHandler handlerWith:nil prefix:prefix];
    [self.handlers removeObjectAtIndex:[self.handlers indexOfObject:handler]];
}

-(void)setEnable:(BOOL)enable forPrefix:(NSString *)prefix
{
    NESCustomHandler *handler = [NESCustomHandler handlerWith:nil prefix:prefix];
    handler = [self.handlers objectAtIndex:[self.handlers indexOfObject:handler]];
    handler.enable = enable;
}

#pragma mark -
#pragma mark lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _handlers = [NSMutableArray array];
        _enable = YES;
        
        [self addHandler:
         [NESCustomHandler handlerWith:^(NSInvocation *anInvocation) {
            NSString *selName = NSStringFromSelector([anInvocation selector]);
            selName = [selName componentsSeparatedByString:@"_"].lastObject;
            id target = [anInvocation target];
            NSDate *startDate = [NSDate date];
            printf("NESLogger: [%s %s] invoked at: %s\n",[target description].UTF8String,selName.UTF8String,[startDate description].UTF8String);
            double startTime = [startDate timeIntervalSince1970];
            [anInvocation invoke];
            NSDate *endDate = [NSDate date];
            double endTime = [endDate timeIntervalSince1970];
            printf("NESLogger: [%s %s] ended at: %s, cost %.6f sec.\n",[target description].UTF8String,selName.UTF8String,[endDate description].UTF8String, endTime-startTime);
        } prefix:@"p_"],
         [NESCustomHandler handlerWith:^(NSInvocation *anInvocation) {
            static NSMutableDictionary *dict;
            
            if (!dict) {
                dict = [NSMutableDictionary dictionary];
            }
            
            NSString *selName = NSStringFromSelector([anInvocation selector]);
            selName = [selName componentsSeparatedByString:@"_"].lastObject;
            id target = [anInvocation target];
            NSString *key = [[target description] stringByAppendingString:selName];
            
            int times = [[dict objectForKey:key] intValue];
            times += 1;
            [dict setObject:@(times) forKey:key];
            [anInvocation invoke];
            printf("NESLogger: This is the %d time to run '%s' of target '%s'.\n",times,selName.UTF8String,[target description].UTF8String);
        } prefix:@"t_"],
         nil];
    }
    return self;
}

+(NESDynamicWrapper *)sharedInstance
{
    static NESDynamicWrapper *instance = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[self alloc] init];
    });
    
    return instance; 
}

+(void)swizz:(Class)clz
{
    Method m = class_getInstanceMethod(clz, @selector(methodSignatureForSelector:));
    method_setImplementation(m, (IMP)realMethodSignature);
    m = class_getInstanceMethod(clz, @selector(forwardInvocation:));
    method_setImplementation(m, (IMP)realForwardInvocation);
}

@end
