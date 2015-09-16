//
//  ViewController.m
//  RCloudMessage
//
//  Created by lance on 9/9/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

#import "PlanDetailViewController.h"
#import "GDataXMLNode.h"
#import "BudgetSubViewController.h"
#import <ShareSDK/ShareSDK.h>


@interface PlanDetailViewController ()
@property (nonatomic,retain) NSMutableArray *arrBudgetName;   //预算名称列表
@property (nonatomic,retain) NSMutableArray *arrBudgetTotal;  //预算合计列表

@end

@implementation PlanDetailViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    [self initializeData];           //加载数据
    [self initShareSdkBtn];
    [self parserXML];                //解析xml
    [self initiliazePanoView];
    [self selectPanoView];
    [self initSectionBar];
    
}



-(void)selectPanoView
{
    if ([self.curSectionIndex isEqualToNumber:[NSNumber numberWithInteger:1]])
        {
            [self.perspView removeFromSuperview];
        }
    else if([self.curSectionIndex isEqualToNumber:[NSNumber numberWithInteger:2]])
          {
              [self.budgetTblView removeFromSuperview];
          }
    self.curSectionIndex=[NSNumber numberWithInteger:0];
    
    [self.view addSubview:self.panoView];
    [self.view sendSubviewToBack:self.panoView];
}

-(void)selectPerspView
{
    if ([self.curSectionIndex isEqualToNumber:[NSNumber numberWithInteger:0]])
    {
        [self.panoView removeFromSuperview];
    }
    else if([self.curSectionIndex isEqualToNumber:[NSNumber numberWithInteger:2]])
    {
        [self.budgetTblView removeFromSuperview];
    }
    
    self.curSectionIndex=[NSNumber numberWithInteger:1];
    
    [self initPerspView];
}


-(void)selectBudgetView
{
    
    if ([self.curSectionIndex isEqualToNumber:[NSNumber numberWithInteger:0]])
    {
        [self.panoView removeFromSuperview];
    }
    else if([self.curSectionIndex isEqualToNumber:[NSNumber numberWithInteger:1]])
    {
        [self.perspView removeFromSuperview];
    }
    
    self.curSectionIndex=[NSNumber numberWithInteger:2];


    [self initBudgetTableView];
    [self.view bringSubviewToFront:self.sectionControl];
}




//添加演示数据

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//------------------------------------------------------------------------------------------------------------------
//初始化数据
-(void)initializeData
{
    self.arrBudgetName=[[NSMutableArray alloc]init];
    self.arrBudgetTotal=[[NSMutableArray alloc]init];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    self.curSectionIndex=[NSNumber numberWithInteger:0];//设置初始进度条位置为0，为全景页面
    
}





//全景图部分
//---------------------------------------------------------------------------------------------------------------------
-(void)initiliazePanoView
{
    self.panoView=[[UIWebView alloc]initWithFrame:CGRectMake(0,
                                                             [UIScreen mainScreen].bounds.size.height*0.066f,
                                                             [UIScreen mainScreen].bounds.size.width,
                                                             [UIScreen mainScreen].bounds.size.height*0.853f)];

    [self.panoView setBackgroundColor:[UIColor whiteColor]];
    [self.panoView setDelegate:self];
    self.panoView.scrollView.scrollEnabled=NO;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:self.panoURL] cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0f];
    [self.panoView loadRequest:request];
    
    
    
    
}


-(void)initShareSdkBtn
{
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.8f,
                                  [UIScreen mainScreen].bounds.size.height*0.015f,
                                  [UIScreen mainScreen].bounds.size.width*0.115f,
                                  [UIScreen mainScreen].bounds.size.height*0.05f)];

    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn.titleLabel setAdjustsFontSizeToFitWidth:YES];
    [shareBtn addTarget:self action:@selector(pressedShareSDKBtn:) forControlEvents:UIControlEventTouchDown];
    [self.navigationController.navigationBar addSubview:shareBtn];
    
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
//-------------------------------------------------------------------------------------------------------------------
//预算表页面
-(void)initBudgetTableView
{
    self.budgetTblView=[[UITableView alloc]init];
    [self.budgetTblView setBackgroundColor:[UIColor whiteColor]];
    CGRect ViewFrame = CGRectMake(0,
                                  self.view.frame.size.height*0.066,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);
    [self.budgetTblView setFrame:ViewFrame];
    [self.budgetTblView setScrollEnabled:NO];
    
    [self.view addSubview:self.budgetTblView];
    self.budgetTblView.delegate=self;
    self.budgetTblView.dataSource=self;
    
}

