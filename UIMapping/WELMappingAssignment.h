//
//  WELMappingAssignment.h
//  WELUIMapping
//
//  Created by WELCommand on 15/6/20.
//  Copyright (c) 2015年 WELCommand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WELMappingAssignment : NSObject

+(NSArray *)propertyList:(id)obj;
+(BOOL)shouldMappingImage:(id)entity;
+(BOOL)shouldMappingText:(id)entity;
+(void)assignmentImageEntity:(id)UIEntity imageName:(NSString *)imageName;
+(void)assignmentTextEntity:(id)UIEntity text:(NSString *)text;
+(NSString *)modelValueToString:(id)value;

@end
