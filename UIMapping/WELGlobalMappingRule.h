//
//  WELGlobalMappingRule.h
//  WELUIMapping
//
//  Created by WELCommand on 15/6/13.
//  Copyright (c) 2015年 WELCommand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^WELImageRequestRule)(UIImageView *imageView, NSURL *URL);
typedef NSString *(^WELImageURLStringSpliceRule)(NSString *modelKey, NSString *subURLString);
typedef NSString *(^WELTextSpliceRule)(NSString *modelKey, NSString *modelValue);


@interface WELGlobalMappingRule : NSObject

+(instancetype)globalRule;

@property (nonatomic, readonly) WELImageRequestRule imageRequestRule;
@property (nonatomic, readonly) WELImageURLStringSpliceRule imageUrlRule;
@property (nonatomic, readonly) WELTextSpliceRule textSpliceRule;
@property (nonatomic, readonly) NSDictionary *imageEnumDec;
@property (nonatomic, readonly) NSDictionary *sameMeaningKeys;


-(void)registerImageRequestRule:(WELImageRequestRule)requestRule;
-(void)registerImageURLSpliceRule:(WELImageURLStringSpliceRule)spliceRele;
-(void)registerTextSpliceRule:(WELTextSpliceRule)spliceRule;

-(void)addImageEnumRuleWithKey:(NSString *)imageKey  enumerationDescription:(NSDictionary *)enumDec;

-(void)addSameMeaningKeys:(NSArray *)keys;
-(void)searchSameMeaningKeysWithKey:(NSString *)key block:(void (^)(NSString *sameKey, BOOL *stop))block;

@end
