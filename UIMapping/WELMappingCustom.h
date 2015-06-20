//
//  WELMappingCustom.h
//  WELUIMapping
//
//  Created by WELCommand on 15/6/18.
//  Copyright (c) 2015年 WELCommand. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WELMappingCustom <NSObject>

@optional

-(NSString *)customImageURLStringSpliceRuleWithUIKey:(NSString *)key subURLString:(NSString *)subURLString;

-(NSString *)customMappingWithUIKey:(NSString *)key modelValue:(NSString *)value;
-(NSString *)customMappingWithUIKey:(NSString *)key model:(id)model;



@end
