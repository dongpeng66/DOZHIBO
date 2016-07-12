//
//  LiveViewController.m
//  DOZHIBO
//
//  Created by IOS on 16/7/12.
//  Copyright © 2016年 琅琊榜. All rights reserved.
//

#import "LiveViewController.h"
#import <PLPlayerKit/PLPlayerKit.h>
#import "MacroDefines.h"
#import "SVProgressHUD.h"
#import "UIImageView+WebCache.h"
#import "DMHeartFlyView.h"
#define enableBackgroundPlay    1
static NSString *status[] = {
    @"PLPlayerStatusUnknow",
    @"PLPlayerStatusPreparing",
    @"PLPlayerStatusReady",
    @"PLPlayerStatusCaching",
    @"PLPlayerStatusPlaying",
    @"PLPlayerStatusPaused",
    @"PLPlayerStatusStopped",
    @"PLPlayerStatusError"
};
@interface LiveViewController ()<PLPlayerDelegate>
@property (nonatomic, strong) PLPlayer  *player;
@property (nonatomic, weak) UIActivityIndicatorView *activityIndicatorView;
@property (nonatomic, assign) int reconnectCount;
@property (nonatomic, strong)UIImageView *dimIamge;
@property (nonatomic, assign)CGFloat heartSize;

@end

@implementation LiveViewController

- (void)setupUI {
    if (self.player.status != PLPlayerStatusError) {
        // add player view
        UIView *playerView = self.player.playerView;
        if (!playerView.superview) {
            playerView.contentMode = UIViewContentModeScaleAspectFit;
            playerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin
            | UIViewAutoresizingFlexibleTopMargin
            | UIViewAutoresizingFlexibleLeftMargin
            | UIViewAutoresizingFlexibleRightMargin
            | UIViewAutoresizingFlexibleWidth
            | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:playerView];
            
            self.dimIamge = [[UIImageView alloc] initWithFrame:self.view.bounds];
            [self.dimIamge sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.meelive.cn/%@",_imageUrl]]];
            
//            ///=======实现毛玻璃的效果
//            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//            
//            UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//            visualEffectView.frame = _dimIamge.bounds;
//            [_dimIamge addSubview:visualEffectView];
//            [self.view addSubview:_dimIamge];
//            ///=======实现毛玻璃的效果
            // 返回
            UIButton * backBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            backBtn.frame = CGRectMake(10, 64 / 2 - 8, 33, 33);
            [backBtn setImage:[UIImage imageNamed:@"返回"] forState:(UIControlStateNormal)];
            [backBtn addTarget:self action:@selector(goBack) forControlEvents:(UIControlEventTouchUpInside)];
            backBtn.layer.shadowColor = [UIColor blackColor].CGColor;
            backBtn.layer.shadowOffset = CGSizeMake(0, 0);
            backBtn.layer.shadowOpacity = 0.5;
            backBtn.layer.shadowRadius = 1;
            [self.view addSubview:backBtn];
            
            // 暂停
            UIButton * playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            playBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width - 33-10, 64 / 2 - 8, 33, 33);
            
            //    if (self.number == 0) {
            //        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateNormal)];
            //        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateSelected)];
            //    }else{
            //        [playBtn setImage:[UIImage imageNamed:@"开始"] forState:(UIControlStateNormal)];
            //        [playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateSelected)];
            //    }
            
            //    [playBtn addTarget:self action:@selector(play_btn:) forControlEvents:(UIControlEventTouchUpInside)];
            playBtn.layer.shadowColor = [UIColor blackColor].CGColor;
            playBtn.layer.shadowOffset = CGSizeMake(0, 0);
            playBtn.layer.shadowOpacity = 0.5;
            playBtn.layer.shadowRadius = 1;
            //    [self.view addSubview:playBtn];
            
            // 点赞
            UIButton * likeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
            likeBtn.frame = CGRectMake(playBtn.frame.origin.x/2, [UIScreen mainScreen].bounds.size.height-33-10, 33, 33);
            [likeBtn setImage:[UIImage imageNamed:@"点赞"] forState:(UIControlStateNormal)];
            [likeBtn addTarget:self action:@selector(showTheLove:) forControlEvents:(UIControlEventTouchUpInside)];
            likeBtn.layer.shadowColor = [UIColor blackColor].CGColor;
            likeBtn.layer.shadowOffset = CGSizeMake(0, 0);
            likeBtn.layer.shadowOpacity = 0.5;
            likeBtn.layer.shadowRadius = 1;
            likeBtn.adjustsImageWhenHighlighted = NO;
            [self.view addSubview:likeBtn];
            
        }
    }
    
}

