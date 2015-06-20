//
//  NSObject+WELUIMapping.h
//  ECON
//
//  Created by WELCommand on 15/5/26.
//  Copyright (c) 2015年 WELCommand. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface NSObject (WELUIMapping)

-(void)mappingUIWithModel:(id)model;
-(void)mappingUIWithDictionary:(NSDictionary *)dictionary;

@end
