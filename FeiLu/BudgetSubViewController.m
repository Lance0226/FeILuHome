//
//  BudgetSubVC.m
//  RCloudMessage
//
//  Created by lance on 9/9/15.
//  Copyright (c) 2015 RongCloud. All rights reserved.
//

//
//  ViewController.m
//  FeiLu
//
//  Created by lance on 9/1/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "BudgetSubViewController.h"
#import "GDataXMLNode.h"

#import "RATreeView.h"
#import "RADataObject.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface BudgetSubViewController ()<RATreeViewDelegate, RATreeViewDataSource>

@property (strong, nonatomic) NSMutableArray *data;
@property (strong, nonatomic) id expanded;
@property (weak, nonatomic) RATreeView *treeView;


@end

@implementation BudgetSubViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    
    self.data =[[NSMutableArray alloc]init];
    [self addTestData];
    
    RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.frame];
    
    treeView.delegate = self;
    treeView.dataSource = self;
    treeView.separatorStyle = RATreeViewCellSeparatorStyleSingleLine;
    
    [treeView reloadData];
    [treeView setBackgroundColor:UIColorFromRGB(0xF7F7F7)];
    
    self.treeView = treeView;
    [self.view addSubview:treeView];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) addTestData{
    NSError *error;
    //将xml序号传入字符串
    self.xmlIndex=[[NSNumber alloc]initWithUnsignedLong:1];
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
    GDataXMLElement *node2=[arrNode2 objectAtIndex:[self.xmlSubIndex integerValue]];
    
    
    
    NSArray *arrNode3=[node2 children];
    int m=-1;
    int n=-1;
    for (GDataXMLElement *node3 in arrNode3) //一级列表循环
    {
        m++;
        
        NSString *node3Name=[[node3 attributeForName:@"name"]stringValue];
        NSString *node3Budget=[[node3 attributeForName:@"budget"]stringValue];
        RADataObject *node3Object=[[RADataObject alloc]initWithName:node3Name budget:node3Budget children:[[NSMutableArray alloc]init]];
        
        NSArray *arrNode4=[node3 children];
        for (GDataXMLElement *node4 in arrNode4)
        {
            n++;
            //NSLog(@"m:%d,n:%d",m,n);
            //根据传入xml参数序号的不同，选择不同的结构体封装
            switch ([self.xmlSubIndex integerValue])
            {
                case 0:{
                    
                    //第一类二级结点数据内容
                    NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                    NSString *node4Budget=[[node4 attributeForName:@"item_total"]stringValue];
                    NSLog(@"%@",node4Budget);
                    RADataObject *node4Object=[[RADataObject alloc]initWithName:node4Name  budget:node4Budget children:nil];
                    [node3Object addChildrenWithNewObject:node4Object];
                    break;
                }
                    
                case 1:{
                    //第二类二级结点数据内容
                    NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                    NSString *node4Budget=[[node4 attributeForName:@"item_total"]stringValue];
                    RADataObject *node4Object=[[RADataObject alloc]initWithName:node4Name budget:node4Budget children:nil];
                    [node3Object addChildrenWithNewObject:node4Object];
                    break;
                }
                    
                case 2:{
                    
                    
                    //第三类二级结点数据内容
                    NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                    NSString *node4Budget=[[node4 attributeForName:@"item_total"]stringValue];
                    RADataObject *node4Object=[[RADataObject alloc]initWithName:node4Name budget:node4Budget children:nil];
                    [node3Object addChildrenWithNewObject:node4Object];
                    break;
                }
                default:break;
            }
            
        }
        [self.data addObject:node3Object];
        
        
    }
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if([[[[UIDevice currentDevice] systemVersion] componentsSeparatedByString:@"."][0] intValue] >= 7) {
        CGRect statusBarViewRect = [[UIApplication sharedApplication] statusBarFrame];
        float heightPadding =0;
        self.treeView.contentInset = UIEdgeInsetsMake(heightPadding, 0.0, 0.0, 0.0);
        self.treeView.contentOffset = CGPointMake(0.0, -heightPadding);
    }
    self.treeView.frame = self.view.bounds;
}

#pragma mark TreeView Delegate methods
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 47;
}

- (NSInteger)treeView:(RATreeView *)treeView indentationLevelForRowForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return 3 * treeNodeInfo.treeDepthLevel;
}

- (BOOL)treeView:(RATreeView *)treeView shouldExpandItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    return YES;
}

- (BOOL)treeView:(RATreeView *)treeView shouldItemBeExpandedAfterDataReload:(id)item treeDepthLevel:(NSInteger)treeDepthLevel
{
    if ([item isEqual:self.expanded]) {
        return YES;
    }
    return NO;
}

- (void)treeView:(RATreeView *)treeView willDisplayCell:(UITableViewCell *)cell forItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.backgroundColor = UIColorFromRGB(0xFFFFFF);
    } else if (treeNodeInfo.treeDepthLevel == 1) {
        cell.backgroundColor = UIColorFromRGB(0xD1EEFC);
    } else if (treeNodeInfo.treeDepthLevel == 2) {
        cell.backgroundColor = UIColorFromRGB(0xE0F8D8);
    }
}

#pragma mark TreeView Data Source

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item treeNodeInfo:(RATreeNodeInfo *)treeNodeInfo
{
    //NSInteger numberOfChildren = [treeNodeInfo.children count];
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    CALayer *budgetLayer=[self getNameLayerWithRowIndex:((RADataObject *)item).budget];
    [cell.layer addSublayer:budgetLayer];
    cell.textLabel.text = ((RADataObject *)item).name;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (treeNodeInfo.treeDepthLevel == 0) {
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}

-(CALayer*)getNameLayerWithRowIndex:(NSString*)budget
{
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"Helvetica"];
    [nameLayer setFontSize:18];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.62f,
                                   [UIScreen mainScreen].bounds.size.height*0.02f,
                                   [UIScreen mainScreen].bounds.size.width*0.4f,
                                   [UIScreen mainScreen].bounds.size.height*0.5f)];
    
    [nameLayer setString:budget];
    [nameLayer setAlignmentMode:kCAAlignmentLeft];
    [nameLayer setForegroundColor:[[UIColor blueColor] CGColor]];
    [nameLayer setContentsScale:2];
    
    return nameLayer;
    
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.data count];
    }
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
    if (item == nil) {
        return [self.data objectAtIndex:index];
    }
    return [data.children objectAtIndex:index];
}

@end