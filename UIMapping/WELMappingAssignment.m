//
//  WELMappingAssignment.m
//  WELUIMapping
//
//  Created by WELCommand on 15/6/20.
//  Copyright (c) 2015年 WELCommand. All rights reserved.
//

#import "WELMappingAssignment.h"
#import <objc/runtime.h>

@implementation WELMappingAssignment

+(NSArray *)propertyList:(id)obj {
    NSMutableArray *proArr = [NSMutableArray array];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([obj class], &count);
    for(NSInteger i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        [proArr addObject:propertyName];
    }
    free(properties);
    return proArr;
}


+(BOOL)shouldMappingImage:(id)entity {
    
    NSArray *shouldMappingClass = @[
                                    @"UIImageView",
                                    @"UIButton"];
    return [shouldMappingClass indexOfObject:NSStringFromClass([entity class])] != NSNotFound;
}

+(BOOL)shouldMappingText:(id)entity {
    NSArray *shouldMappingClass = @[
                                    @"UILabel",
                                    @"UITextView",
                                    @"UITextField",
                                    @"UIButton"];
    return [shouldMappingClass indexOfObject:NSStringFromClass([entity class])] != NSNotFound;
}

#pragma mark-
#pragma mark-  ui mapping image

+(void)assignmentImageEntity:(id)UIEntity imageName:(NSString *)imageName {
    
    if(imageName == nil) return;
    UIImage * image = [UIImage imageNamed:imageName];
    
    if([[UIEntity class] isSubclassOfClass:[UIImageView class]]) {
        [self assignmentImageView:UIEntity image:image];
    } else if ([[UIEntity class] isSubclassOfClass:[UIButton class]]) {
        [self assignmentButtonImage:UIEntity image:image];
    }
}

+(void)assignmentImageView:(UIImageView *)imageView image:(UIImage *)image {
    imageView.image = image;
}

+(void)assignmentButtonImage:(UIButton *)button image:(UIImage *)image {
    [button setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark-
#pragma mark-  ui mapping text

+(void)assignmentTextEntity:(id)UIEntity text:(NSString *)text {
    if([[UIEntity class] isSubclassOfClass:[UIButton class]]) {
        [self assignmentButtonText:UIEntity text:text];
    } else {
        [UIEntity setValue:text forKey:@"text"];
    }
}

+(void)assignmentButtonText:(UIButton *)button text:(NSString *)text {
    [button setTitle:text forState:UIControlStateNormal];
}

+(NSString *)modelValueToString:(id)value {
    if([[value class] isSubclassOfClass:[NSNumber class]]) {
        return [[NSString alloc] initWithFormat:@"%@",value];
    } else if ([[value class] isSubclassOfClass:[NSString class]]) {
        return value;
    } else {
        return @"";
    }
}


@end
