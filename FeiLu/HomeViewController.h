//
//  UIViewController+HomeViewController.h
//  RCloudMessage
//
//  Created by 韩渌 on 15/9/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController :UIViewController<UIWebViewDelegate>

@property (retain,nonatomic) UIWebView *webView;

@property (retain,nonatomic) UIActivityIndicatorView *indicator;          //指示器

@end
