//
//  FirstViewController.m
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAdvertiseBar];
    [self initNavigationBar];
    
   }


//加入广告栏
-(void)initAdvertiseBar
{
    
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/10,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/5)
                                                          ImageArray:[NSArray arrayWithObjects:@"home_page1.png",@"home_page2.png",@"home_page3.png",@"home_page4", nil]
                                                          TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33",@"44", nil]];
    scroller.delegate=self;
    [self.view addSubview:scroller];
    [scroller release];
    
}

-(void)initNavigationBar
{
    self.navBar=[AppDelegate sharedNavigationBar];
    [self.view addSubview:self.navBar];
    
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
