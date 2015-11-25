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
#import "ExpensesCollection.h"
#import "IncomeCollection.h"
#import "DetailViewController.h"
#import "TotalBalanceCell.h"

@interface SourceTypeTableViewController ()

@end

@implementation SourceTypeTableViewController

- (instancetype) init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem)];
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    NSMutableArray *tools = [[NSMutableArray alloc]init];
    
    [tools addObject:flexibleSpace];
    [tools addObject:addButton];
    [tools addObject:flexibleSpace];
    
    [self setToolbarItems:tools];
    
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    [self.tableView reloadData];
}


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
    
    UINib *nib = [UINib nibWithNibName:@"TotalYearBalanceCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TotalYearBalanceCell"];
    
    nib = [UINib nibWithNibName:@"SourceOrTypeCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)addNewItem {
    
    DetailViewController *dvc = [[DetailViewController alloc]init];
    
    dvc.isNew = YES;
    dvc.isIncome = self.isIncome;
    dvc.monthReport = self.monthReport;
    
    dvc.sourceOrTypeTile = self.sourceOrTypeTitle;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return [self.expensesOrIncomeArray count]+1;
}

-(double)calculateBalance {
    double balance = 0;
    
    if(self.isIncome) {
        
        for(IncomeItem *income in self.expensesOrIncomeArray) {
            balance += income.amount;
        }
    }
    else {
        for(ExpenseItem *expense in self.expensesOrIncomeArray) {
            balance += expense.amount;
        }
    }
    
    return balance;
}

- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    
    if(indexPath.row == self.expensesOrIncomeArray.count){
        
        TotalBalanceCell *totalCell = [tableView dequeueReusableCellWithIdentifier:@"TotalYearBalanceCell" forIndexPath:indexPath];
        
        double totalBalance = [self calculateBalance];
        
        totalCell.totalBalanceLabel.text =  [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%.02f", totalBalance]];
        
        [self setLabelColor:totalBalance label:totalCell.totalBalanceLabel];
        
        totalCell.totalTextLabel.text = @"Total Amount:";
        
        return  totalCell;
    }

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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
 
    //Do not allow to select the last row which is the balance
    if(indexPath.row == self.expensesOrIncomeArray.count) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    DetailViewController *dvc = [[DetailViewController alloc]init];
    
    dvc.isNew = NO;
    dvc.isIncome = self.isIncome;
    dvc.monthNum = self.monthReport.monthNum;
    dvc.year = self.monthReport.yearNum;
    
    if(self.isIncome) {
        dvc.incomeItem = self.expensesOrIncomeArray[indexPath.row];
    }
    else {
        dvc.expenseItem = self.expensesOrIncomeArray[indexPath.row];
    }
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void) tableView:( UITableView *) tableView
commitEditingStyle:( UITableViewCellEditingStyle) editingStyle
 forRowAtIndexPath:( NSIndexPath *) indexPath
{
    // If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if(self.isIncome){
            
            IncomeItem *income = self.expensesOrIncomeArray[indexPath.row];
            
            [[IncomeCollection sharedCollection]removeIncome:income];
        }
        else {
            ExpenseItem *expense = self.expensesOrIncomeArray[indexPath.row];
            [[ExpensesCollection sharedCollection]removeExpense:expense];
        }
        
        [self.expensesOrIncomeArray removeObjectAtIndex:indexPath.row];
        
        // Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath]
                         withRowAnimation:UITableViewRowAnimationFade];
    }
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
