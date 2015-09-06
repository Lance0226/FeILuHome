//
//  SecondViewController.m
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "PlanViewController.h"
#import "BudgetViewController.h"
#import "BudgetSubVC.h"


@interface PlanViewController ()

@end

@implementation PlanViewController

- (void)viewDidLoad
{
    //将加载数据，加载ui线程分开
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [super viewDidLoad];
        [self initData];
        [self initPanoURL];
        [self initProjectTable];
    });
    
    
    
    
}

-(void)initData
{
    self.projectNameList=[self GetPlanNameListFromJson];
    self.projectPreviewImage=[self GetPlanPreviewListFromJson];
    

}



-(void)initProjectTable
{
    
    
    self.projectTableView=[[UITableView alloc]init];
    self.projectTableView.frame=CGRectMake(0,
                                           [UIScreen mainScreen].bounds.size.height*0.083f,
                                           [UIScreen mainScreen].bounds.size.width,
                                           [UIScreen mainScreen].bounds.size.height*0.9f);
    self.projectTableView.scrollEnabled=YES;
    self.projectTableView.delegate=self;
    self.projectTableView.dataSource=self;
    
    [self.view addSubview:self.projectTableView];
}

-(void)initPanoURL  //获取全景图url数据，便于后续处理
{
    self.projectPanoURL=[self GetPlanPanoListFromJson];
}

//-------------------------------------------------------------------------------------

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *projectTableIdentifier=@"ProjectTableIdentifier";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:projectTableIdentifier];
    NSUInteger row=[indexPath row];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue2
                reuseIdentifier:projectTableIdentifier];
        
    
        CALayer *previewImageLayer=[self setPreviewImage:row];
        CALayer *nameLayer=[self setProjectName:row];
        UIButton *detailBtn=[self setDetailBtn:row];
        
        [cell.layer addSublayer:previewImageLayer];
        [cell.layer addSublayer:nameLayer];
        [cell.contentView addSubview:detailBtn];
    }
    

    
    return cell;

}

-(CALayer *)setPreviewImage:(NSUInteger)rowIndex
{
    CALayer *previewImageLayer=[CALayer layer];
    [previewImageLayer setFrame:CGRectMake(0,
                                           [UIScreen mainScreen].bounds.size.height*0.033f,
                                           [UIScreen mainScreen].bounds.size.width*0.25f,
                                           [UIScreen mainScreen].bounds.size.height*0.1f)];
    
    UIImage *previewImage=(UIImage *)[self.projectPreviewImage objectAtIndex:rowIndex];
    [previewImageLayer setContents:(id)(previewImage.CGImage)];
    return previewImageLayer;
}

-(CALayer *)setProjectName:(NSUInteger)rowIndex
{
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"HelveticaNeue"];
    [nameLayer setFontSize:15];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.25f,
                                   [UIScreen mainScreen].bounds.size.height*0.067f,
                                   [UIScreen mainScreen].bounds.size.width*0.25f,
                                   [UIScreen mainScreen].bounds.size.height*0.5f)];
    
    [nameLayer setString:[self.projectNameList objectAtIndex:rowIndex]];
    [nameLayer setAlignmentMode:kCAAlignmentCenter];
    [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    return nameLayer;
}

-(UIButton *)setDetailBtn:(NSUInteger)rowInex
{
  
    UIButton *detailBtn=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*0.75f,
                                                                   [UIScreen mainScreen].bounds.size.height*0.067f,
                                                                   [UIScreen mainScreen].bounds.size.width*0.167f,
                                                                   [UIScreen mainScreen].bounds.size.height*0.05f)];
    [detailBtn setBackgroundColor:[UIColor colorWithRed:0.0f
                                                    green:0.584f
                                                    blue:0.815f
                                                    alpha:1]];
    
    [detailBtn setTitle:@"详情" forState:UIControlStateNormal];
    [detailBtn addTarget:self action:@selector(pressedDetailBtn:) forControlEvents:UIControlEventTouchDown];
    [detailBtn setTag:rowInex];
    
    return detailBtn;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.projectNameList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UIScreen mainScreen].bounds.size.height*0.167;
}


