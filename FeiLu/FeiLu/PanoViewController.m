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
    
    [self initPanoView];
    //[self initSectionBar];
    
}
/*
-(void)initBackgroundView
{
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgView];

}
*/
-(void)initPanoView
{
    UIWebView *panoView=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height)];
    NSURLRequest *request=[NSURLRequest requestWithURL:self.panoURL cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30.0f];
    NSLog(@"%@",self.panoURL);
    [panoView loadRequest:request];
    [self.view addSubview:panoView];
}

-(void)initSectionBar
{
    NSArray *sectionArr=[[NSArray alloc] initWithObjects:@"1",@"2",nil];
    UISegmentedControl *sectionControl=[[UISegmentedControl alloc] initWithItems:sectionArr];
    [sectionControl setFrame:CGRectMake(0, self.navigationController.navigationBar.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/15)];
    [sectionControl setSelectedSegmentIndex:2];
    
    
    [self.view addSubview:sectionControl];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



@end
