//
//  FirstViewController.m
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initAdvertiseBar];
    [self initJsonParser];
    
   }


//加入广告栏
-(void)initAdvertiseBar
{
    
    EScrollerView *scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0,[UIScreen mainScreen].bounds.size.height/11,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height/5)
                                                          ImageArray:[NSArray arrayWithObjects:@"home_page1.png",@"home_page2.png",@"home_page3.png",@"home_page4", nil]
                                                          TitleArray:[NSArray arrayWithObjects:@"11",@"22",@"33",@"44", nil]];
    scroller.delegate=self;
    [self.view addSubview:scroller];
    
}

-(void)initJsonParser
{
    NSURLRequest *requset=[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/demo.json"]];
    NSData *reposne=[NSURLConnection sendSynchronousRequest:requset returningResponse:nil error:nil];
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:reposne options:NSJSONReadingMutableLeaves error:nil];
    
    NSEnumerator *keyEnum=[dict keyEnumerator];
    NSEnumerator *objEnum=[dict objectEnumerator];
    
    for (NSObject *object in keyEnum)
    {
        NSLog(@"%@",object);
    }
    
    for (NSObject *object in objEnum)
    {
        NSLog(@"%@",object);
        
    }
}


-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%lu",(unsigned long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
