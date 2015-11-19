//
//  MonthsViewController.m
//  BudgetHelperApplication
//
//  Created by Ricardo Cantu on 11/19/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MonthsViewController.h"

@interface MonthsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *monthNameLabel;
@property (weak, nonatomic) IBOutlet UIView *latestIncomeView;
@property (weak, nonatomic) IBOutlet UIView *latestExpenseView;
@property (weak, nonatomic) IBOutlet UILabel *balanceForMonthLabel;

@end

@implementation MonthsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setMonthNameLabel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setMonthNameLabel {
    
    switch (self.monthSelected) {
        case 2:
            self.monthNameLabel.text = @"February";
            break;
        case 3:
            self.monthNameLabel.text = @"March";
            break;
        case 4:
            self.monthNameLabel.text = @"April";
            break;
        case 5:
            self.monthNameLabel.text = @"May";
            break;
        case 6:
            self.monthNameLabel.text = @"June";
            break;
        case 7:
            self.monthNameLabel.text = @"July";
            break;
        case 8:
            self.monthNameLabel.text = @"August";
            break;
        case 9:
            self.monthNameLabel.text = @"September";
            break;
        case 10:
            self.monthNameLabel.text = @"October";
            break;
        case 11:
            self.monthNameLabel.text = @"November";
            break;
        case 12:
            self.monthNameLabel.text = @"December";
            break;
        default:
            self.monthNameLabel.text = @"January";
            break;
    }
}


@end