//// 按钮
//- (void)changeBackBtn
//{
//    
//    
//    
//}

// 返回
- (void)goBack
{
    
    [self.navigationController popViewControllerAnimated:true];
    
}



// 点赞
-(void)showTheLove:(UIButton *)sender{
    DMHeartFlyView* heart = [[DMHeartFlyView alloc]initWithFrame:CGRectMake(0, 0, _heartSize, _heartSize)];
    [self.view addSubview:heart];
    CGPoint fountainSource = CGPointMake(([UIScreen mainScreen].bounds.size.width-_heartSize-10)/2 + _heartSize/2.0, self.view.bounds.size.height - _heartSize/2.0 - 10);
    heart.center = fountainSource;
    [heart animateInView:self.view];
    
    // button点击动画
    CAKeyframeAnimation *btnAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    btnAnimation.values = @[@(1.0),@(0.7),@(0.5),@(0.3),@(0.5),@(0.7),@(1.0), @(1.2), @(1.4), @(1.2), @(1.0)];
    btnAnimation.keyTimes = @[@(0.0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    btnAnimation.calculationMode = kCAAnimationLinear;
    btnAnimation.duration = 0.3;
    [sender.layer addAnimation:btnAnimation forKey:@"SHOW"];
}

- (void)startPlayer {
    [self addActivityIndicatorView];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [self.player play];
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    _heartSize = 36;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    PLPlayerOption *option = [PLPlayerOption defaultOption];
    [option setOptionValue:@10 forKey:PLPlayerOptionKeyTimeoutIntervalForMediaPackets];
    
    self.player = [PLPlayer playerWithURL:[NSURL URLWithString:self.liveUrl] option:option];
    self.player.delegate = self;
    self.player.delegateQueue = dispatch_get_main_queue();
    self.player.backgroundPlayEnable = enableBackgroundPlay;
#if !enableBackgroundPlay
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(startPlayer) name:UIApplicationWillEnterForegroundNotification object:nil];
#endif
    [self setupUI];
    
    [self startPlayer];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)addActivityIndicatorView {
    if (self.activityIndicatorView) {
        return;
    }
    UIActivityIndicatorView *activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    [self.view addSubview:activityIndicatorView];
    [activityIndicatorView stopAnimating];
    
    self.activityIndicatorView = activityIndicatorView;
}

#pragma mark - <PLPlayerDelegate>

- (void)player:(nonnull PLPlayer *)player statusDidChange:(PLPlayerStatus)state {
    if (PLPlayerStatusCaching == state) {
        [self.activityIndicatorView startAnimating];
    } else {
        [self.activityIndicatorView stopAnimating];
        
    }
    NSLog(@"%@", status[state]);
}

- (void)player:(nonnull PLPlayer *)player stoppedWithError:(nullable NSError *)error {
    [self.activityIndicatorView stopAnimating];
    [self tryReconnect:error];
}

- (void)tryReconnect:(nullable NSError *)error {
    if (self.reconnectCount < 3) {
        _reconnectCount ++;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误" message:[NSString stringWithFormat:@"错误 %@，播放器将在%.1f秒后进行第 %d 次重连", error.localizedDescription,0.5 * pow(2, self.reconnectCount - 1), _reconnectCount] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * pow(2, self.reconnectCount) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.player play];
        });
    }else {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                           message:error.localizedDescription
                                                                    preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self) wself = self;
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"OK"
                                                             style:UIAlertActionStyleCancel
                                                           handler:^(UIAlertAction *action) {
                                                               __strong typeof(wself) strongSelf = wself;
                                                               [strongSelf.navigationController performSelectorOnMainThread:@selector(popViewControllerAnimated:) withObject:@(YES) waitUntilDone:NO];
                                                           }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [UIApplication sharedApplication].idleTimerDisabled = NO;
        NSLog(@"%@", error);
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
