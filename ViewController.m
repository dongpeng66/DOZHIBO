//
//  ViewController.m
//  DOZHIBO
//
//  Created by IOS on 16/7/12.
//  Copyright © 2016年 琅琊榜. All rights reserved.
//

#import "ViewController.h"
#import "DPLiveViewCell.h"
#import "ODRefreshControl.h"
#import "NetWorkEngine.h"
#import "DPLiveViewModel.h"
#import "LiveViewController.h"

// 映客接口
#define HomeData [NSString stringWithFormat:@"http://service.ingkee.com/api/live/gettop?imsi=&uid=17800399&proto=5&idfa=A1205EB8-0C9A-4131-A2A2-27B9A1E06622&lc=0000000000000026&cc=TG0001&imei=&sid=20i0a3GAvc8ykfClKMAen8WNeIBKrUwgdG9whVJ0ljXi1Af8hQci3&cv=IK3.1.00_Iphone&devi=bcb94097c7a3f3314be284c8a5be2aaeae66d6ab&conn=Wifi&ua=iPhone&idfv=DEBAD23B-7C6A-4251-B8AF-A95910B778B7&osversion=ios_9.300000&count=5&multiaddr=1"]
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)UITableView * tableView;

@property (nonatomic, strong)NSMutableArray * dataArray;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataArray = [NSMutableArray array];
    self.navigationItem.title =@"映客直播";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self frontView];
    
    [self newData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
#pragma mark-添加tableView
- (void)frontView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.rowHeight = ([UIScreen mainScreen].bounds.size.width * 618/480)+1;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    ODRefreshControl *refreshControl = [[ODRefreshControl alloc] initInScrollView:self.tableView];
    [refreshControl addTarget:self action:@selector(dropViewDidBeginRefreshing:) forControlEvents:UIControlEventValueChanged];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cell";
    DPLiveViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        
        cell = [[DPLiveViewCell alloc] initWithStyle:(UITableViewCellStyleDefault)
                                        reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DPLiveViewModel * viewModel = [self.dataArray objectAtIndex:indexPath.row];
    cell.viewModel = viewModel;
    
    return cell;
    
    
}

// Cell跳转直播
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LiveViewController * liveVc = [[LiveViewController alloc] init];
    DPLiveViewModel * viewModel = self.dataArray[indexPath.row];
//    // 直播url
    liveVc.liveUrl = viewModel.url;
//    // 直播图片
    liveVc.imageUrl = viewModel.portrait;
    [self.navigationController pushViewController:liveVc animated:YES];
//    self.navigationController.navigationBar.hidden = YES;
    
}

// cell动画
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //设置Cell的动画效果为3D效果
    //设置x和y的初始值为0.1；
    cell.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    //x和y的最终值为1
    [UIView animateWithDuration:1 animations:^{
        cell.layer.transform = CATransform3DMakeScale(1, 1, 1);
    }];
}



// 刷新
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
        
    } else {
        
        return YES;
    }
}

- (void)dropViewDidBeginRefreshing:(ODRefreshControl *)refreshControl
{
    double delayInSeconds = 3.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [refreshControl endRefreshing];
        [self newData];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark-获取数据
- (void)newData
{
    [self.dataArray removeAllObjects];
    __weak __typeof(self)vc = self;
    NetWorkEngine * netWork = [[NetWorkEngine alloc] init];
    [netWork AfJSONGetRequest:HomeData];
    netWork.successfulBlock = ^(id object){
        NSArray *listArray = [object objectForKey:@"lives"];
        
        for (NSDictionary *dic in listArray) {
            
            DPLiveViewModel * viewModel = [[DPLiveViewModel alloc] initWithDictionary:dic];
            viewModel.city = dic[@"city"];
            viewModel.portrait = dic[@"creator"][@"portrait"];
            viewModel.name = dic[@"creator"][@"nick"];
            viewModel.online_users = [dic[@"online_users"] intValue];
            viewModel.url = dic[@"stream_addr"];
            [vc.dataArray addObject:viewModel];
            
        }
        [self.tableView reloadData];
        //        NSLog(@"%@",object);
    };
    
}

// 导航栏隐藏
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //    NSLog(@"offset---scroll:%f",self.tableView.contentOffset.y);
    
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
    UIPanGestureRecognizer* pan = scrollView.panGestureRecognizer;
    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
    CGFloat velocity = [pan velocityInView:scrollView].y;
    
    if (velocity<-5) {
        
        //向上拖动，隐藏导航栏
        [self.navigationController setNavigationBarHidden:true animated:true];
    }
    else if (velocity>5) {
        //向下拖动，显示导航栏
        [self.navigationController setNavigationBarHidden:false animated:true];
    }
    else if(velocity==0){
        
        //停止拖拽
    }
}


@end
