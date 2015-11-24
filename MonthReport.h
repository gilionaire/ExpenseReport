//
//  MonthReport.h
//  ExpenseReport
//
//  Created by Group10 on 11/24/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MonthReport : NSObject

@property (nonatomic, retain) NSMutableDictionary * expenses;
@property (nonatomic, retain) NSMutableDictionary * incomes;
@property (nonatomic) double balance;
@property (nonatomic) int monthNum;
@property (nonatomic) int yearNum;



@end