//
//  PanoViewController.m
//  FeiLu
//
//  Created by lance on 8/26/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "PanoViewController.h"
#import "CLTree.h"
#import "GDataXMLNode.h"

@interface PanoViewController ()

@property (strong,nonatomic) UITableView* myTableView;
@property(strong,nonatomic) NSMutableArray* dataArray; //保存全部数据的数组
@property(strong,nonatomic) NSArray *displayArray;   //保存要显示在界面上的数据的数组
@property (strong,nonatomic) UIActivityIndicatorView *activityIndicator; //指示器




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
    [self.myTableView removeFromSuperview];
    [self.view addSubview:self.panoView];
    [self.view sendSubviewToBack:self.panoView];
}

-(void)removePanoView
{
    [self.panoView removeFromSuperview ];
    [self initBudgetView];
}


-(void)initBudgetView
{
    _myTableView = [[UITableView alloc]init];
    _myTableView.dataSource = self;
    _myTableView.delegate = self;
    CGRect tableViewFrame = CGRectMake(0, self.view.frame.size.height*0.16, self.view.frame.size.width, self.view.frame.size.height);
    
    self.dataArray=[[NSMutableArray alloc]init];
    
    _myTableView.frame = tableViewFrame;
    [self.view addSubview:_myTableView];
    [self.view sendSubviewToBack:_myTableView];
    [self addTestData];//添加演示数据
    [self reloadDataForDisplayArray];//初始化将要显示的数据
}

//添加演示数据
-(void) addTestData{
    NSError *error;
    //将xml序号传入字符串
    NSString *strXMLURL=[NSString stringWithFormat:@"http://localhost:8080/xml%ld.xml",(long)[self.xmlIndex intValue]];
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
        NSString *clNode2Name=[[node2 attributeForName:@"name"]stringValue];
        CLTreeViewNode *clNode2=[self getCLNodeWithName:clNode2Name NodelLevel:0 NodelContent:nil];
        
        
        NSMutableArray *arrCLNode3=[[NSMutableArray alloc]init];
        NSArray *arrNode3=[node2 children];
        for (GDataXMLElement *node3 in arrNode3)
        {
            NSString *clNode3Name=[[node3 attributeForName:@"name"]stringValue];
            NSString *clNode3Content=[[node3 attributeForName:@"budget"]stringValue];
            CLTreeViewNode *clNode3=[self getCLNodeWithName:clNode3Name NodelLevel:1 NodelContent:clNode3Content];
            [arrCLNode3 addObject:clNode3];
            
            NSMutableArray *arrCLNode4=[[NSMutableArray alloc]init];
            NSArray *arrNode4=[node3 children];
            for (GDataXMLElement *node4 in arrNode4)
            {
                 //NSLog(@"%@",[[node4 attributeForName:@"item_name"]stringValue]);
                 NSString *clNode4Name=[[node4 attributeForName:@"item_name"]stringValue];
                 NSString *clNode4Content=[[node4 attributeForName:@"item_total"]stringValue];
                 CLTreeViewNode *clNode4=[self getCLNodeWithName:clNode4Name NodelLevel:2 NodelContent:clNode4Content];
                [arrCLNode4 addObject:clNode4];
                
            }
            clNode3.sonNodes=arrCLNode4;
        }
        clNode2.sonNodes=arrCLNode3;
        [self.dataArray addObject:clNode2];
    }

    
}

-(CLTreeViewNode *)getCLNodeWithName:(NSString *)name NodelLevel:(NSUInteger)nodeLevel NodelContent:(NSString*)nodeContent
{
    CLTreeViewNode *clNode=[[CLTreeViewNode alloc]init];
    if (nodeLevel==0)
    {
        clNode.nodeLevel=0;
        clNode.type=0;
        clNode.sonNodes=nil;
        CLTreeView_LEVEL0_Model *clNodeModel=[[CLTreeView_LEVEL0_Model alloc]init];
        clNodeModel.name=name;
        clNodeModel.headImgPath=@"contacts_collect.png";
        clNodeModel.headImgUrl=nil;
        clNode.nodeData=clNodeModel;
    }
    else if(nodeLevel==1)
    {
        clNode.nodeLevel = 1;
        clNode.type = 1;
        clNode.sonNodes = nil;
        clNode.isExpanded = FALSE;
        CLTreeView_LEVEL1_Model *clNodeModel =[[CLTreeView_LEVEL1_Model alloc]init];
        clNodeModel.name = name;
        clNodeModel.sonCnt =nodeContent;
        clNode.nodeData = clNodeModel;
    }
    else
    {
        clNode.nodeLevel = 2;
        clNode.type = 2;
        clNode.sonNodes = nil;
        clNode.isExpanded = FALSE;
        CLTreeView_LEVEL2_Model *clNodeModel =[[CLTreeView_LEVEL2_Model alloc]init];
        clNodeModel.name = name;
        clNodeModel.signture =nodeContent;
        clNodeModel.headImgPath = @"head6.jpg";
        clNodeModel.headImgUrl = nil;
        clNode.nodeData = clNodeModel;

    }
    
    
    return clNode;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section{
    return _displayArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"level0cell";
    static NSString *indentifier1 = @"level1cell";
    static NSString *indentifier2 = @"level2cell";
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    
    if(node.type == 0){//类型为0的cell
        CLTreeView_LEVEL0_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level0_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];//重新给cell装载数据
        [cell setNeedsDisplay]; //重新描绘cell
        return cell;
    }
    else if(node.type == 1){//类型为1的cell
        CLTreeView_LEVEL1_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier1];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level1_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
    else{//类型为2的cell
        CLTreeView_LEVEL2_Cell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier2];
        if(cell == nil){
            cell = [[[NSBundle mainBundle] loadNibNamed:@"Level2_Cell" owner:self options:nil] lastObject];
        }
        cell.node = node;
        [self loadDataForTreeViewCell:cell with:node];
        [cell setNeedsDisplay];
        return cell;
    }
}

