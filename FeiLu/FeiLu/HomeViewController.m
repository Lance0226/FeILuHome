//
//  FirstViewController.m
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "HomeViewController.h"
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
    
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/11,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/5)
                                                          ImageArray:[NSArray arrayWithObjects:@"home_page1.png",@"home_page2.png",@"home_page3.png",@"home_page4", nil]
                                                          TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33",@"44", nil]];
    scroller.delegate=self;
    [self.view addSubview:scroller];
    
}


-(void)initAdLogo
{
    UIImage *adLogo1=[UIImage imageNamed:@"home_ad_logo1"];
    UIImage *adLogo2=[UIImage imageNamed:@"home_ad_logo2"];
    UIImage *adLogo3=[UIImage imageNamed:@"home_ad_logo3"];
    
    UIImageView *adLogo1View=[[UIImageView alloc]initWithImage:adLogo1];
    [adLogo1View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*1/15, [UIScreen mainScreen].bounds.size.height*0.3, [UIScreen mainScreen].bounds.size.width/8,[UIScreen mainScreen].bounds.size.width/8 )];
    [self.view addSubview:adLogo1View];
    
    UIImageView *adLogo2View=[[UIImageView alloc]initWithImage:adLogo2];
    [adLogo2View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*6.5/15, [UIScreen mainScreen].bounds.size.height*0.3, [UIScreen mainScreen].bounds.size.width/8,[UIScreen mainScreen].bounds.size.width/8 )];
    [self.view addSubview:adLogo2View];
    
    UIImageView *adLogo3View=[[UIImageView alloc]initWithImage:adLogo3];
    [adLogo3View setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*12/15, [UIScreen mainScreen].bounds.size.height*0.3, [UIScreen mainScreen].bounds.size.width/8,[UIScreen mainScreen].bounds.size.width/8 )];
    [self.view addSubview:adLogo3View];
    
}

-(void)initVedio
{
    NSString *string=[NSString stringWithFormat:@"<iframe height=%f width=%f src='http://player.youku.com/embed/XNzE4MzgyMzYw' frameborder=0 allowfullscreen></iframe>",[UIScreen mainScreen].bounds.size.width/3*2,[UIScreen mainScreen].bounds.size.width/15*14];
    UIWebView *webView=[[UIWebView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height*2/5,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2*3)];
    [webView loadHTMLString:string baseURL:nil];
    [self.view addSubview:webView];
}






-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%lu",(unsigned long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}







@end
