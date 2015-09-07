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


//加入广告栏
-(void)initAdvertiseBar
{
    
    EScrollerView *scroller=[[EScrollerView alloc]
                             initWithFrameRect:CGRectMake(0,
                                                          [UIScreen mainScreen].bounds.size.height*0.09f,
                                                          [UIScreen mainScreen].bounds.size.width,
                                                          [UIScreen mainScreen].bounds.size.height*0.2f)
                             ImageArray:[NSArray arrayWithObjects:@"home_page1.png",@"home_page2.png",
                                         @"home_page3.png",@"home_page4", nil]
                             TitleArray:[NSArray
                                         arrayWithObjects:@"11",@"22",@"33",@"44", nil]];
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
                                     [UIScreen mainScreen].bounds.size.height*0.3f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f )];
    [self.view addSubview:adLogo1View];
    
    UIImageView *adLogo2View=[[UIImageView alloc]initWithImage:adLogo2];
    [adLogo2View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.433f,
                                     [UIScreen mainScreen].bounds.size.height*0.3f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f )];
    [self.view addSubview:adLogo2View];
    
    UIImageView *adLogo3View=[[UIImageView alloc]initWithImage:adLogo3];
    [adLogo3View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.8f,
                                     [UIScreen mainScreen].bounds.size.height*0.3f,
                                     [UIScreen mainScreen].bounds.size.width*0.125f,
                                     [UIScreen mainScreen].bounds.size.width*0.125 )];
    [self.view addSubview:adLogo3View];
    
}

-(void)initVedio
{
    NSString *string=[NSString stringWithFormat:@"<iframe height=%f width=%f src='http://player.youku.com/embed/XNzE4MzgyMzYw' frameborder=0 allowfullscreen></iframe>",
                      [UIScreen mainScreen].bounds.size.width*0.66f,
                      [UIScreen mainScreen].bounds.size.width*0.93f];
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,
                                                                  [UIScreen mainScreen].bounds.size.height*0.4f,
                                                                  [UIScreen mainScreen].bounds.size.width,
                                                                  [UIScreen mainScreen].bounds.size.height*1.5f)];
    [webView loadHTMLString:string baseURL:nil];
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


