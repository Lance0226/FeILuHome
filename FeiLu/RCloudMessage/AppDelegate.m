//
//  AppDelegate.m
//  RongCloud
//
//  Created by Liv on 14/10/31.
//  Copyright (c) 2014年 RongCloud. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"
#import "RCDLoginViewController.h"
#import "RCDRCIMDataSource.h"
#import "RCDLoginInfo.h"
#import <AudioToolbox/AudioToolbox.h>
#import "MobClick.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
#import "UIColor+RCColor.h"
#import "RCWKRequestHandler.h"
#import "RCWKNotifier.h"
#import "RCDCommonDefine.h"
#import "RCDHttpTool.h"
#import "AFHttpTool.h"
#import "RCDataBaseManager.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import <RennSDK/RennSDK.h>

//#define RONGCLOUD_IM_APPKEY @"e0x9wycfx7flq" //offline key
#define RONGCLOUD_IM_APPKEY @"z3v5yqkbv8v30" // online key

#define UMENG_APPKEY @"551ce859fd98c57cdf000678"

#define iPhone6                                                                \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
       ? CGSizeEqualToSize(CGSizeMake(750, 1334),                              \
                           [[UIScreen mainScreen] currentMode].size)           \
       : NO)
#define iPhone6Plus                                                            \
  ([UIScreen instancesRespondToSelector:@selector(currentMode)]                \
       ? CGSizeEqualToSize(CGSizeMake(1242, 2208),                             \
                           [[UIScreen mainScreen] currentMode].size)           \
       : NO)

@interface AppDelegate () <RCWKAppInfoProvider>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {


  //重定向log到本地问题
  //在info.plist中打开Application supports iTunes file sharing
  //    if (![[[UIDevice currentDevice] model] isEqualToString:@"iPhone
  //    Simulator"]) {
  //        [self redirectNSlogToDocumentFolder];
  //    }

  //初始化友盟配置
  [self umengTrack];

    /**
     *  推送说明：
     *  我们在知识库里还有推送调试页面加了很多说明，当遇到推送问题时可以去知识库里搜索还有查看推送测试页面的说明。
     *  首先必须设置deviceToken，可以搜索本文件关键字“推送处理”。模拟器是无法获取devicetoken，也就没有推送功能。
     *  当使用"开发／测试环境"的appkey测试推送时，必须用Development的证书打包，并且在后台上传"开发／测试环境"的推送证书，证书必须是development的。
        当使用"生产／线上环境"的appkey测试推送时，必须用Distribution的证书打包，并且在后台上传"生产／线上环境"的推送证书，证书必须是distribution的。
     */
    
  BOOL debugMode = [[NSUserDefaults standardUserDefaults] boolForKey:@"rongcloud appkey debug"];
  //debugMode是为了切换appkey测试用的，请应用忽略关于debugMode的信息，这里直接调用init。
  if (!debugMode) {

    //初始化融云SDK
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
  }
  
  //设置会话列表头像和会话界面头像

