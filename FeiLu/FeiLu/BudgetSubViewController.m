//
//  ViewController.m
//  FeiLu
//
//  Created by lance on 9/1/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "BudgetSubViewController.h"
#import "GDataXMLNode.h"

@interface BudgetSubViewController ()

@property (retain,nonatomic) UITableView     *subBudgetTableView;
@property (retain,nonatomic) NSMutableArray  *arrNodeType;            //一级二级分级队列
@property (retain,nonatomic) NSMutableArray  *arrNodeEditFlag;        //0为不需要更新 1为需要更新
@property (retain,nonatomic) NSMutableArray  *arrLevelOneNodeStatus;  //一级结点状态队列 0为收缩，1为展开
@property (retain,nonatomic) NSMutableArray  *arrLevelTwoNodeStatus;  //二级结点状态队列 0为隐藏，1为显示

@property (retain,nonatomic) NSMutableArray  *arrLevelOneNode;       //一级节点数组
@property (retain,nonatomic) NSMutableArray  *arrLevelTwoNode;


@end

@implementation BudgetSubViewController

- (void)viewDidLoad
{
        [super viewDidLoad];
        [self initBudgetView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)initBudgetView
{
    self.subBudgetTableView = [[UITableView alloc]init];
    self.subBudgetTableView.dataSource = self;
    self.subBudgetTableView.delegate = self;
    CGRect tableViewFrame = CGRectMake(0,
                                       0,
                                       self.view.frame.size.width,
                                       self.view.frame.size.height);
    
    self.arrNodeType=[[NSMutableArray alloc]init];
    self.arrLevelOneNode=[[NSMutableArray alloc]init];
    self.arrLevelTwoNode=[[NSMutableArray alloc]init];
    self.arrLevelOneNodeStatus=[[NSMutableArray alloc]init];
    self.arrLevelTwoNodeStatus=[[NSMutableArray alloc]init];
    self.arrNodeEditFlag=[[NSMutableArray alloc]init];
    
    self.subBudgetTableView.frame = tableViewFrame;
    [self.view addSubview:_subBudgetTableView];
    [self.view sendSubviewToBack:_subBudgetTableView];
    [self addTestData];//添加演示数据
}

-(void) addTestData{
    NSError *error;
    //将xml序号传入字符串
    self.xmlIndex=[[NSNumber alloc]initWithUnsignedLong:1];
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
    GDataXMLElement *node2=[arrNode2 objectAtIndex:[self.xmlSubIndex integerValue]];
        
        

        NSArray *arrNode3=[node2 children];
        int m=-1;
        int n=-1;
        for (GDataXMLElement *node3 in arrNode3) //一级列表循环
        {
            m++;
    
            NSValue *node3Type=[self setBudgetLevelGroupWithType:0 Category:0 Parent:-1 Index:m Uid:m+n+1];
            [self.arrLevelOneNodeStatus addObject:[NSNumber numberWithInt:0]];//设置所有一级结点起始状态为收缩。
            [self.arrNodeEditFlag addObject:[NSNumber numberWithBool:YES]];
            [self.arrNodeType addObject:node3Type];
            
            //一级结点数据内容部分
            NSString *node3Name=[[node3 attributeForName:@"name"]stringValue];
            NSString *node3Budget=[[node3 attributeForName:@"budget"]stringValue];
            NSValue *node3Content=[self setBudgetLevelOneNodeWithName:node3Name Budget:node3Budget];
            [self.arrLevelOneNode addObject:node3Content];
            
            NSArray *arrNode4=[node3 children];
            for (GDataXMLElement *node4 in arrNode4)
            {
                n++;
                [self.arrLevelTwoNodeStatus addObject:[NSNumber numberWithInt:0]];//设置所有二级结点起始状态为隐藏
                [self.arrNodeEditFlag addObject:[NSNumber numberWithBool:YES]];
                //根据传入xml参数序号的不同，选择不同的结构体封装
                switch ([self.xmlSubIndex integerValue])
                {
                 case 0:{
                         //第一类二级结点数据类型
                         NSValue *node4Type=[self setBudgetLevelGroupWithType:1 Category:0 Parent:m Index:n Uid:m+n+1];
                         [self.arrNodeType addObject:node4Type];
                     
                         //第一类二级结点数据内容
                         NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                         NSValue *node4Content=[self setBudgetLevelTwoTypeOneNodeWithName:node4Name];
                         [self.arrLevelTwoNode addObject:node4Content];
                         break;
                        }
                 
                    case 1:{
                        //第二类二级结点数据类型
                        NSValue *node4Type=[self setBudgetLevelGroupWithType:1 Category:1 Parent:m Index:n Uid:m+n+1];
                        [self.arrNodeType addObject:node4Type];
                     
                        //第二类二级结点数据内容
                        NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                        NSValue *node4Content=[self setBudgetLevelTwoTypeTwoNodeWithName:node4Name];
                        [self.arrLevelTwoNode addObject:node4Content];
                        break;
                        }
                        
                    case 2:{
                        //第三类二级结点数据类型
                        NSValue *node4Type=[self setBudgetLevelGroupWithType:1 Category:2 Parent:m Index:n Uid:m+n+1];
                        [self.arrNodeType addObject:node4Type];
                        
                        //第三类二级结点数据内容
                        NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                        NSValue *node4Content=[self setBudgetLevelTwoTypeThreeNodeWithName:node4Name];
                        [self.arrLevelTwoNode addObject:node4Content];
                        break;
                    }
                 default:break;
                }
    
            }
          
            
        }
    
    
    
}

//将数据结点类型结构体，转为nsvalue
-(NSValue*)setBudgetLevelGroupWithType:(int)type  Category:(int)category Parent:(int)parent Index:(int)index Uid:(int)uid
{
    BudgetLevelGroup budgetLevelGroup;
    budgetLevelGroup.type=type;
    budgetLevelGroup.category=category;
    budgetLevelGroup.parent=parent;
    budgetLevelGroup.uid=uid;
    budgetLevelGroup.index=index;
    NSValue *budgetType=[NSValue value:&budgetLevelGroup withObjCType:@encode(BudgetLevelGroup)];
    return budgetType;

}

//将一级数据结点数据，转为nsvalue，
-(NSValue*)setBudgetLevelOneNodeWithName:(NSString*)name Budget:(NSString*)budget
{
    BudgetLevelOneNodeGroup budgetLevelOneNodeGroup;
    budgetLevelOneNodeGroup.name=[name UTF8String];
    budgetLevelOneNodeGroup.budget=[budget UTF8String];
    NSValue *budgetNodeInLevelOne=[NSValue value:&budgetLevelOneNodeGroup withObjCType:@encode(BudgetLevelOneNodeGroup)];
    return budgetNodeInLevelOne;
}

//将二级数据结点第一类数据，转为nsvalue，
-(NSValue*)setBudgetLevelTwoTypeOneNodeWithName:(NSString*)name
{
    BudgetLevelTwoTypeOneGroup budgetLevelTwoTypeOneGroup;
    budgetLevelTwoTypeOneGroup.name=[name UTF8String];
    NSValue *budgetNodeInLevelTwoTypeOne=[NSValue value:&budgetLevelTwoTypeOneGroup withObjCType:@encode(BudgetLevelTwoTypeOneGroup)];
    return budgetNodeInLevelTwoTypeOne;
}

//将二级数据结点第二类数据，转为nsvalue，
-(NSValue*)setBudgetLevelTwoTypeTwoNodeWithName:(NSString*)name
{
    BudgetLevelTwoTypeTwoGroup budgetLevelTwoTypeTwoGroup;
    budgetLevelTwoTypeTwoGroup.name=[name UTF8String];
    NSValue *budgetNodeInLevelTwoTypeTwo=[NSValue value:&budgetLevelTwoTypeTwoGroup withObjCType:@encode(BudgetLevelTwoTypeTwoGroup)];
    return budgetNodeInLevelTwoTypeTwo;
}

//将二级数据结点第三类数据，转为nsvalue，
-(NSValue*)setBudgetLevelTwoTypeThreeNodeWithName:(NSString*)name
{
    BudgetLevelTwoTypeThreeGroup budgetLevelTwoTypeThreeGroup;
    budgetLevelTwoTypeThreeGroup.name=[name UTF8String];
    NSValue *budgetNodeInLevelTwoTypeThree=[NSValue value:&budgetLevelTwoTypeThreeGroup withObjCType:@encode(BudgetLevelTwoTypeThreeGroup)];
    return budgetNodeInLevelTwoTypeThree;
}


//获取每个table cell的calayer的数组内容


-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *budgetTblViewIdentifier=@"BudgetSubTblViewIdentifier";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:budgetTblViewIdentifier];
    NSUInteger row=[indexPath row];
    NSNumber *nFlag=[self.arrNodeEditFlag objectAtIndex:row];
    bool flag=[nFlag boolValue];
    
    
    if (cell==nil||flag)
    {
        cell=[[UITableViewCell alloc]
              initWithStyle:UITableViewCellStyleValue2
              reuseIdentifier:budgetTblViewIdentifier];
        [self.arrNodeEditFlag replaceObjectAtIndex:row withObject:[NSNumber numberWithBool:NO]];
        
        
        NSMutableArray *arrCellLayers=[self getCALayersWithRowIndex:row];
        for (UIView *view in arrCellLayers)
        {
            [cell.contentView addSubview:view];
        }

    }
    
    return cell;

}

