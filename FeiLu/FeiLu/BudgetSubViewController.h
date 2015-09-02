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

typedef struct{
    int type;        //0为1级节点，1为2级节点
    int index;
    
    
}BudgetTypeList;

@end
