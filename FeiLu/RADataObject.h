//
//  RADataObject.h
//  RCloudMessage
//
//  Created by 韩渌 on 15/9/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RADataObject : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *budget;
@property (strong, nonatomic) NSMutableArray *children;

- (id)initWithName:(NSString *)name budget:(NSString*)budget children:(NSMutableArray *)array;

+ (id)dataObjectWithName:(NSString *)name budget:(NSString*)budget children:(NSMutableArray *)children;

-(void)addChildrenWithNewObject:(RADataObject*)object;

@end

