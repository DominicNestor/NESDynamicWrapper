//
//  NESCustomHandler.h
//  NESDynamicWrapper
//
//  Created by Nestor on 15/3/18.
//  Copyright (c) 2015年 NesTalk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NESCustomHandler : NSObject

//动态代理的block,可以在其中执行任何操作,但必须包含[anInvocation invo]
@property (nonatomic,copy) void (^handler)(NSInvocation * anInvocation);
@property (nonatomic,copy) NSString *prefix;
//当前handler是否可用,如果值为NO,则会忽略block的内容直接运行原始代码,但是不需要删除方法实现中前的prefix
//默认YES
@property (nonatomic,assign,getter=isEnable) BOOL enable; 

/**
 *  @author writen by Nestor. Personal site - http://www.nestor.me , 15-03-19 18:23:20
 *
 *  获得Handler的实例,prefix可以是任意字符串,会通过其内容自动判断是否加上"_"后缀,
 *  即prefix的值为"prefix"时对应的真实值是"prefix_"
 *
 *  @param handler 动态代理block
 *  @param prefix  对应的前缀名
 *
 *  @return 实例
 */
+(NESCustomHandler *)handlerWith:(void (^)(NSInvocation *anInvocation))handler prefix:(NSString *)prefix;

@end
