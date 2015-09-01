//
//  PanoViewController.m
//  FeiLu
//
//  Created by lance on 8/26/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "BudgetViewController.h"
#import "CLTree.h"
#import "GDataXMLNode.h"

@interface BudgetViewController ()






@end

@implementation BudgetViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initiliazePanoView];
    [self addPanoView];
    [self initSectionBar];
    
}



-(void)addPanoView
{
    [self.budgetTblView removeFromSuperview];
    [self.view addSubview:self.panoView];
    [self.view sendSubviewToBack:self.panoView];
}

-(void)removePanoView
{
    [self.panoView removeFromSuperview ];
    [self initBudgetTableView];
}



//添加演示数据

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





//全景图部分
//---------------------------------------------------------------------------------------------------------------------
-(void)initiliazePanoView
{
   self.panoView=[[UIWebView alloc]initWithFrame:CGRectMake(0,
                                                            [UIScreen mainScreen].bounds.size.height*0.065f,
                                                            [UIScreen mainScreen].bounds.size.width,
                                                            [UIScreen mainScreen].bounds.size.height*0.933f)];
    [self.panoView setBackgroundColor:[UIColor whiteColor]];
    [self.panoView setDelegate:self];
    self.panoView.scrollView.scrollEnabled=NO;
    NSURLRequest *request=[NSURLRequest requestWithURL:self.panoURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0f];
    [self.panoView loadRequest:request];

}



-(void)webViewDidStartLoad:(UIWebView *)webView //设置加载进度委托事件
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/15, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*14/15)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
     self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f,
                                                                                        0.0f,
                                                                                        [UIScreen mainScreen].bounds.size.width,
                                                                                        32.0f)];
    [self.activityIndicator setCenter:view.center];
    [self.activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite];
    [view addSubview:self.activityIndicator];
    
    [self.activityIndicator startAnimating];
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView  //加载完成去掉指示器
{
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error  //加载错误时去掉指示器
{
    [self.activityIndicator stopAnimating];
    UIView *view = (UIView*)[self.view viewWithTag:108];
    [view removeFromSuperview];
    NSLog(@"webViewDidFinishLoad");
    NSLog(@"Fail load :%@",error);
}
//-------------------------------------------------------------------------------------------------------------------

-(void)initBudgetTableView
{
    self.budgetTblView=[[UITableView alloc]init];
    [self.budgetTblView setBackgroundColor:[UIColor whiteColor]];
    CGRect ViewFrame = CGRectMake(0,
                                  self.view.frame.size.height*0.162,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);
    [self.budgetTblView setFrame:ViewFrame];
    [self.budgetTblView setScrollEnabled:NO];
    
    [self.view addSubview:self.budgetTblView];
}


//-------------------------------------------------------------------------------------------------------------------
//切换条
-(void)initSectionBar
{
    NSArray *sectionArr=[[NSArray alloc] initWithObjects:@"设计效果",@"设计方案",nil];
    UISegmentedControl *sectionControl=[[UISegmentedControl alloc] initWithItems:sectionArr];
    [sectionControl setFrame:CGRectMake(0,
                                        [UIScreen mainScreen].bounds.size.height*0.095,
                                        [UIScreen mainScreen].bounds.size.width,
                                        [UIScreen mainScreen].bounds.size.height*0.67)];
    [sectionControl setSelectedSegmentIndex:0];
    
    [sectionControl addTarget:self action:@selector(switchSection:) forControlEvents:UIControlEventValueChanged];
    [sectionControl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:sectionControl];
    [self.view bringSubviewToFront:sectionControl];
}






-(void)switchSection:(UISegmentedControl*)seg //设置分业委托方法
{
    NSInteger index=seg.selectedSegmentIndex;
    switch (index) {
        case 0:[self addPanoView];break;
        case 1:[self removePanoView];break;
        default: NSLog(@"Segment number error"); break;
    }
    
}
//------------------------------------------------------------------------------------------------------------------



@end
