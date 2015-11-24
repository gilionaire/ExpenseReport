//
//  SourceTypeTableViewController.h
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/22/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SourceTypeTableViewController : UITableViewController

//TO-DO add the property for the array of the expenses or sources

@property (nonatomic, copy) NSMutableArray *expensesOrIncomeArray;

@property (nonatomic, copy) NSString* title;

@end
