//
//  PanoViewController.m
//  FeiLu
//
//  Created by lance on 8/26/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "PanoViewController.h"

@interface PanoViewController ()

@end

@implementation PanoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.panoView=[self initiliazePanoView];
    [self addPanoView];
    [self initSectionBar];
    
}



-(void)addPanoView
{
    [self.view addSubview:self.panoView];
}

-(void)removePanoView
{
    [self.panoView removeFromSuperview];
}

-(UIWebView*)initiliazePanoView
{
    UIWebView *panoView=[[UIWebView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/15, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*14/15)];
    panoView.scrollView.scrollEnabled=NO;
    NSURLRequest *request=[NSURLRequest requestWithURL:self.panoURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    NSLog(@"%@",self.panoURL);
    [panoView loadRequest:request];
    
    return panoView;

}

-(void)initSectionBar
{
    NSArray *sectionArr=[[NSArray alloc] initWithObjects:@"设计效果",@"设计方案",nil];
    UISegmentedControl *sectionControl=[[UISegmentedControl alloc] initWithItems:sectionArr];
    [sectionControl setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/10.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/15)];
    [sectionControl setSelectedSegmentIndex:0];
    [sectionControl.layer setZPosition:222];
    [sectionControl addTarget:self action:@selector(switchSection:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:sectionControl];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

//---------------------------------------------------------------------------------------------------------------------
-(void)switchSection:(UISegmentedControl*)seg //设置分业委托方法
{
    NSInteger index=seg.selectedSegmentIndex;
    switch (index) {
        case 0:[self addPanoView];break;
        case 1:[self removePanoView];break;
        default: NSLog(@"Segment number error"); break;
    }
    
}

@end