  [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
  if (iPhone6Plus) {
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(56, 56);
  } else {
    NSLog(@"iPhone6 %d", iPhone6);
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(46, 46);
  }

  //设置用户信息源和群组信息源
  [RCIM sharedRCIM].userInfoDataSource = RCDDataSource;
  [RCIM sharedRCIM].groupInfoDataSource = RCDDataSource;
    [RCIM sharedRCIM].receiveMessageDelegate=self;
  //    [RCIM sharedRCIM].globalMessagePortraitSize = CGSizeMake(46, 46);

  //登录
  NSString *token =[[NSUserDefaults standardUserDefaults] objectForKey:@"userToken"];
  NSString *userId=[DEFAULTS objectForKey:@"userId"];
  NSString *userName = [DEFAULTS objectForKey:@"userName"];
  NSString *password = [DEFAULTS objectForKey:@"userPwd"];
  if (token.length && userId.length && password.length && !debugMode) {
    RCUserInfo *_currentUserInfo =
    [[RCUserInfo alloc] initWithUserId:userId
                                    name:userName
                                portrait:nil];
      [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
    [[RCIM sharedRCIM] connectWithToken:token
        success:^(NSString *userId) {
          [AFHttpTool loginWithEmail:userName
                            password:password
                                 env:1
                             success:^(id response) {
                if ([response[@"code"] intValue] == 200) {
                  [RCDHTTPTOOL getUserInfoByUserID:userId
                                        completion:^(RCUserInfo *user) {
                                          [[RCIM sharedRCIM]
                                              refreshUserInfoCache:user
                                                        withUserId:userId];
                                        }];
                    //登陆demoserver成功之后才能调demo 的接口
                    [RCDDataSource syncGroups];
                    [RCDDataSource syncFriendList:^(NSMutableArray * result) {}];
                    
                    [[RCIMClient sharedRCIMClient] getBlacklist:^(NSArray *blockUserIds) {
                        for (NSString *userID in blockUserIds) {
                            
                            // 暂不取用户信息，界面展示的时候在获取
                            RCUserInfo*userInfo = [[RCUserInfo alloc]init];
                            userInfo.userId = userID;
                            userInfo.portraitUri = nil;
                            userInfo.name = nil;
                            [[RCDataBaseManager shareInstance] insertBlackListToDB:userInfo];
                        }

                    } error:^(RCErrorCode status) {
                        NSLog(@"同步黑名单失败，status = %ld",(long)status);
                    }];
                    
                }
              }
              failure:^(NSError *err){
              }];
          //设置当前的用户信息

          //同步群组
          //调用connectWithToken时数据库会同步打开，不用再等到block返回之后再访问数据库，因此不需要这里刷新
          //这里仅保证之前已经成功登陆过，如果第一次登陆必须等block 返回之后才操作数据
//          dispatch_async(dispatch_get_main_queue(), ^{
//            UIStoryboard *storyboard =
//                [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            UINavigationController *rootNavi = [storyboard
//                instantiateViewControllerWithIdentifier:@"rootNavi"];
//            self.window.rootViewController = rootNavi;
//          });
        }
        error:^(RCConnectErrorCode status) {
            RCUserInfo *_currentUserInfo =[[RCUserInfo alloc] initWithUserId:userId
                                                                        name:userName
                                                                    portrait:nil];
            [RCIMClient sharedRCIMClient].currentUserInfo = _currentUserInfo;
            [RCDDataSource syncGroups];
          NSLog(@"connect error %ld", (long)status);
          dispatch_async(dispatch_get_main_queue(), ^{
            UIStoryboard *storyboard =
                [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UINavigationController *rootNavi = [storyboard
                instantiateViewControllerWithIdentifier:@"rootNavi"];
            self.window.rootViewController = rootNavi;
          });
        }
        tokenIncorrect:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                RCDLoginViewController *loginVC =
                [[RCDLoginViewController alloc] init];
                UINavigationController *_navi = [[UINavigationController alloc]
                                                 initWithRootViewController:loginVC];
                self.window.rootViewController = _navi;
                UIAlertView *alertView =
                [[UIAlertView alloc] initWithTitle:nil
                                           message:@"Token已过期，请重新登录"
                                          delegate:nil
                                 cancelButtonTitle:@"确定"
                                 otherButtonTitles:nil, nil];
                ;
                [alertView show];
            });
        }];

  } else {
    RCDLoginViewController *loginVC = [[RCDLoginViewController alloc] init];
    // [loginVC defaultLogin];
    // RCDLoginViewController* loginVC = [storyboard
    // instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *_navi =
        [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = _navi;
  }

  /**
   * 推送处理1
   */
  if ([application
          respondsToSelector:@selector(registerUserNotificationSettings:)]) {
    //注册推送, iOS 8
    UIUserNotificationSettings *settings = [UIUserNotificationSettings
        settingsForTypes:(UIUserNotificationTypeBadge |
                          UIUserNotificationTypeSound |
                          UIUserNotificationTypeAlert)
              categories:nil];
    [application registerUserNotificationSettings:settings];
  } else {
    UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
                                       UIRemoteNotificationTypeAlert |
                                       UIRemoteNotificationTypeSound;
    [application registerForRemoteNotificationTypes:myTypes];
  }

  //统一导航条样式
  UIFont *font = [UIFont systemFontOfSize:19.f];
  NSDictionary *textAttributes = @{
    NSFontAttributeName : font,
    NSForegroundColorAttributeName : [UIColor whiteColor]
  };
  [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
  [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
  [[UINavigationBar appearance]
      setBarTintColor:[UIColor colorWithHexString:@"0195ff" alpha:1.0f]];

  [[NSNotificationCenter defaultCenter]
      addObserver:self
         selector:@selector(didReceiveMessageNotification:)
             name:RCKitDispatchMessageNotification
           object:nil];

  //    NSArray *groups = [self getAllGroupInfo];
  //    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:groups];
  //    NSArray *loadedContents = [NSKeyedUnarchiver
  //                               unarchiveObjectWithData:data];
  //    NSLog(@"loadedContents size is %d", loadedContents.count);
    
    [ShareSDK registerApp:@"api20"];//字符串api20为您的ShareSDK的AppKey
    
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"   //微信APPID
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"  //微信APPSecret
                           wechatCls:[WXApi class]];
    
    //添加新浪微博应用 注册网址 http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:@"568898243"
                               appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                             redirectUri:@"http://www.sharesdk.cn"];
    //当使用新浪微博客户端分享的时候需要按照下面的方法来初始化新浪的平台
    [ShareSDK  connectSinaWeiboWithAppKey:@"568898243"
                                appSecret:@"38a4f8204cc784f81f9f0daaf31e02e3"
                              redirectUri:@"http://www.sharesdk.cn"
                              weiboSDKCls:[WeiboSDK class]];
    
    //添加腾讯微博应用 注册网址 http://dev.t.qq.com
    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:@"100371282"
                           appSecret:@"aed9b0303e3ed1e27bae87c33761161d"
                   qqApiInterfaceCls:[QQApiInterface class]
                     tencentOAuthCls:[TencentOAuth class]];
    
