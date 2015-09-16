//
//  UIViewController+HomeViewController.m
//  RCloudMessage
//
//  Created by 韩渌 on 15/9/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "HomeViewController.h"
#import "EScrollerView.h"
#import <MediaPlayer/MediaPlayer.h>



@interface HomeViewController ()



@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAdvertiseBar];
    [self initVedio];
    [self initAdLogo];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UILabel *titleView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 44)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = [UIFont boldSystemFontOfSize:19];
    titleView.textColor = [UIColor whiteColor];
    titleView.textAlignment = NSTextAlignmentCenter;
    titleView.text = @"首 页";
    self.tabBarController.navigationItem.titleView = titleView;
    // self.tabBarController.navigationItem.title = @"客服";
    self.tabBarController.navigationItem.rightBarButtonItem = nil;
    
    
}


//加入广告栏
-(void)initAdvertiseBar
{
    
    EScrollerView *scroller=[[EScrollerView alloc]
                             initWithFrameRect:CGRectMake(0,
                                                          [UIScreen mainScreen].bounds.size.height*0.003f,
                                                          [UIScreen mainScreen].bounds.size.width,
                                                          [UIScreen mainScreen].bounds.size.height*0.2f)
                             ImageArray:[NSArray arrayWithObjects:@"home_page1.png",@"home_page2.png",
                                         @"home_page3.png",@"home_page4", nil]
                             TitleArray:[NSArray
                                         arrayWithObjects:@"一",@"二",@"三",@"四", nil]];
    scroller.delegate=self;
    [self.view addSubview:scroller];
    
}


-(void)initAdLogo
{
    UIImage *adLogo1=[UIImage imageNamed:@"home_ad_logo1"];
    UIImage *adLogo2=[UIImage imageNamed:@"home_ad_logo2"];
    UIImage *adLogo3=[UIImage imageNamed:@"home_ad_logo3"];
    
    UIImageView *adLogo1View=[[UIImageView alloc]initWithImage:adLogo1];
    [adLogo1View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.0667f,
                                     [UIScreen mainScreen].bounds.size.height*0.23f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f )];
    [self.view addSubview:adLogo1View];
    
    UIImageView *adLogo2View=[[UIImageView alloc]initWithImage:adLogo2];
    [adLogo2View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.443f,
                                     [UIScreen mainScreen].bounds.size.height*0.23f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f )];
    [self.view addSubview:adLogo2View];
    
    UIImageView *adLogo3View=[[UIImageView alloc]initWithImage:adLogo3];
    [adLogo3View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.8f,
                                     [UIScreen mainScreen].bounds.size.height*0.23f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f,
                                     [UIScreen mainScreen].bounds.size.width*0.125 )];
    [self.view addSubview:adLogo3View];
    
    UILabel *lableLogo1=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.0407f,
                                                                 [UIScreen mainScreen].bounds.size.height*0.29f,
                                                                 [UIScreen mainScreen].bounds.size.width*0.17f,
                                                                 [UIScreen mainScreen].bounds.size.width*0.125f )];
    [lableLogo1 setText:@"广告宣传"];
    [lableLogo1 setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:lableLogo1];
    
    UILabel *lableLogo2=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.418f,
                                                                 [UIScreen mainScreen].bounds.size.height*0.29f,
                                                                 [UIScreen mainScreen].bounds.size.width*0.17f,
                                                                 [UIScreen mainScreen].bounds.size.width*0.125f )];
    [lableLogo2 setText:@"小区推广"];
    [lableLogo2 setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:lableLogo2];
    
    UILabel *lableLogo3=[[UILabel alloc]initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.780f,
                                                                 [UIScreen mainScreen].bounds.size.height*0.29f,
                                                                 [UIScreen mainScreen].bounds.size.width*0.17f,
                                                                 [UIScreen mainScreen].bounds.size.width*0.125f )];
    [lableLogo3 setText:@"个性设计"];
    [lableLogo3 setAdjustsFontSizeToFitWidth:YES];
    [self.view addSubview:lableLogo3];

    
}

-(void)initVedio
{   /*
    NSString *string=[NSString stringWithFormat:@"<iframe height=%f width=%f src='http://player.youku.com/embed/XNzE4MzgyMzYw' frameborder=0 allowfullscreen></iframe>",
                      [UIScreen mainScreen].bounds.size.width*0.66f,
                      [UIScreen mainScreen].bounds.size.width*0.93f];
     */
    
    NSString *str=[NSString stringWithFormat:@"<iframe height=%f width=%f src='http://101.200.196.121:8080/html5/0000.html' frameborder=0 allowfullscreen></iframe>",
                   [UIScreen mainScreen].bounds.size.width*0.66f,
                   [UIScreen mainScreen].bounds.size.width*0.96f];
    
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,
                                                                  [UIScreen mainScreen].bounds.size.height*0.37f,
                                                                  [UIScreen mainScreen].bounds.size.width,
                                                                  [UIScreen mainScreen].bounds.size.height*1.5f)];
    [webView loadHTMLString:str baseURL:nil];
    [self.view addSubview:webView];
}







/*
 -(void)EScrollerViewDidClicked:(NSUInteger)index
 {
 NSLog(@"index--%lu",(unsigned long)index);
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}







@end


