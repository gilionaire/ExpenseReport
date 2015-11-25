//
//  MonthlyReportViewController.m
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/22/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MonthlyReportViewController.h"
#import "SourceTypeTableViewController.h"
#import "SourceOrTypeCell.h"
#import "TotalBalanceCell.h"
#import "DetailViewController.h"
#import "IncomeItem.h"
#import "ExpenseItem.h"
#import "IncomeCollection.h"
#import "ExpensesCollection.h"

@interface MonthlyReportViewController ()

@property (nonatomic,retain)NSMutableDictionary *expenseType;
@property (nonatomic,retain)NSMutableDictionary *incomeSource;

@property (nonatomic,copy)NSArray *expenseKeys;
@property (nonatomic,copy)NSArray *incomeKeys;

@end

@implementation MonthlyReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = self.monthName;
    
    UINib *nib = [UINib nibWithNibName:@"TotalYearBalanceCell" bundle:nil];
    
    [self.incomeTableView registerNib:nib forCellReuseIdentifier:@"TotalYearBalanceCell"];
    [self.expenseTableView registerNib:nib forCellReuseIdentifier:@"TotalYearBalanceCell"];
    
    nib = [UINib nibWithNibName:@"SourceOrTypeCell" bundle:nil];
    
    [self.incomeTableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
    [self.expenseTableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
}

-(double)totalFromSet:(NSMutableArray*)dataSourceArray classType:(id)classType{
    
    double totalAmount = 0;
    
    if([classType isKindOfClass:[IncomeItem class]]){
        
        for(IncomeItem *income in dataSourceArray){
            totalAmount += income.amount;
        }
    }
    else {
    
        for(ExpenseItem *expense in dataSourceArray) {
            totalAmount += expense.amount;
        }
    }
    
    return totalAmount;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    //Income Table View
    if([tableView isEqual:self.incomeTableView]){
        
        //This should be replace with the income array
        return self.incomeSource.count + 1;
    }
    //Expense Table View
    else {
        
        //This should be replace with the expense array
        return self.expenseType.count + 1;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    
    self.expenseType = self.monthReport.expenses;
    self.incomeSource = self.monthReport.incomes;
    
    self.expenseKeys = [self.expenseType allKeys];
    self.incomeKeys = [self.incomeSource allKeys];
    
    double totalAmount = self.monthReport.monthTotalIncomesAndExpensesBalance;
    
    self.totalMonthltyBalanceLabel.text = [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%0.2f",totalAmount]];
    
    [self setLabelColor:totalAmount label:self.totalMonthltyBalanceLabel];
    
    double currentBalance = [self currentBalance];
    
    self.currentBalanceLabel.text = [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%0.2f",currentBalance]];
    
    [self setLabelColor:currentBalance label:self.currentBalanceLabel];
    
    [self.incomeTableView reloadData];
    [self.expenseTableView reloadData];

}

-(double)currentBalance {
    double balance = 0;
    
    balance += [[IncomeCollection sharedCollection]currentIncomesBalance];
    balance += [[ExpensesCollection sharedCollection]currentExpensesBalance];
    
    return balance;
}

- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    
    SourceOrTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SourceOrTypeCell"];
    
    if([tableView isEqual:self.incomeTableView]){
        
        if(indexPath.row < self.incomeSource.count) {
            
            NSString *incomeKey = [self.incomeKeys objectAtIndex:indexPath.row];
        
            cell.sourceOrTypeLabel.text = incomeKey;
                              
            NSString *amountText = @"$ ";
        
            NSMutableArray *incomes = [self.incomeSource objectForKey:incomeKey];
        
            double amount = [self totalFromSet:incomes classType:[IncomeItem class]];
        
            amountText = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", amount]];
        
            cell.amountLabel.text = amountText;
        
            [self setLabelColor:amount label:cell.amountLabel];
        }
        else {
            TotalBalanceCell *totalCell = [tableView dequeueReusableCellWithIdentifier:@"TotalYearBalanceCell" forIndexPath:indexPath];
            
            totalCell.totalTextLabel.text = @"Total Income:";
            
            double totalIncomeAmount = self.monthReport.monthTotalIncomesBalance;
            
            totalCell.totalBalanceLabel.text = [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%0.02f", totalIncomeAmount]];
            
            [self setLabelColor:totalIncomeAmount label:totalCell.totalBalanceLabel];
            
            return totalCell;
        }
    }
    else {
        
        if(indexPath.row < self.expenseType.count) {
            
            cell.sourceOrTypeLabel.text = [self.expenseKeys objectAtIndex:indexPath.row];
        
            NSString *amountText = @"$ ";
        
            NSMutableArray*expenses = [self.expenseType objectForKey:self.expenseKeys[indexPath.row]];
        
            double amount = [self totalFromSet:expenses classType:[ExpenseItem class]];
        
            amountText = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", amount]];
        
            cell.amountLabel.text = amountText;
        
            [self setLabelColor:amount label:cell.amountLabel];
            
        }
        else {
            TotalBalanceCell *totalCell = [tableView dequeueReusableCellWithIdentifier:@"TotalYearBalanceCell" forIndexPath:indexPath];
            
            totalCell.totalTextLabel.text = @"Total Expense:";
            
            double totalExpenseAmount = self.monthReport.monthTotalExpensesBalance;
            
            totalCell.totalBalanceLabel.text = [NSString stringWithFormat:@"%0.02f", totalExpenseAmount];
            
            [self setLabelColor:totalExpenseAmount label:totalCell.totalBalanceLabel];
            
            return totalCell;
        }
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Income tablte view selection
    if([tableView isEqual:self.incomeTableView]) {
        
        if(indexPath.row >= self.incomeSource.count) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        
        SourceTypeTableViewController *sttvc = [[SourceTypeTableViewController alloc]init];
        
        //Set the nsMutable array of the sourcetype table view controller to be equal to the incom array
        sttvc.expensesOrIncomeArray = [self.incomeSource objectForKey:self.incomeKeys[indexPath.row]];
        sttvc.sourceOrTypeTitle = self.incomeKeys[indexPath.row];
        sttvc.isIncome = YES;
        sttvc.monthReport = self.monthReport;
        
        [self.navigationController pushViewController:sttvc animated:YES];
        
    }
    //Expense table view selection
    else {
        
        if(indexPath.row >= self.expenseType.count) {
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
            return;
        }
        
        SourceTypeTableViewController *sttvc = [[SourceTypeTableViewController alloc]init];
        
        //Set the nsMutable array of the sourcetype table view controller to be equal to the incom array
        sttvc.expensesOrIncomeArray = [self.expenseType objectForKey:self.expenseKeys[indexPath.row]];
        sttvc.sourceOrTypeTitle = self.expenseKeys[indexPath.row];
        sttvc.isIncome = NO;
        sttvc.monthReport = self.monthReport;
        
        [self.navigationController pushViewController:sttvc animated:YES];
    }
}

//Button action to add new incom
- (IBAction)addNewIncome:(id)sender {
    
    DetailViewController *dvc = [[DetailViewController alloc]init];
    
    dvc.isNew = YES;
    dvc.isIncome = YES;
    dvc.monthReport = self.monthReport;
    
    [self.navigationController pushViewController:dvc animated:YES];
    
}

//Button action to add new expense
- (IBAction)addNewExpense:(id)sender {
    
    DetailViewController *dvc = [[DetailViewController alloc]init];
    
    dvc.isNew = YES;
    dvc.isIncome = NO;
    dvc.monthReport = self.monthReport;
    
    [self.navigationController pushViewController:dvc animated:YES];
    
}
@end