    //添加QQ应用  注册网址   http://mobile.qq.com/api/
    [ShareSDK connectQQWithQZoneAppKey:@"100371282"
                     qqApiInterfaceCls:[QQApiInterface class]
                       tencentOAuthCls:[TencentOAuth class]];
    
    //微信登陆的时候需要初始化
    [ShareSDK connectWeChatWithAppId:@"wx4868b35061f87885"
                           appSecret:@"64020361b8ec4c99936c0e3999a9f249"
                           wechatCls:[WXApi class]];
    
    //添加豆瓣应用  注册网址 http://developers.douban.com
    [ShareSDK connectDoubanWithAppKey:@"07d08fbfc1210e931771af3f43632bb9"
                            appSecret:@"e32896161e72be91"
                          redirectUri:@"http://dev.kumoway.com/braininference/infos.php"];
    
    //添加人人网应用 注册网址  http://dev.renren.com
    [ShareSDK connectRenRenWithAppId:@"226427"
                              appKey:@"fc5b8aed373c4c27a05b712acba0f8c3"
                           appSecret:@"f29df781abdd4f49beca5a2194676ca4"
                   renrenClientClass:[RennClient class]];
    
    //添加开心网应用  注册网址 http://open.kaixin001.com
    [ShareSDK connectKaiXinWithAppKey:@"358443394194887cee81ff5890870c7c"
                            appSecret:@"da32179d859c016169f66d90b6db2a23"
                          redirectUri:@"http://www.sharesdk.cn/"];
    
    //添加Instapaper应用   注册网址  http://www.instapaper.com/main/request_oauth_consumer_token
    [ShareSDK connectInstapaperWithAppKey:@"4rDJORmcOcSAZL1YpqGHRI605xUvrLbOhkJ07yO0wWrYrc61FA"
                                appSecret:@"GNr1GespOQbrm8nvd7rlUsyRQsIo3boIbMguAl9gfpdL0aKZWe"];
    
    //添加有道云笔记应用  注册网址 http://note.youdao.com/open/developguide.html#app
    [ShareSDK connectYouDaoNoteWithConsumerKey:@"dcde25dca105bcc36884ed4534dab940"
                                consumerSecret:@"d98217b4020e7f1874263795f44838fe"
                                   redirectUri:@"http://www.sharesdk.cn/"];
    
    //添加Facebook应用  注册网址 https://developers.facebook.com
    [ShareSDK connectFacebookWithAppKey:@"107704292745179"
                              appSecret:@"38053202e1a5fe26c80c753071f0b573"];
    
