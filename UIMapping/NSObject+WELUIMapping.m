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
#import "WELMappingAssignment.h"

@implementation NSObject (WELUIMapping)

-(void)mappingUIWithModel:(id)model {
    if(![[model class] isSubclassOfClass:[NSDictionary class]]) {
        NSArray *prolist =  [WELMappingAssignment propertyList:model];
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
    
    NSArray *UIProList = [WELMappingAssignment propertyList:self];
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
        
        if([WELMappingAssignment shouldMappingImage:UIEntity]) {
            NSString *urlString = nil;
            if([self respondsToSelector:@selector(customImageURLStringSpliceRuleWithUIKey:subURLString:)]) {
                urlString = [self performSelector:@selector(customImageURLStringSpliceRuleWithUIKey:subURLString:) withObject:modelEntity withObject:modelEntityValue];
            }
            if ((!urlString || urlString.length  == 0) && shareRule.imageUrlRule) {
                urlString = shareRule.imageUrlRule(modelEntity,modelEntityValue);
            }
            if(!urlString || urlString.length  == 0) {
                urlString = modelEntityValue;
            }
            
            NSURL *imageRequestURL = [NSURL URLWithString:urlString];
            if(imageRequestURL && shareRule.imageRequestRule) {
                shareRule.imageRequestRule(UIEntity,imageRequestURL);
                continue;
            } else {
                NSDictionary *imageEnumDic = [shareRule.imageEnumDec objectForKey:modelEntity];
                if(imageEnumDic) {
                    [WELMappingAssignment assignmentImageEntity:UIEntity imageName:[imageEnumDic objectForKey:modelEntityValue]];
                    continue;
                }
            }
        }
        
        if ([WELMappingAssignment shouldMappingText:UIEntity]) {
            
            NSString *text = nil;
            if([self respondsToSelector:@selector(customMappingWithUIKey:modelValue:)]) {
                text = [self performSelector:@selector(customMappingWithUIKey:modelValue:) withObject:modelEntity withObject:modelEntityValue];
            }
            if((!text || text.length == 0) && [self respondsToSelector:@selector(customMappingWithUIKey:model:)]) {
                text = [self performSelector:@selector(customMappingWithUIKey:model:) withObject:modelEntity withObject:data];
            }
            if((!text || text.length == 0) && shareRule.textSpliceRule) {
                text = shareRule.textSpliceRule(modelEntity,modelEntityValue);
            }
            if(!text || text.length == 0) {
                text = modelEntityValue;
            }
            text = [WELMappingAssignment modelValueToString:text];
            [WELMappingAssignment assignmentTextEntity:UIEntity text:text];
        }
    }
}

@end


