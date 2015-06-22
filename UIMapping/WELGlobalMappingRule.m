//
//  WELGlobalMappingRule.m
//  WELUIMapping
//
//  Created by WELCommand on 15/6/13.
//  Copyright (c) 2015年 WELCommand. All rights reserved.
//

#import "WELGlobalMappingRule.h"


@interface WELGlobalMappingRule() {
    NSMutableDictionary *imageEnumDec_M;
    NSMutableDictionary *sameMeaning_M;
}

@end


@implementation WELGlobalMappingRule

+(instancetype)globalRule {
    static WELGlobalMappingRule *globalRule = nil;
    static dispatch_once_t onces;
    dispatch_once(&onces, ^{
        globalRule = [[WELGlobalMappingRule alloc] init];
    });
    return globalRule;
}

-(instancetype)init {
    return [WELGlobalMappingRule globalRule];
}

#pragma mark-
#pragma mark- image Rule

-(void)registerImageRequestRule:(WELImageRequestRule)reqRule {
    _imageRequestRule = [reqRule copy];
}
-(void)registerImageURLSpliceRule:(WELImageURLStringSpliceRule)urlSpliceRele {
    _imageUrlRule = [urlSpliceRele copy];
}
-(void)registerTextSpliceRule:(WELTextSpliceRule)spliceRule {
    _textSpliceRule = [spliceRule copy];
}

-(void)addImageEnumRuleWithKey:(NSString *)imageKey  enumerationDescription:(NSString *)enumDes {
    if(!imageKey || !enumDes) return;
    [imageEnumDec_M removeObjectForKey:imageKey];
    [imageEnumDec_M addEntriesFromDictionary:@{imageKey : enumDes}];
}

-(void)addSameMeaningKeys:(NSArray *)keys {
    
    NSString *keysValue = [keys firstObject];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    __block BOOL keysRepeat = NO;
    [keys enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL *stop) {
        [dic addEntriesFromDictionary:@{obj:keysValue}];
        keysRepeat = [sameMeaning_M objectForKey:obj];
    }];
    if(keysRepeat){
        NSLog(@" (╯‵□′)╯︵┻━┻ keys can not Repeat");
        return;
    }
    [sameMeaning_M addEntriesFromDictionary:dic];
}


-(void)searchSameMeaningKeysWithKey:(NSString *)key block:(void (^)(NSString *sameKey, BOOL *stop))block {
    NSString *value = [sameMeaning_M objectForKey:key];
    if(value) {
        NSArray *sameMeaningKeys = [sameMeaning_M allKeysForObject:value];
        __block BOOL stop = NO;
        for(NSInteger i = 0; i < sameMeaningKeys.count; i++) {
            if(![sameMeaningKeys[i] isEqualToString:key]) {
                block(sameMeaningKeys[i],&stop);
            }
            if(stop) break;
        }
    }
}


#pragma mark-
#pragma mark- get/set

-(NSDictionary *)imageEnumDec {
    if(!imageEnumDec_M) {
        imageEnumDec_M = [[NSMutableDictionary alloc] init];
    }
    return [imageEnumDec_M copy];
}

-(NSDictionary *)sameMeaningKeys {
    if(!sameMeaning_M) {
        sameMeaning_M = [[NSMutableDictionary alloc] init];
    }
    return [sameMeaning_M copy];
}

@end