    //添加Twitter应用  注册网址  https://dev.twitter.com
    [ShareSDK connectTwitterWithConsumerKey:@"mnTGqtXk0TYMXYTN7qUxg"
                             consumerSecret:@"ROkFqr8c3m1HXqS3rm3TJ0WkAJuwBOSaWhPbZ9Ojuc"
                                redirectUri:@"http://www.sharesdk.cn"];
    
    
  return YES;
}


/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings {
  // register to receive notifications
  [application registerForRemoteNotifications];
}

/**
 * 推送处理3
 */
- (void)application:(UIApplication *)application
    didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
  NSString *token =
      [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                             withString:@""]
          stringByReplacingOccurrencesOfString:@">"
                                    withString:@""]
          stringByReplacingOccurrencesOfString:@" "
                                    withString:@""];

  [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

- (void)umengTrack {

  //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
  [MobClick setLogEnabled:YES];

  //参数为NSString *
  //类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
  [MobClick setAppVersion:XcodeAppVersion];

  //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
  //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App
  //   Store"渠道
  [MobClick startWithAppkey:UMENG_APPKEY
               reportPolicy:(ReportPolicy)REALTIME
                  channelId:nil];

  //      [MobClick checkUpdate];   //自动更新检查,
  //      如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary
  //      *)appInfo的参数
  //    [MobClick checkUpdateWithDelegate:self
  //    selector:@selector(updateMethod:)];

  //在线参数配置
  [MobClick updateOnlineConfig];
}

- (void)onlineConfigCallBack:(NSNotification *)note {

  NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)application:(UIApplication *)application
    didReceiveLocalNotification:(UILocalNotification *)notification {
  //震动
  AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
  AudioServicesPlaySystemSound(1007);
}

/**
 * 推送处理4
 * userInfo内容请参考官网文档
 */
- (void)application:(UIApplication *)application
    didReceiveRemoteNotification:(NSDictionary *)userInfo {
}

- (void)applicationWillResignActive:(UIApplication *)application {
  // Sent when the application is about to move from active to inactive state.
  // This can occur for certain types of temporary interruptions (such as an
  // incoming phone call or SMS message) or when the user quits the application
  // and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down
  // OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
  // Use this method to release shared resources, save user data, invalidate
  // timers, and store enough application state information to restore your
  // application to its current state in case it is terminated later.
  // If your application supports background execution, this method is called
  // instead of applicationWillTerminate: when the user quits.
  int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    @(ConversationType_PRIVATE),
    @(ConversationType_DISCUSSION),
    @(ConversationType_APPSERVICE),
    @(ConversationType_PUBLICSERVICE),
    @(ConversationType_GROUP)
  ]];
  application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
  // Called as part of the transition from the background to the inactive state;
  // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
  // Restart any tasks that were paused (or not yet started) while the
  // application was inactive. If the application was previously in the
  // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
  // Called when the application is about to terminate. Save data if
  // appropriate. See also applicationDidEnterBackground:.
}

- (void)redirectNSlogToDocumentFolder {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                       NSUserDomainMask, YES);
  NSString *documentDirectory = [paths objectAtIndex:0];

  NSDate *currentDate = [NSDate date];
  NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
  [dateformatter setDateFormat:@"MMddHHmmss"];
  NSString *formattedDate = [dateformatter stringFromDate:currentDate];

  NSString *fileName = [NSString stringWithFormat:@"rc%@.log", formattedDate];
  NSString *logFilePath =
      [documentDirectory stringByAppendingPathComponent:fileName];

  freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
          stdout);
  freopen([logFilePath cStringUsingEncoding:NSASCIIStringEncoding], "a+",
          stderr);
}