/*---------------------------------------
 为不同类型cell填充数据
 --------------------------------------- */
-(void) loadDataForTreeViewCell:(UITableViewCell*)cell with:(CLTreeViewNode*)node{
    if(node.type == 0){
        CLTreeView_LEVEL0_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL0_Cell*)cell).name.text = nodeData.name;
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL0_Cell*)cell).imageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
    
    else if(node.type == 1){
        CLTreeView_LEVEL1_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL1_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL1_Cell*)cell).sonCount.text = nodeData.sonCnt;
    }
    
    else{
        CLTreeView_LEVEL2_Model *nodeData = node.nodeData;
        ((CLTreeView_LEVEL2_Cell*)cell).name.text = nodeData.name;
        ((CLTreeView_LEVEL2_Cell*)cell).signture.text = nodeData.signture;
        if(nodeData.headImgPath != nil){
            //本地图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageNamed:nodeData.headImgPath]];
        }
        else if (nodeData.headImgUrl != nil){
            //加载图片，这里是同步操作。建议使用SDWebImage异步加载图片
            [((CLTreeView_LEVEL2_Cell*)cell).headImg setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:nodeData.headImgUrl]]];
        }
    }
}

/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return 50;
}

/*---------------------------------------
 处理cell选中事件，需要自定义的部分
 --------------------------------------- */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CLTreeViewNode *node = [_displayArray objectAtIndex:indexPath.row];
    [self reloadDataForDisplayArrayChangeAt:indexPath.row];//修改cell的状态(关闭或打开)
    if(node.type == 2){
        //处理叶子节点选中，此处需要自定义
    }
    else{
        CLTreeView_LEVEL0_Cell *cell = (CLTreeView_LEVEL0_Cell*)[tableView cellForRowAtIndexPath:indexPath];
        if(cell.node.isExpanded ){
            [self rotateArrow:cell with:M_PI_2];
        }
        else{
            [self rotateArrow:cell with:0];
        }
    }
}

/*---------------------------------------
 旋转箭头图标
 --------------------------------------- */
-(void) rotateArrow:(CLTreeView_LEVEL0_Cell*) cell with:(double)degree{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        cell.arrowView.layer.transform = CATransform3DMakeRotation(degree, 0, 0, 1);
    } completion:NULL];
}

/*---------------------------------------
 初始化将要显示的cell的数据
 --------------------------------------- */
-(void) reloadDataForDisplayArray{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.myTableView reloadData];
}

/*---------------------------------------
 修改cell的状态(关闭或打开)
 --------------------------------------- */
-(void) reloadDataForDisplayArrayChangeAt:(NSInteger)row{
    NSMutableArray *tmp = [[NSMutableArray alloc]init];
    NSInteger cnt=0;
    for (CLTreeViewNode *node in _dataArray) {
        [tmp addObject:node];
        if(cnt == row){
            node.isExpanded = !node.isExpanded;
        }
        ++cnt;
        if(node.isExpanded){
            for(CLTreeViewNode *node2 in node.sonNodes){
                [tmp addObject:node2];
                if(cnt == row){
                    node2.isExpanded = !node2.isExpanded;
                }
                ++cnt;
                if(node2.isExpanded){
                    for(CLTreeViewNode *node3 in node2.sonNodes){
                        [tmp addObject:node3];
                        ++cnt;
                    }
                }
            }
        }
    }
    _displayArray = [NSArray arrayWithArray:tmp];
    [self.myTableView reloadData];
}


-(UIWebView*)initiliazePanoView
{
    UIWebView *panoView=[[UIWebView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/15, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*14/15)];
    [panoView setBackgroundColor:[UIColor whiteColor]];
    [panoView setDelegate:self];
    panoView.scrollView.scrollEnabled=NO;
    NSURLRequest *request=[NSURLRequest requestWithURL:self.panoURL cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:60.0f];
    NSLog(@"%@",self.panoURL);
    [panoView loadRequest:request];
    
    return panoView;

}



-(void)webViewDidStartLoad:(UIWebView *)webView //设置加载进度委托事件
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/15, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*14/15)];
    [view setTag:108];
    [view setBackgroundColor:[UIColor blackColor]];
    [view setAlpha:0.5];
    [self.view addSubview:view];
    
     self.activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
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


-(void)initSectionBar
{
    NSArray *sectionArr=[[NSArray alloc] initWithObjects:@"设计效果",@"设计方案",nil];
    UISegmentedControl *sectionControl=[[UISegmentedControl alloc] initWithItems:sectionArr];
    [sectionControl setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/10.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/15)];
    [sectionControl setSelectedSegmentIndex:0];
    
    [sectionControl addTarget:self action:@selector(switchSection:) forControlEvents:UIControlEventValueChanged];
    [sectionControl setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:sectionControl];
    [self.view bringSubviewToFront:sectionControl];
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