-(void)pressedShareSDKBtn:(id)sender
{
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"ShareSDK" ofType:@"png"];
    
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:@"分享内容"
                                       defaultContent:@"测试一下"
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"ShareSDK"
                                                  url:@"http://www.mob.com"
                                          description:@"这是一条测试信息"
                                            mediaType:SSPublishContentMediaTypeNews];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", [error errorCode], [error errorDescription]);
                                }
                            }];
    NSLog(@"bbbb");
}


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *budgetTblViewIdentifier=@"BudgetTblViewIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:budgetTblViewIdentifier];
    NSUInteger row=[indexPath row];
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]
              initWithStyle:UITableViewCellStyleValue2
              reuseIdentifier:budgetTblViewIdentifier];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        CALayer *nameLayer=[self getNameLayerWithRowIndex:row];   //预算名称
        [cell.layer addSublayer:nameLayer];
        
        CALayer *totalLayer=[self getTotalLayerWithRowIndex:row];  //预算金额
        [cell.layer addSublayer:totalLayer];
        
        UIButton *detailBtn=[self getDetailBtn:row];               //添加查看详情按钮
        [cell.contentView addSubview:detailBtn];
        
        
        
    }
    return  cell;
}

-(CALayer*)getNameLayerWithRowIndex:(NSUInteger)rowIndex
{
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"Helvetica"];
    [nameLayer setFontSize:18];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.1f,
                                   [UIScreen mainScreen].bounds.size.height*0.04f,
                                   [UIScreen mainScreen].bounds.size.width*0.6f,
                                   [UIScreen mainScreen].bounds.size.height*0.5f)];
    
    [nameLayer setString:[self.arrBudgetName objectAtIndex:rowIndex]];
    [nameLayer setAlignmentMode:kCAAlignmentLeft];
    [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    [nameLayer setContentsScale:2];
    
    return nameLayer;
    
}

-(CALayer*)getTotalLayerWithRowIndex:(NSUInteger)rowIndex
{
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"Helvetica"];
    [nameLayer setFontSize:17];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.1f,
                                   [UIScreen mainScreen].bounds.size.height*0.10f,
                                   [UIScreen mainScreen].bounds.size.width*0.6f,
                                   [UIScreen mainScreen].bounds.size.height*0.5f)];
    NSString *budgetStr=[NSString stringWithFormat:@"报价合计:%@",[self.arrBudgetTotal objectAtIndex:rowIndex]];
    
    [nameLayer setString:budgetStr];
    [nameLayer setAlignmentMode:kCAAlignmentLeft];
    [nameLayer setForegroundColor:[[UIColor blueColor] CGColor]];
    [nameLayer setContentsScale:2];
    
    return nameLayer;
    
}

-(UIButton *)getDetailBtn:(NSUInteger)rowInex
{
    
    UIButton *detailBtn=[[UIButton alloc]init];
    CGRect btnFrame=CGRectMake([UIScreen mainScreen].bounds.size.width*0.7f,
                               [UIScreen mainScreen].bounds.size.height*0.05f,
                               [UIScreen mainScreen].bounds.size.width*0.2f,
                               [UIScreen mainScreen].bounds.size.height*0.05f);
    [detailBtn setFrame:btnFrame];
    [detailBtn.layer setCornerRadius:[UIScreen mainScreen].bounds.size.width/80];
    [detailBtn setBackgroundColor:[UIColor colorWithRed:0.0f
                                                  green:0.584f
                                                   blue:0.815f
                                                  alpha:1]];
    
    [detailBtn setTitle:@"详 情" forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(pressedDetailBtn:) forControlEvents:UIControlEventTouchDown];
    [detailBtn setTag:rowInex];
    
    return detailBtn;
}

-(void)pressedDetailBtn:(UIButton *)btn
{
    NSUInteger max_index=self.arrBudgetName.count;
    for (NSUInteger i=0; i<max_index; i++)
    {
        if (btn.tag==i)
        {
            
            
            BudgetSubViewController *budgetSubVC=[[BudgetSubViewController alloc]init];
            budgetSubVC.xmlIndex=self.xmlIndex;
            budgetSubVC.xmlSubIndex=[[NSNumber alloc]initWithUnsignedLong:i];
            [self.navigationController pushViewController:budgetSubVC animated:YES];
            
        }
    }
}




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height*0.15f;
}
//-------------------------------------------------------------------------------------------------------------------
//透视图页面