- (void)didReceiveMessageNotification:(NSNotification *)notification {
  [UIApplication sharedApplication].applicationIconBadgeNumber =
      [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
}

- (void)application:(UIApplication *)application
    handleWatchKitExtensionRequest:(NSDictionary *)userInfo
                             reply:(void (^)(NSDictionary *))reply {
  RCWKRequestHandler *handler =
      [[RCWKRequestHandler alloc] initHelperWithUserInfo:userInfo
                                                provider:self
                                                   reply:reply];
  if (![handler handleWatchKitRequest]) {
    // can not handled!
    // app should handle it here
    NSLog(@"not handled the request: %@", userInfo);
  }
}
#pragma mark - RCWKAppInfoProvider
- (NSString *)getAppName {
  return @"融云";
}

- (NSString *)getAppGroups {
  return @"group.com.RCloud.UIComponent.WKShare";
}

- (NSArray *)getAllUserInfo {
  return [RCDDataSource getAllUserInfo:^ {
    [[RCWKNotifier sharedWKNotifier] notifyWatchKitUserInfoChanged];
  }];
}
- (NSArray *)getAllGroupInfo {
  return [RCDDataSource getAllGroupInfo:^{
    [[RCWKNotifier sharedWKNotifier] notifyWatchKitGroupChanged];
  }];
}
- (NSArray *)getAllFriends {
  return [RCDDataSource getAllFriends:^ {
    [[RCWKNotifier sharedWKNotifier] notifyWatchKitFriendChanged];
  }];
}
- (void)openParentApp {
  [[UIApplication sharedApplication]
      openURL:[NSURL URLWithString:@"rongcloud://connect"]];
}
- (BOOL)getNewMessageNotificationSound {
  return ![RCIM sharedRCIM].disableMessageAlertSound;
}
- (void)setNewMessageNotificationSound:(BOOL)on {
  [RCIM sharedRCIM].disableMessageAlertSound = !on;
}
- (void)logout {
  [DEFAULTS removeObjectForKey:@"userName"];
  [DEFAULTS removeObjectForKey:@"userPwd"];
  [DEFAULTS removeObjectForKey:@"userToken"];
  [DEFAULTS removeObjectForKey:@"userCookie"];
    
  if (self.window.rootViewController != nil) {
    UIStoryboard *storyboard =
        [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    RCDLoginViewController *loginVC =
        [storyboard instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *navi =
        [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = navi;
      
      //UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:
                                                    //[storyboard instantiateInitialViewController]];
      //self.window.rootViewController=nil;
      //self.window.rootViewController=navigationController;
  }
  [[RCIMClient sharedRCIMClient] disconnect:NO];
}
- (BOOL)getLoginStatus {
  NSString *token = [DEFAULTS stringForKey:@"userToken"];
  if (token.length) {
    return YES;
  } else {
    return NO;
  }
}

#pragma mark - RCIMConnectionStatusDelegate

/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
  if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
    UIAlertView *alert = [[UIAlertView alloc]
            initWithTitle:@"提示"
                  message:@"您"
                          @"的帐号在别的设备上登录，您被迫下线！"
                 delegate:nil
        cancelButtonTitle:@"知道了"
        otherButtonTitles:nil, nil];
    [alert show];
    RCDLoginViewController *loginVC = [[RCDLoginViewController alloc] init];
    // [loginVC defaultLogin];
    // RCDLoginViewController* loginVC = [storyboard
    // instantiateViewControllerWithIdentifier:@"loginVC"];
    UINavigationController *_navi =
        [[UINavigationController alloc] initWithRootViewController:loginVC];
    self.window.rootViewController = _navi;
  } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
      dispatch_async(dispatch_get_main_queue(), ^{
          RCDLoginViewController *loginVC =
          [[RCDLoginViewController alloc] init];
          UINavigationController *_navi = [[UINavigationController alloc]
                                           initWithRootViewController:loginVC];
          self.window.rootViewController = _navi;
          UIAlertView *alertView =
          [[UIAlertView alloc] initWithTitle:nil
                                     message:@"Token已过期，请重新登录"
                                    delegate:nil
                           cancelButtonTitle:@"确定"
                           otherButtonTitles:nil, nil];
          ;
          [alertView show];
      });
  }
}

-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    if ([message.content isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *msg=(RCInformationNotificationMessage *)message.content;
        //NSString *str = [NSString stringWithFormat:@"%@",msg.message];
        if ([msg.message rangeOfString:@"你已添加了"].location!=NSNotFound) {
            [RCDDataSource syncFriendList:^(NSMutableArray *friends) {
            }];
        }
    }
}

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url
                        wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url
                 sourceApplication:sourceApplication
                        annotation:annotation
                        wxDelegate:self];
}

- (void)dealloc {
  [[NSNotificationCenter defaultCenter]
      removeObserver:self
                name:RCKitDispatchMessageNotification
              object:nil];
}
@end
