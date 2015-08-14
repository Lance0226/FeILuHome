//
//  SecondViewController.m
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initNavigationBar];
}

-(void)initNavigationBar
{
    self.navBar=[AppDelegate sharedNavigationBar];
    [self.view addSubview:self.navBar];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
