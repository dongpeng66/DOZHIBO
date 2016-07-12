//
//  DPLiveViewModel.m
//  DOZHIBO
//
//  Created by IOS on 16/7/12.
//  Copyright © 2016年 琅琊榜. All rights reserved.
//

#import "DPLiveViewModel.h"

@implementation DPLiveViewModel
- (id)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
    
}
@end
