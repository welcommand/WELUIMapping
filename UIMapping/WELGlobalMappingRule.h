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
typedef NSString *(^WELImageURLStringSplic)(NSString *modelKey, NSString *subURLString);
typedef NSString *(^WELTextSplice)(NSString *modelKey, NSString *modelValue);


@interface WELGlobalMappingRule : NSObject

+(instancetype)globalRule;

@property (nonatomic, readonly) WELImageRequestRule imageRequestRule;
@property (nonatomic, readonly) WELImageURLStringSplic imageUrlSplic;
@property (nonatomic, readonly) WELTextSplice textSplice;

@property (nonatomic, readonly) NSDictionary *sameMeaningKeys;

-(void)registerImageRequest:(WELImageRequestRule)requestRule;
-(void)registerImageURLSplice:(WELImageURLStringSplic)spliceRele;
-(void)registerTextSplice:(WELTextSplice)spliceRule;

-(void)addSameMeaningKeys:(NSArray *)keys;
-(void)searchSameMeaningKeysWithKey:(NSString *)key block:(void (^)(NSString *sameKey, BOOL *stop))block;

@end
