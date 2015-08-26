//
//  SecondViewController.m
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "PlanViewController.h"
#import "PanoViewController.h"
#import "DetailViewController.h"

@interface PlanViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initProjectTable];
    [self initPanoURL];
    
}



-(void)initProjectTable
{
    self.projectNameList=[self GetPlanNameListFromJson];
    self.projectPreviewImage=[self GetPlanPreviewListFromJson];
    
    
    self.projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/12,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*9/10)];
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
    [previewImageLayer setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/30,[UIScreen mainScreen].bounds.size.width/4,[UIScreen mainScreen].bounds.size.height/10)];
    UIImage *previewImage=(UIImage *)[self.projectPreviewImage objectAtIndex:rowIndex];
    [previewImageLayer setContents:(id)(previewImage.CGImage)];
    return previewImageLayer;
}

-(CALayer *)setProjectName:(NSUInteger)rowIndex
{
    CATextLayer *nameLayer=[[CATextLayer alloc]init];
    [nameLayer setFont:@"HelveticaNeue"];
    [nameLayer setFontSize:15];
    [nameLayer setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width/4,[UIScreen mainScreen].bounds.size.height/15,[UIScreen mainScreen].bounds.size.width/4,[UIScreen mainScreen].bounds.size.height/20)];
    [nameLayer setString:[self.projectNameList objectAtIndex:rowIndex]];
    [nameLayer setAlignmentMode:kCAAlignmentCenter];
    [nameLayer setForegroundColor:[[UIColor blackColor] CGColor]];
    return nameLayer;
}

-(UIButton *)setDetailBtn:(NSUInteger)rowInex
{
  
    UIButton *detailBtn=[[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width*3/4,[UIScreen mainScreen].bounds.size.height/15,[UIScreen mainScreen].bounds.size.width/6,[UIScreen mainScreen].bounds.size.height/20)];
    [detailBtn setBackgroundColor:[UIColor colorWithRed:0.0f/255.0f green:149.0f/255.0f blue:208.0f/255.0f alpha:1]];
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
    return [UIScreen mainScreen].bounds.size.height/6;
}


//-------------------------------------------------------------------------------------
-(void)pressedDetailBtn:(UIButton *)btn
{
    NSUInteger max_index=self.projectNameList.count;
    for (NSUInteger i=0; i<max_index; i++)
    {
        if (btn.tag==i)
        {
            //DetailViewController *detailVC=[[DetailViewController alloc]init];
            //[self.navigationController pushViewController:detailVC animated:YES];
            PanoViewController *panoVC=[[PanoViewController alloc]init];
            [self.navigationController pushViewController:panoVC animated:YES];
            //detailVC.title=@"家装项目信息";
            
            panoVC.title=@"家装项目信息";
            panoVC.panoURL=[NSURL URLWithString:(NSString*)[self.projectPanoURL objectAtIndex:i]];
            
            
        }
    }
}
//-------------------------------------------------------------------------------------
-(NSMutableArray*)GetPlanNameListFromJson    //从json数据解析
{
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/plan_name.json"]];
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
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/plan_preview_url.json"]];
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
        
        if (image!=nil)
        {
           [imageArr addObject:image];
        }
        else
        {
            [imageArr addObject:[self createImageWithColor:[UIColor whiteColor]]];
        }
    }
    
    
    return imageArr;
    
}

-(NSMutableArray*)GetPlanPanoListFromJson    //从json数据解析全景图
{
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/plan_pano_url.json"]];
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
