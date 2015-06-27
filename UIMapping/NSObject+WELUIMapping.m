//
//  NSObject+WELUIMapping.m
//  ECON
//
//  Created by WELCommand on 15/5/26.
//  Copyright (c) 2015年 WELCommand. All rights reserved.
//

#import "NSObject+WELUIMapping.h"
#import "WELGlobalMappingRule.h"
#import "WELMappingCustom.h"
#import <objc/runtime.h>

@implementation NSObject (WELUIMapping)

-(void)mappingUIWithModel:(id)model {
    if(![[model class] isSubclassOfClass:[NSDictionary class]]) {
        NSArray *prolist =  [self WELPropertyList:model];
        [self mappingUIWithPropertyList:prolist data:model];
    }
    [self mappingUIWithDictionary:model];
}

-(void)mappingUIWithDictionary:(NSDictionary *)dictionary {
    if(!dictionary || ![[dictionary class] isSubclassOfClass:[NSDictionary class]]) return;
    
    [self mappingUIWithPropertyList:[dictionary allKeys] data:dictionary];
}

-(void)mappingUIWithPropertyList:(NSArray *)properties data:(id)data {
    
    WELGlobalMappingRule *shareRule = [WELGlobalMappingRule globalRule];
    
    NSArray *UIProList = [self WELPropertyList:self];
    for(NSInteger i = 0; i < UIProList.count; i++) {
        id UIEntity = [self valueForKey:UIProList[i]];
        // 元素为nil
        if(!UIEntity) continue;
        
        __block id modelEntity;
        if([properties indexOfObject:UIProList[i]] != NSNotFound) {
            modelEntity = UIProList[i];
        } else if (shareRule.sameMeaningKeys) {
            [shareRule searchSameMeaningKeysWithKey:UIProList[i] block:^(NSString *sameKey, BOOL *stop) {
                if([properties indexOfObject:sameKey] != NSNotFound) {
                    modelEntity = sameKey;
                    *stop = YES;
                }
            }];
        }
        
        if(!modelEntity) continue;
        id modelEntityValue = [data valueForKey:modelEntity];
        if(!modelEntityValue) continue;
        
        if([self WELShouldMappingImage:UIEntity]) {
            NSString *urlString = nil;
            if([self respondsToSelector:@selector(customImageURLStringSpliceRuleWithUIKey:subURLString:)]) {
                urlString = [self performSelector:@selector(customImageURLStringSpliceRuleWithUIKey:subURLString:) withObject:modelEntity withObject:modelEntityValue];
            }
            if ((!urlString || urlString.length  == 0) && shareRule.imageUrlSplic) {
                urlString = shareRule.imageUrlSplic(modelEntity,modelEntityValue);
            }
            if(!urlString || urlString.length  == 0) {
                urlString = modelEntityValue;
            }
            
            NSURL *imageRequestURL = [NSURL URLWithString:urlString];
            if(imageRequestURL && shareRule.imageRequestRule) {
                shareRule.imageRequestRule(UIEntity,imageRequestURL);
                continue;
            }
            
        }
        
        if ([self WELShouldMappingText:UIEntity]) {
            
            NSString *text = nil;
            if([self respondsToSelector:@selector(customTextSplice:modelValue:)]) {
                text = [self performSelector:@selector(customTextSplice:modelValue:) withObject:modelEntity withObject:modelEntityValue];
            }
            if((!text || text.length == 0) && [self respondsToSelector:@selector(customTextSplice:modelDictionary:)]) {
                text = [self performSelector:@selector(customTextSplice:modelDictionary:) withObject:modelEntity withObject:data];
            }
            if((!text || text.length == 0) && shareRule.textSplice) {
                text = shareRule.textSplice(modelEntity,modelEntityValue);
            }
            if(!text || text.length == 0) {
                text = modelEntityValue;
            }
            text = [self WELModelValueToString:text];
            [self WELAssignmentTextEntity:UIEntity text:text];
        }
    }
}



#pragma mark-
#pragma mark- private

-(NSArray *)WELPropertyList:(id)obj {
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


-(BOOL)WELShouldMappingImage:(id)entity {
    
    NSArray *shouldMappingClass = @[
                                    @"UIImageView",
                                    @"UIButton"];
    return [shouldMappingClass indexOfObject:NSStringFromClass([entity class])] != NSNotFound;
}

-(BOOL)WELShouldMappingText:(id)entity {
    NSArray *shouldMappingClass = @[
                                    @"UILabel",
                                    @"UITextView",
                                    @"UITextField",
                                    @"UIButton"];
    return [shouldMappingClass indexOfObject:NSStringFromClass([entity class])] != NSNotFound;
}

#pragma mark-
#pragma mark-  ui mapping image

-(void)WELAssignmentImageEntity:(id)UIEntity imageName:(NSString *)imageName {
    
    if(imageName == nil) return;
    UIImage * image = [UIImage imageNamed:imageName];
    
    if([[UIEntity class] isSubclassOfClass:[UIImageView class]]) {
        [self WELAssignmentImageView:UIEntity image:image];
    } else if ([[UIEntity class] isSubclassOfClass:[UIButton class]]) {
        [self WELAssignmentButtonImage:UIEntity image:image];
    }
}

-(void)WELAssignmentImageView:(UIImageView *)imageView image:(UIImage *)image {
    imageView.image = image;
}

-(void)WELAssignmentButtonImage:(UIButton *)button image:(UIImage *)image {
    [button setBackgroundImage:image forState:UIControlStateNormal];
}

#pragma mark-
#pragma mark-  ui mapping text

-(void)WELAssignmentTextEntity:(id)UIEntity text:(NSString *)text {
    if([[UIEntity class] isSubclassOfClass:[UIButton class]]) {
        [self WELAssignmentButtonText:UIEntity text:text];
    } else {
        [UIEntity setValue:text forKey:@"text"];
    }
}

-(void)WELAssignmentButtonText:(UIButton *)button text:(NSString *)text {
    [button setTitle:text forState:UIControlStateNormal];
}

-(NSString *)WELModelValueToString:(id)value {
    if([[value class] isSubclassOfClass:[NSNumber class]]) {
        return [[NSString alloc] initWithFormat:@"%@",value];
    } else if ([[value class] isSubclassOfClass:[NSString class]]) {
        return value;
    } else {
        return @"";
    }
}

@end