-(NSMutableArray*)getCALayersWithRowIndex:(NSUInteger)rowIndex
{
    NSMutableArray *arrCALayer=[[NSMutableArray alloc]init];
    NSValue *levelGroup=[self.arrNodeType objectAtIndex:rowIndex];
    BudgetLevelGroup structLevelGroup;
    [levelGroup getValue:&structLevelGroup];
    if (structLevelGroup.type==0)
    {
        arrCALayer=[self getLvOneCALayersWithIndex:structLevelGroup.index];
    }
    else if (structLevelGroup.type==1)
    {
        
        arrCALayer=[self getLvTwoCALayersWithIndex:structLevelGroup.index Category:structLevelGroup.category];
    }
   
    
    return arrCALayer;
}

//返回一级节点calayer数组
-(NSMutableArray*)getLvOneCALayersWithIndex:(NSUInteger)index
{
    
    NSMutableArray *arrLvOneCALayers=[[NSMutableArray alloc]init];
    //名称
    NSValue *content=[self.arrLevelOneNode objectAtIndex:index];
    BudgetLevelOneNodeGroup budgetLevelOneNodeGroup;
    [content getValue:&budgetLevelOneNodeGroup];
    //预算
    const char *cName=budgetLevelOneNodeGroup.name;
    NSString *name=[NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
    
    const char *cBudget=budgetLevelOneNodeGroup.budget;
    NSString *budget=[NSString stringWithCString:cBudget encoding:NSUTF8StringEncoding];
    
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"AppleGothic"];
    [nameLayer setFontSize:15];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.15f,
                                   [UIScreen mainScreen].bounds.size.height*0.04f,
                                   [UIScreen mainScreen].bounds.size.width*0.5f,
                                   [UIScreen mainScreen].bounds.size.height*0.5f)];
    
    [nameLayer setString:name];
    [nameLayer setAlignmentMode:kCAAlignmentLeft];
    [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    [nameLayer setContentsScale:2];
    
    CATextLayer *budgetLayer=[[CATextLayer alloc]init];
    [budgetLayer setFont:@"AppleGothic"];
    [budgetLayer setFontSize:15];
    [budgetLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.6f,
                                     [UIScreen mainScreen].bounds.size.height*0.04f,
                                     [UIScreen mainScreen].bounds.size.width*0.4f,
                                     [UIScreen mainScreen].bounds.size.height*0.5f)];
    NSString *budgetStr=[NSString stringWithFormat:@"%@",budget];
    
    [budgetLayer setString:budgetStr];
    [budgetLayer setAlignmentMode:kCAAlignmentLeft];
    [budgetLayer setForegroundColor:[[UIColor blueColor] CGColor]];
    [budgetLayer setContentsScale:2];
    
    //展开按钮
    UIButton *expandBtn=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.00f,
                                                                   [UIScreen mainScreen].bounds.size.height*0.03f,
                                                                   [UIScreen mainScreen].bounds.size.width*0.12f,
                                                                   [UIScreen mainScreen].bounds.size.height*0.04f)];
    [expandBtn setBackgroundColor:[UIColor colorWithRed:0.0f
                                                  green:0.584f
                                                   blue:0.815f
                                                  alpha:1]];
    
    [expandBtn setTitle:@"+" forState:UIControlStateNormal];
    [expandBtn addTarget:self action:@selector(pressedExpandBtn:) forControlEvents:UIControlEventTouchDown];
    [expandBtn setTag:index];
    
    UIView *view=[[UIView alloc]init];
    [view.layer addSublayer:nameLayer];
    [view.layer addSublayer:budgetLayer];
    
    [arrLvOneCALayers addObject:view];
    [arrLvOneCALayers addObject:expandBtn];
    return arrLvOneCALayers;


    
}

