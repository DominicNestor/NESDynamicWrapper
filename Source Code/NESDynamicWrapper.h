//
//  NESDynamicWrapper.h
//  NESDynamicWrapper
//
//  Created by Nestor on 15/3/12.
//  Copyright (c) 2015年 NesTalk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NESCustomHandler.h"

@interface NESDynamicWrapper : NSObject

//保存所有的handler
@property (nonatomic,retain,readonly) NSMutableArray *handlers;
//全局开关,当值为NO时所有的handler将直接执行,默认为YES
@property (nonatomic,assign,getter=isEnable) BOOL enable;

+(NESDynamicWrapper *)sharedInstance;

/**
 *  @author writen by Nestor. Personal site - http://www.nestor.me , 15-03-19 16:49:04
 *
 *  核心方法,在需要添加动态代理功能的类的+load方法中调用该方法并在需要被代理的类前添加前缀即可
 *  
 *  例:
 *  +(void)load{
 *      [NESDynamicWrapper swizz:[self class]];
 *  }
 *
 *  @param clz 需要被代理的类
 */
+(void)swizz:(Class)clz;

/**
 *  @author writen by Nestor. Personal site - http://www.nestor.me , 15-03-19 16:51:38
 *
 *  添加一个或多个自定义的Handler,需要以nil结尾
 *  @note 每个handler有一个唯一的prefix标识,如果新添加handler的prefix已经存在则会终止程序运行,默认已经包含的标签为"t_"和"p_"
 *  @param handler 用户自定义handler
 */
-(void)addHandler:(NESCustomHandler *)handler,... NS_REQUIRES_NIL_TERMINATION;
/**
 *  @author writen by Nestor. Personal site - http://www.nestor.me , 15-03-19 16:54:53
 *
 *  删除一个已经存在的handler
 *
 *  @param prefix 要删除的handler的前缀
 */
-(void)removeHandlerWithPrefix:(NSString *)prefix;
/**
 *  @author writen by Nestor. Personal site - http://www.nestor.me , 15-03-19 16:55:14
 *
 *  设置是否开启某一个handler
 *
 *  @param enable 开启状态
 *  @param prefix 要设置的handler的前缀 
 */
-(void)setEnable:(BOOL)enable forPrefix:(NSString *)prefix;

/**
 *  @author writen by Nestor. Personal site - http://www.nestor.me , 15-03-19 16:55:36
 *
 *  已注册的所有prefix
 *
 *  @return 包含所有前缀的数组
 */
-(NSArray *)allPrefix;

@end
