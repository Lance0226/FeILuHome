//
//  ViewController.h
//  FeiLu
//
//  Created by lance on 9/1/15.
//  Copyright (c) 2015 lance. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BudgetSubViewController : UIViewController<UITableViewDataSource,UITableViewDataSource>
@property (nonatomic,retain) NSNumber  *xmlIndex;
@property (nonatomic,retain) NSNumber  *xmlSubIndex;

typedef struct
{
    int type;        //0为1级节点，1为2级节点
    int category;    //1级节点均为0，2级节点第一类为0，第二类为1，第三类为2
    int parent;      //父节点序号，从零开始，没有父节点为－1
    int index;
}BudgetLevelGroup;


typedef struct      //1级节点数据结构
{
    const char*  name;
    const char*  budget;
}BudgetLevelOneNodeGroup;



typedef struct    //2级节点第一类数据结构
{
    const char* name;
}BudgetLevelTwoTypeOneGroup;


typedef struct    //2级节点第二类类数据结构
{
    const char* name;
}BudgetLevelTwoTypeTwoGroup;

typedef struct   //2级节点第三类类数据结构
{
    const char* name;
}BudgetLevelTwoTypeThreeGroup;
@end