-(void)pressedExpandBtn:(UIButton *)btn
{
    NSUInteger btnIndex=btn.tag;
    if ([[self.arrLevelOneNodeStatus objectAtIndex:btnIndex]intValue]==0)
    {
        NSLog(@"aa");
        [self.arrLevelOneNodeStatus replaceObjectAtIndex:btnIndex withObject:[NSNumber numberWithInt:1]];
        for (NSValue *nodeValue in self.arrNodeType)
        {
            BudgetLevelGroup budgetLevelGroup;
            [nodeValue getValue:&budgetLevelGroup];
            if (budgetLevelGroup.parent==btnIndex)
            {
                [self.arrLevelTwoNodeStatus replaceObjectAtIndex:btnIndex withObject:[NSNumber numberWithInt:1]];
                [self.arrNodeEditFlag replaceObjectAtIndex:budgetLevelGroup.uid withObject:[NSNumber numberWithBool:YES]];
            }
            
        }
    }
    else if ([[self.arrLevelOneNodeStatus objectAtIndex:btnIndex]intValue]==1)
    {
        NSLog(@"bb");
        [self.arrLevelOneNodeStatus replaceObjectAtIndex:btnIndex withObject:[NSNumber numberWithInt:0]];
        for (NSValue *nodeValue in self.arrNodeType)
        {
            BudgetLevelGroup budgetLevelGroup;
            [nodeValue getValue:&budgetLevelGroup];
            if (budgetLevelGroup.parent==btnIndex)
            {
                [self.arrLevelTwoNodeStatus replaceObjectAtIndex:btnIndex withObject:[NSNumber numberWithInt:0]];
                [self.arrNodeEditFlag replaceObjectAtIndex:budgetLevelGroup.uid withObject:[NSNumber numberWithBool:YES]];
            }
            
        }
    }
    
    [self.subBudgetTableView reloadData];
}



