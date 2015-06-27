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

-(NSString *)customTextSplice:(NSString *)UIkey modelValue:(NSString *)value;
-(NSString *)customTextSplice:(NSString *)UIkey modelDictionary:(NSDictionary *)modelDictionary;

//-(void)customValueEvent:(NSString *)modelKey;

@end
