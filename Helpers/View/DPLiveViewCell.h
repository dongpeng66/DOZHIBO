//
//  DPLiveViewCell.h
//  DOZHIBO
//
//  Created by IOS on 16/7/12.
//  Copyright © 2016年 琅琊榜. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DPLiveViewModel.h"
@interface DPLiveViewCell : UITableViewCell
@property (nonatomic, strong)UIImageView * iconImage;// 用户头像

@property (nonatomic, strong)UILabel * nameLabel;// 用户姓名

@property (nonatomic, strong)UIButton * address;// 用户地址

@property (nonatomic, strong)UILabel *peopleNumber;// 观看人数

@property (nonatomic, strong)UIImageView * coverImage;// 封面

@property (nonatomic, strong)DPLiveViewModel * viewModel;
@end