-(NSMutableArray*)getLvTwoCALayersWithIndex:(NSUInteger)index Category:(NSUInteger)category
{
     NSMutableArray *arrLvTwoCALayers=[[NSMutableArray alloc]init];
     NSValue *content=[self.arrLevelTwoNode objectAtIndex:index];
    UIView *view=[[UIView alloc]init];
    
    NSNumber *valueStatus=[self.arrLevelTwoNodeStatus objectAtIndex:index];
    NSInteger status=[valueStatus integerValue];
    if (status==0)
    {
        
    switch (category)
    {
        case 0:{BudgetLevelTwoTypeOneGroup budgetLevelTwoTypeOneGroup;
               [content getValue:&budgetLevelTwoTypeOneGroup];
               const char* cName=budgetLevelTwoTypeOneGroup.name;
               NSString *name=[NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            
              CATextLayer *nameLayer=[[CATextLayer alloc]init];
              [nameLayer setFont:@"AppleGothic"];
              [nameLayer setFontSize:15];
              [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.02f,
                                             [UIScreen mainScreen].bounds.size.height*0.04f,
                                             [UIScreen mainScreen].bounds.size.width*0.5f,
                                             [UIScreen mainScreen].bounds.size.height*0.5f)];
            
              [nameLayer setString:name];
              [nameLayer setAlignmentMode:kCAAlignmentLeft];
              [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
              [nameLayer setContentsScale:2];
            
              [view.layer addSublayer:nameLayer];
              [arrLvTwoCALayers addObject:view];
               break;
               }
        case 1:{BudgetLevelTwoTypeTwoGroup budgetLevelTwoTypeTwoGroup;
               [content getValue:&budgetLevelTwoTypeTwoGroup];
               const char* cName=budgetLevelTwoTypeTwoGroup.name;
               NSString *name=[NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            
               CATextLayer *nameLayer=[[CATextLayer alloc]init];
               [nameLayer setFont:@"AppleGothic"];
               [nameLayer setFontSize:15];
               [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.02f,
                                              [UIScreen mainScreen].bounds.size.height*0.04f,
                                              [UIScreen mainScreen].bounds.size.width*0.5f,
                                              [UIScreen mainScreen].bounds.size.height*0.5f)];
            
               [nameLayer setString:name];
               [nameLayer setAlignmentMode:kCAAlignmentLeft];
               [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
               [nameLayer setContentsScale:2];
            
               [view.layer addSublayer:nameLayer];
               [arrLvTwoCALayers addObject:view];
            
               break;
               }
        case 2:{BudgetLevelTwoTypeThreeGroup budgetLevelTwoTypeThreeGroup;
               [content getValue:&budgetLevelTwoTypeThreeGroup];
               const char* cName=budgetLevelTwoTypeThreeGroup.name;
               NSString *name=[NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
            
               CATextLayer *nameLayer=[[CATextLayer alloc]init];
               [nameLayer setFont:@"AppleGothic"];
               [nameLayer setFontSize:15];
               [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.02f,
                                              [UIScreen mainScreen].bounds.size.height*0.04f,
                                              [UIScreen mainScreen].bounds.size.width*0.5f,
                                              [UIScreen mainScreen].bounds.size.height*0.5f)];
            
               [nameLayer setString:name];
               [nameLayer setAlignmentMode:kCAAlignmentLeft];
               [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
               [nameLayer setContentsScale:2];
            
               [view.layer addSublayer:nameLayer];
               [arrLvTwoCALayers addObject:view];
               NSLog(@"c");
               break;
               }
        default:
            break;
    }
    }
    
    return arrLvTwoCALayers;
}







-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrNodeType.count;
}


/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [UIScreen mainScreen].bounds.size.height*0.08f;
}








@end