-(void)initPerspView
{
    self.perspView=[[UIView alloc]init];
    [self.perspView setFrame:CGRectMake(0,
                                        [UIScreen mainScreen].bounds.size.height*0.066f,
                                        [UIScreen mainScreen].bounds.size.width,
                                        [UIScreen mainScreen].bounds.size.height*0.9f)];
    [self.perspView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:self.perspView];
}


//-------------------------------------------------------------------------------------------------------------------
//xml读取

-(void)parserXML
{
    NSError *error;
    NSString *strXMLURL=[NSString stringWithFormat:@"http://101.200.196.121:8080/xml%ld.xml",(long)[self.xmlIndex intValue]];
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:strXMLURL]];
    NSData *reposne=[NSURLConnection sendSynchronousRequest:requset returningResponse:nil error:nil];
    NSString *str=[[NSString alloc]initWithData:reposne encoding:NSUTF8StringEncoding];
    //NSLog(@"%@",str);
    GDataXMLDocument *xmlDoc=[[GDataXMLDocument alloc]initWithXMLString:str encoding:NSUTF8StringEncoding error:&error];
    GDataXMLElement *rootEle=[xmlDoc rootElement];
    NSArray *arrNode1=[rootEle children];
    GDataXMLElement *node11=[arrNode1 objectAtIndex:0];
    NSArray *arrNode2=[node11 children];
    for (GDataXMLElement *node2 in arrNode2)
    {
        NSString *tempBudgetName=[[node2 attributeForName:@"name"]stringValue];
        [self.arrBudgetName addObject:tempBudgetName ];                           //将遍历名称加入队列
        
        NSArray *arrNode3=[node2 children];
        GDataXMLElement *node3=[arrNode3 lastObject];
        NSString *tempBudgetTotal=[[node3 attributeForName:@"budget"]stringValue];
        [self.arrBudgetTotal addObject:tempBudgetTotal];                          //将遍历金额加入队列
    }
    
    
}


//-------------------------------------------------------------------------------------------------------------------
//切换条
-(void)initSectionBar
{
    NSArray *sectionArr=[[NSArray alloc] initWithObjects:@"全景方案",@"预算方案",@"平面方案",nil];
    self.sectionControl=[[SVSegmentedControl alloc]initWithSectionTitles:sectionArr];
    [self.sectionControl setFrame:CGRectMake(0,
                                             [UIScreen mainScreen].bounds.size.height*0.003f,
                                             [UIScreen mainScreen].bounds.size.width,
                                             [UIScreen mainScreen].bounds.size.height*0.067f)];
    
    [self.sectionControl.layer setBorderWidth:0.0f];
    [self.sectionControl setTextColor:[UIColor grayColor]];
    [self.sectionControl setBackgroundTintColor:[UIColor colorWithWhite:0.0f alpha:0.0f]];
    
    [self.sectionControl addTarget:self action:@selector(switchSection:) forControlEvents:UIControlEventValueChanged];
    [self.sectionControl setBackgroundColor:[UIColor whiteColor]];
    [self.sectionControl setTintColor:[UIColor whiteColor]];
    [self.sectionControl setTextShadowColor:[UIColor colorWithWhite:1.0f alpha:0.0f]];
    [self.sectionControl setInnerShadowColor:[UIColor whiteColor]];
    [self.sectionControl.thumb setTintColor:[UIColor colorWithRed:0.0f/255.0f green:180.0f/255.0f blue:255.0f/255.0f alpha:1.0f]];
    [self.view addSubview:self.sectionControl];
    [self.view bringSubviewToFront:self.sectionControl];
}






-(void)switchSection:(UISegmentedControl*)seg //设置分业委托方法
{
    NSInteger index=seg.selectedSegmentIndex;
    switch (index) {
        case 0:[self selectPanoView];break;
        case 1:[self selectPerspView];break;
        case 2:[self selectBudgetView];break;
        default: NSLog(@"Segment number error"); break;
    }
    
}
//------------------------------------------------------------------------------------------------------------------



@end