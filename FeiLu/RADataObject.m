//
//  RADataObject.m
//  RCloudMessage
//
//  Created by 韩渌 on 15/9/7.
//  Copyright (c) 2015年 RongCloud. All rights reserved.
//

#import "RADataObject.h"

@implementation RADataObject


- (id)initWithName:(NSString *)name budget:(NSString*)budget children:(NSMutableArray *)children
{
    self = [super init];
    if (self) {
        self.children = children;
        self.name = name;
        self.budget=budget;
    }
    return self;
}

+ (id)dataObjectWithName:(NSString *)name budget:(NSString*)budget children:(NSMutableArray *)children
{
    return [[self alloc] initWithName:name budget:budget children:children];
}

-(void)addChildrenWithNewObject:(RADataObject*)object
{
    [self.children addObject:object];
}

@end
