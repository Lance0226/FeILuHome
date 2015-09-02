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
@property (retain,nonatomic) NSMutableArray  *arrNode;            //一级二级分级队列
@property (retain,nonatomic) NSMutableArray  *arrNode1Name; 
@property (retain,nonatomic) NSMutableArray  *arrNode1Budget;


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
    
    self.arrNode=[[NSMutableArray alloc]init];
    self.arrNode1Name=[[NSMutableArray alloc]init];
    self.arrNode1Budget=[[NSMutableArray alloc]init];
    
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
        int i=0;
        for (GDataXMLElement *node3 in arrNode3)
        {
            i++;
            NSString *Node3Name=[[node3 attributeForName:@"name"]stringValue];
            NSString *Node3Budget=[[node3 attributeForName:@"budget"]stringValue];
            
            BudgetTypeList budgetTypeGroup;
            
            
            NSValue *budgetType=[NSValue value:<#(const void *)#> withObjCType:<#(const char *)#>]
            
            [self.arrNode1Name addObject:Node3Name];
            [self.arrNode1Budget addObject:Node3Budget];
          
            
        }
    
    
    
}

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
        
        CALayer *nameLayer=[self getNameLayerWithRowIndex:row];   //预算名称
        [cell.layer addSublayer:nameLayer];
        
        CALayer *totalLayer=[self getTotalLayerWithRowIndex:row];  //预算金额
        [cell.layer addSublayer:totalLayer];

    }
    
    return cell;

}

-(CALayer*)getNameLayerWithRowIndex:(NSUInteger)rowIndex
{
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"AppleGothic"];
    [nameLayer setFontSize:15];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.02f,
                                   [UIScreen mainScreen].bounds.size.height*0.04f,
                                   [UIScreen mainScreen].bounds.size.width*0.5f,
                                   [UIScreen mainScreen].bounds.size.height*0.5f)];
    
    [nameLayer setString:[self.arrNode1Name objectAtIndex:rowIndex]];
    [nameLayer setAlignmentMode:kCAAlignmentLeft];
    [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    [nameLayer setContentsScale:2];
    
    return nameLayer;
    
}

-(CALayer*)getTotalLayerWithRowIndex:(NSUInteger)rowIndex
{
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"AppleGothic"];
    [nameLayer setFontSize:15];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.6f,
                                   [UIScreen mainScreen].bounds.size.height*0.04f,
                                   [UIScreen mainScreen].bounds.size.width*0.4f,
                                   [UIScreen mainScreen].bounds.size.height*0.5f)];
    NSString *budgetStr=[NSString stringWithFormat:@"%@",[self.arrNode1Budget objectAtIndex:rowIndex]];
    
    [nameLayer setString:budgetStr];
    [nameLayer setAlignmentMode:kCAAlignmentLeft];
    [nameLayer setForegroundColor:[[UIColor blueColor] CGColor]];
    [nameLayer setContentsScale:2];
    
    return nameLayer;
    
}




-(NSInteger) tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrNode1Name.count;
}


/*---------------------------------------
 cell高度默认为50
 --------------------------------------- */
-(CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    return [UIScreen mainScreen].bounds.size.height*0.08f;
}








@end
