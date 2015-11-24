//
//  DetailViewController.h
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/20/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UINavigationControllerDelegate>

//Add property for expense and income
@property (nonatomic)BOOL isNew;
@property (nonatomic)BOOL isIncome;

@end
