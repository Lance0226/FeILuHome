//
//  FirstViewController.h
//  FeiLu
//
//  Created by lance on 8/13/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EScrollerView.h"
#import "AppDelegate.h"

@interface HomeViewController : UIViewController<EScrollerViewDelegate>
@property (nonatomic,retain)UINavigationBar *navBar;

@end

