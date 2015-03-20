//
//  NESTestView.m
//  NESDynamicWrapper
//
//  Created by Nestor on 15/3/12.
//  Copyright (c) 2015年 NesTalk. All rights reserved.
//
 
#import "NESTestView.h"
#import "NESDynamicWrapper.h"

@interface NESTestView ()

@end

@implementation NESTestView

+(void)load
{
    [NESDynamicWrapper swizz:[self class]];
}

-(void)t2_show
{
    self.hidden = NO;
}

-(void)t3_hide
{
    self.hidden = YES;
}

-(void)t1_test
{
    NSLog(@"%s-[%s]:test",__func__,__TIME__); 
}

-(NSString *)p_print:(NSString *)str
{
    NSLog(@"arg is:%@",str);
    return str;
}

@end