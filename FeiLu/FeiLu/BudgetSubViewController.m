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
            //一级结点数据类型部分
            NSValue *node3Type=[self setBudgetLevelGroupWithType:0 Category:0 Parent:-1 Index:m];
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
                //根据传入xml参数序号的不同，选择不同的结构体封装
                switch ([self.xmlSubIndex integerValue])
                {
                 case 0:{
                         //第一类二级结点数据类型
                         NSValue *node4Type=[self setBudgetLevelGroupWithType:1 Category:0 Parent:m Index:n];
                         [self.arrNodeType addObject:node4Type];
                     
                         //第一类二级结点数据内容
                         NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                         NSValue *node4Content=[self setBudgetLevelTwoTypeOneNodeWithName:node4Name];
                         [self.arrLevelTwoNode addObject:node4Content];
                         break;
                        }
                 
                    case 1:{
                        //第二类二级结点数据类型
                        NSValue *node4Type=[self setBudgetLevelGroupWithType:1 Category:1 Parent:m Index:n];
                        [self.arrNodeType addObject:node4Type];
                     
                        //第二类二级结点数据内容
                        NSString *node4Name=[[node4 attributeForName:@"item_name"]stringValue];
                        NSValue *node4Content=[self setBudgetLevelTwoTypeTwoNodeWithName:node4Name];
                        [self.arrLevelTwoNode addObject:node4Content];
                        break;
                        }
                        
                    case 2:{
                        //第三类二级结点数据类型
                        NSValue *node4Type=[self setBudgetLevelGroupWithType:1 Category:2 Parent:m Index:n];
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
-(NSValue*)setBudgetLevelGroupWithType:(int)type  Category:(int)category Parent:(int)parent Index:(int)index
{
    BudgetLevelGroup budgetLevelGroup;
    budgetLevelGroup.type=type;
    budgetLevelGroup.category=category;
    budgetLevelGroup.parent=parent;
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
    
    if (cell==nil)
    {
        cell=[[UITableViewCell alloc]
              initWithStyle:UITableViewCellStyleValue2
              reuseIdentifier:budgetTblViewIdentifier];
        
        NSMutableArray *arrCellLayers=[self getCALayersWithRowIndex:row];
        for (CALayer *layer in arrCellLayers)
        {
            [cell.layer addSublayer:layer];
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
    
    NSValue *content=[self.arrLevelOneNode objectAtIndex:index];
    BudgetLevelOneNodeGroup budgetLevelOneNodeGroup;
    [content getValue:&budgetLevelOneNodeGroup];
    
    const char *cName=budgetLevelOneNodeGroup.name;
    NSString *name=[NSString stringWithCString:cName encoding:NSUTF8StringEncoding];
    
    const char *cBudget=budgetLevelOneNodeGroup.budget;
    NSString *budget=[NSString stringWithCString:cBudget encoding:NSUTF8StringEncoding];
    
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
    
    [arrLvOneCALayers addObject:nameLayer];
    [arrLvOneCALayers addObject:budgetLayer];
    return arrLvOneCALayers;


    
}



-(NSMutableArray*)getLvTwoCALayersWithIndex:(NSUInteger)index Category:(NSUInteger)category
{
     NSMutableArray *arrLvTwoCALayers=[[NSMutableArray alloc]init];
     NSValue *content=[self.arrLevelTwoNode objectAtIndex:index];
    
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

              [arrLvTwoCALayers addObject:nameLayer];
               NSLog(@"a");
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
            
               [arrLvTwoCALayers addObject:nameLayer];
               NSLog(@"b");
            
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
            
               [arrLvTwoCALayers addObject:nameLayer];
               NSLog(@"c");
               break;
               }
        default:
            break;
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
