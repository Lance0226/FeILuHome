//
//  SecondViewController.m
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "PlanViewController.h"
#import "DetailViewController.h"

@interface PlanViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PlanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initProjectTable];
}



-(void)initProjectTable
{
    self.projectNameList=[[NSArray alloc]initWithObjects:@"方案1",@"方案2",@"方案3",nil];
    self.projectPreviewImage=[[NSArray alloc]initWithObjects:[UIImage imageNamed:@"plan1"],[UIImage imageNamed:@"plan2"],[UIImage imageNamed:@"plan3"],nil];

    
    
    self.projectTableView=[[UITableView alloc]initWithFrame:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/12,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height*9/10) style:UITableViewStylePlain];
    self.projectTableView.delegate=self;
    self.projectTableView.dataSource=self;
    
    [self.view addSubview:self.projectTableView];
    
    
    
    
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
                initWithStyle:UITableViewCellStyleDefault
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
            NSLog(@"%lu",(unsigned long)i);
            DetailViewController *detailVC=[[DetailViewController alloc]init];
            [self.navigationController pushViewController:detailVC animated:YES];
            detailVC.title=@"detail view";
            
            
        }
    }
}
//-------------------------------------------------------------------------------------

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
