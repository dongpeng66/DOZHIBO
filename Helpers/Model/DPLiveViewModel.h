//
//  DPLiveViewModel.h
//  DOZHIBO
//
//  Created by IOS on 16/7/12.
//  Copyright © 2016年 琅琊榜. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DPLiveViewModel : NSObject
@property (nonatomic, strong)NSString * ID;

@property (nonatomic, strong)NSString * city;

@property (nonatomic, strong)NSString * name;

@property (nonatomic, strong)NSString * portrait;

@property (nonatomic, assign)int  online_users;

@property (nonatomic, strong)NSString * url;

- (id)initWithDictionary:(NSDictionary *)dic;
@end