//-------------------------------------------------------------------------------------
-(void)pressedDetailBtn:(UIButton *)btn
{
    NSUInteger max_index=self.projectNameList.count;
    for (NSUInteger i=0; i<max_index; i++)
    {
        if (btn.tag==i)
        {
            //NSLog(@"%lu",(unsigned long)i);
            
            BudgetViewController *budgetVC=[[BudgetViewController alloc]init];
            
            budgetVC.title=@"家装项目信息";
            budgetVC.panoURL=[NSURL URLWithString:(NSString*)[self.projectPanoURL objectAtIndex:i]];
            budgetVC.xmlIndex=[[NSNumber alloc]initWithUnsignedLong:i];
            
            [self.navigationController pushViewController:budgetVC animated:YES];
            
           

            
        }
    }
}
//-------------------------------------------------------------------------------------
-(NSMutableArray*)GetPlanNameListFromJson    //从json数据解析
{
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://101.200.196.121:8080/plan_name.json"]];
    NSData *reposne=[NSURLConnection sendSynchronousRequest:requset returningResponse:nil error:nil];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:reposne options:NSJSONReadingMutableLeaves error:nil];

    NSEnumerator *keyEnum=[dict keyEnumerator]; //键值枚举
    
    NSMutableArray    *keyArr=[[NSMutableArray alloc]init]; //键值队列
    NSMutableArray    *nameArr=[[NSMutableArray alloc]init];
    
    
    //NSEnumerator *objEnum=[dict objectEnumerator];
    
    for (NSObject *object in keyEnum)
    {
        [keyArr addObject:object];
    }
    [keyArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {  //升序重排
        return [obj1 integerValue]>[obj2 integerValue];
    }];
    
    for (NSObject *object in keyArr)
    {
        NSObject *name=[dict objectForKey:object];
        [nameArr addObject:name];
    }

    return nameArr;
    
}



-(NSMutableArray*)GetPlanPreviewListFromJson    //从json数据解析预览图
{
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://101.200.196.121:8080/plan_preview_url.json"]];
    NSData *reposne=[NSURLConnection sendSynchronousRequest:requset returningResponse:nil error:nil];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:reposne options:NSJSONReadingMutableLeaves error:nil];
    
    NSEnumerator *keyEnum=[dict keyEnumerator]; //键值枚举
    
    NSMutableArray    *keyArr=[[NSMutableArray alloc]init]; //键值队列
    NSMutableArray    *imageArr=[[NSMutableArray alloc]init];
    
    
    //NSEnumerator *objEnum=[dict objectEnumerator];
    
    for (NSObject *object in keyEnum)
    {
        [keyArr addObject:object];
    }
    
    
    [keyArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {  //升序重排
        return [obj1 integerValue]>[obj2 integerValue];
    }];
    
    for (NSObject *object in keyArr)
    {
        NSObject *url=[dict objectForKey:object];
        
        NSURL *imageURL=[NSURL URLWithString:(NSString *)url];
        NSData *imageData=[NSData dataWithContentsOfURL:imageURL];
        UIImage *image=[UIImage imageWithData:imageData];
        [imageArr addObject:image];
    }
    return imageArr;
    
}

-(NSMutableArray*)GetPlanPanoListFromJson    //从json数据解析全景图
{
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://101.200.196.121:8080/plan_pano_url.json"]];
    NSData *reposne=[NSURLConnection sendSynchronousRequest:requset returningResponse:nil error:nil];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:reposne options:NSJSONReadingMutableLeaves error:nil];
    
    NSEnumerator *keyEnum=[dict keyEnumerator]; //键值枚举
    
    NSMutableArray    *keyArr=[[NSMutableArray alloc]init]; //键值队列
    NSMutableArray    *panoURLArr=[[NSMutableArray alloc]init];
    
    
    //NSEnumerator *objEnum=[dict objectEnumerator];
    
    for (NSObject *object in keyEnum)
    {
        [keyArr addObject:object];
    }
    [keyArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {  //升序重排
        return [obj1 integerValue]>[obj2 integerValue];
    }];
    
    for (NSObject *object in keyArr)
    {
        NSObject *name=[dict objectForKey:object];
        [panoURLArr addObject:name];
    }
    
    return panoURLArr;
    
}

-(UIImage *)createImageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}




//-------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
