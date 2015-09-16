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
    [self initPano];
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
                             ImageArray:[NSArray arrayWithObjects:@"home_page1.png",
                                         @"home_page3.png",@"home_page5", nil]
                             TitleArray:[NSArray
                                         arrayWithObjects:@"全景APP方案",@"定制化家装方案",@"定制化推广方案", nil]];
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

-(void)initPano
{   /*
    NSString *string=[NSString stringWithFormat:@"<iframe height=%f width=%f src='http://player.youku.com/embed/XNzE4MzgyMzYw' frameborder=0 allowfullscreen></iframe>",
                      [UIScreen mainScreen].bounds.size.width*0.66f,
                      [UIScreen mainScreen].bounds.size.width*0.93f];
     */
    
    NSString *str=@"http://www.xuanran001.com/public/repository/0d02/bda1/00bb/45d9/b490/7755/24bf/7b63/html5/output/0000.html";
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:str]];
    self.webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,
                                                                  [UIScreen mainScreen].bounds.size.height*0.37f,
                                                                  [UIScreen mainScreen].bounds.size.width,
                                                                  [UIScreen mainScreen].bounds.size.height*0.4f)];
    [self.webView loadRequest:request];
    [self.view addSubview:self.webView];
}

-(void)webViewDidStartLoad:(UIWebView *)webView //设置加载进度委托事件
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,
                                                         [UIScreen mainScreen].bounds.size.height*0.066f,
                                                         [UIScreen mainScreen].bounds.size.width,
                                                         [UIScreen mainScreen].bounds.size.height*0.9f)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
    self.indicator = [[UIActivityIndicatorView alloc]
                      initWithFrame:CGRectMake(0.0f,
                                               0.0f,
                                               [UIScreen mainScreen].bounds.size.width*0.1f,
                                               [UIScreen mainScreen].bounds.size.width*0.1f)];
    [self.indicator setCenter:CGPointMake(view.center.x, view.center.y-[UIScreen mainScreen].bounds.size.height*0.2f)];
    [self.indicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:self.indicator];
    
    [self.indicator startAnimating];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView  //加载完成去掉指示器
{
    [self.indicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error  //加载错误时去掉指示器
{
    [self.indicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
    NSLog(@"Fail load :%@",error);
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


