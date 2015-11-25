//
//  SourceTypeTableViewController.m
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/22/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "SourceTypeTableViewController.h"
#import "SourceOrTypeCell.h"
#import "IncomeItem.h"
#import "ExpenseItem.h"

@interface SourceTypeTableViewController ()

@end

@implementation SourceTypeTableViewController

//-(instancetype)init {
//    
//    self = [super initWithStyle:UITableViewStylePlain];
//    
//    
//    
//    return self;
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *barTitle;
    
    if(self.isIncome){
        barTitle = @"Income: ";
    }
    else {
        barTitle = @"Expense: ";
    }
    
    self.navigationItem.title = [barTitle stringByAppendingString:self.sourceOrTypeTitle];
    
    [self.navigationController setToolbarHidden:NO];
    
    UINib *nib = [UINib nibWithNibName:@"SourceOrTypeCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated {
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.expensesOrIncomeArray count];
}

- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{

    SourceOrTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SourceOrTypeCell"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    
    if(self.isIncome) {
        IncomeItem *income = self.expensesOrIncomeArray[indexPath.row];
        
        cell.sourceOrTypeLabel.text = [dateFormatter stringFromDate:income.date];
        
        NSString *amountText = @"$ ";
        cell.amountLabel.text = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", income.amount]];
        
        [self setLabelColor:income.amount label:cell.amountLabel];
    }
    else {
        
        ExpenseItem *expense = self.expensesOrIncomeArray[indexPath.row];
        
        cell.sourceOrTypeLabel.text = [dateFormatter stringFromDate:expense.date];
        
        NSString *amountText = @"$ ";
        cell.amountLabel.text = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", expense.amount]];
        
        [self setLabelColor:expense.amount label:cell.amountLabel];
    }
    
    return cell;
}

-(void)setLabelColor:(double)amount label:(UILabel*)label {
    
    if(amount > 0) {
        
        label.textColor = [self darkerColorForColor:[UIColor greenColor]];
    }
    else if(amount < 0) {
        
        label.textColor = [UIColor redColor];
    }
    else {
        label.textColor = [UIColor blackColor];
    }
}

//Took this from online
- (UIColor *)darkerColorForColor:(UIColor *)c
{
    CGFloat r, g, b, a;
    if ([c getRed:&r green:&g blue:&b alpha:&a])
        return [UIColor colorWithRed:MAX(r - 0.5, 0.0)
                               green:MAX(g - 0.5, 0.0)
                                blue:MAX(b - 0.5, 0.0)
                               alpha:a];
    return nil;
}


@end
