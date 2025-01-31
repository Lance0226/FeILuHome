//
//  RealTimeLocationStatusView.m
//  LocationSharer
//
//  Created by litao on 15/7/27.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RealTimeLocationStatusView.h"

@interface RealTimeLocationStatusView ()
@property (nonatomic)BOOL isExpended;
@property (nonatomic, strong)UILabel *statusLabel;
@property (nonatomic, strong)UIImageView *locationIcon;
@property (nonatomic, strong)UIImageView *moreIcon;

@property (nonatomic, strong)UILabel *expendLabel;
@property (nonatomic, strong)UIButton *cancelButton;
@property (nonatomic, strong)UIButton *joinButton;
@end

#define RC_REAL_TIME_LOCATION_STATUS_FRAME CGRectMake(0, 62, self.frame.size.width, 38)
#define RC_REAL_TIME_LOCATION_EXPEND_FRAME CGRectMake(0, 62, self.frame.size.width, 85)

@implementation RealTimeLocationStatusView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTaped:)];
    [self addGestureRecognizer:tap];
}

- (void)onTaped:(id)sender {
    if ([self.delegate getStatus] == RC_REAL_TIME_LOCATION_STATUS_INCOMING) {
        self.isExpended = !self.isExpended;
    } else if ([self.delegate getStatus] == RC_REAL_TIME_LOCATION_STATUS_IDLE) {
        self.hidden = YES;
    } else {
        [self.delegate onShowRealTimeLocationView];
    }
    
}

- (void)updateText:(NSString *)statusText {
    self.statusLabel.text = statusText;
}

- (void)updateRealTimeLocationStatus {
    switch ([self.delegate getStatus]) {
        case RC_REAL_TIME_LOCATION_STATUS_IDLE:
            self.isExpended = NO;
            self.hidden = YES;
            break;
        case RC_REAL_TIME_LOCATION_STATUS_INCOMING:
            self.isExpended = NO;
            self.hidden = NO;
            [self setBackgroundColor:[UIColor colorWithRed:((float)0x11)/255 green:((float)0x40)/255 blue:((float)0x60)/255 alpha:0.7]];
            break;
        case RC_REAL_TIME_LOCATION_STATUS_OUTGOING:
        case RC_REAL_TIME_LOCATION_STATUS_CONNECTED:
            self.hidden = NO;
            self.isExpended = NO;
            [self setBackgroundColor:[UIColor colorWithRed:((float)0x69)/255 green:((float)0xb8)/255 blue:((float)0xee)/255 alpha:0.7]];
            break;
        default:
            break;
    }

}

- (void)onCanelPressed:(id)sender {
    self.isExpended = NO;
}

- (void)onJoinPressed:(id)sender {
    self.isExpended = NO;
    [self.delegate onJoin];
}

- (void)setIsExpended:(BOOL)isExpended {
    if (!isExpended) {
        [self showStatus];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1f];
        self.frame = RC_REAL_TIME_LOCATION_STATUS_FRAME;
        [UIView commitAnimations];
    } else {
        [self showExtendedView];
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.1f];
        self.frame = RC_REAL_TIME_LOCATION_EXPEND_FRAME;
        [UIView commitAnimations];
    }
    _isExpended = isExpended;
}

- (void)showStatus {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.statusLabel];
    [self addSubview:self.locationIcon];
    [self addSubview:self.moreIcon];
}

- (void)showExtendedView {
    for (UIView *subView in self.subviews) {
        [subView removeFromSuperview];
    }
    [self addSubview:self.expendLabel];
    [self addSubview:self.cancelButton];
    [self addSubview:self.joinButton];
}

- (UILabel *)statusLabel {
    if (!_statusLabel) {
        _statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 60, 40)];
        _statusLabel.textAlignment = NSTextAlignmentCenter;
        _statusLabel.textColor     = [UIColor whiteColor];
    }
    return _statusLabel;
}
- (UIImageView *)locationIcon {
    if (!_locationIcon) {
        _locationIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 13, 10, 14)];
        [_locationIcon setImage:[UIImage imageNamed:@"white_location_icon"]];
    }
    return _locationIcon;
}
- (UIImageView *)moreIcon {
    if (!_moreIcon) {
        _moreIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, 13, 10, 14)];
        [_moreIcon setImage:[UIImage imageNamed:@"location_arrow"]];
    }
    return _moreIcon;
}
- (UILabel *)expendLabel {
    if (!_expendLabel) {
        _expendLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, self.frame.size.width - 48, 60)];
        _expendLabel.textAlignment = NSTextAlignmentCenter;
        _expendLabel.textColor     = [UIColor whiteColor];
        [_expendLabel setText:@"加入位置共享可能会泄漏您的个人隐私，请确认是否加入？"];
        _expendLabel.numberOfLines = 0;
    }
    return _expendLabel;
}
- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(79, 52, 50, 25)];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"location_share_button"] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"location_share_button_hover"] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(onCanelPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}
- (UIButton *)joinButton {
    if (!_joinButton) {
        _joinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50 - 79, 52, 50, 25)];
        [_joinButton setTitle:@"加入" forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:[UIImage imageNamed:@"location_share_button"] forState:UIControlStateNormal];
        [_joinButton setBackgroundImage:[UIImage imageNamed:@"location_share_button_hover"] forState:UIControlStateHighlighted];
        [_joinButton addTarget:self action:@selector(onJoinPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _joinButton;
}
@end
