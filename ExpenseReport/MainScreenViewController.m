//
//  MainScreenViewController.m
//  BudgetHelperApplication
//
//  Created by Ricardo Cantu on 11/19/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "MainScreenViewController.h"
#import "AppDelegate.h"
#import "TotalBalanceCell.h"
#import "MonthlyReportViewController.h"
#import "IncomeCollection.h"
#import "ExpensesCollection.h"
#import "IncomeItem.h"
#import "ExpenseItem.h"
#import "SourceOrTypeCell.h"

@interface MainScreenViewController ()

@property (nonatomic)NSArray *months;
@property (nonatomic, retain)NSMutableDictionary *yearDictoinary;

@end

@implementation MainScreenViewController

-(instancetype)init {
    
    self = [super initWithStyle:UITableViewStylePlain];
    
    //Check the default year
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *year = [defaults objectForKey:DefaultYearPrefsKey];
    
    self.yearSelected = (int)[year integerValue];

    [self.navigationController setToolbarHidden:NO];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.yearSelected];
    
    UIBarButtonItem *prevYear = [[UIBarButtonItem alloc]initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goToPreviousYear:)];
    UIBarButtonItem *nextYear = [[UIBarButtonItem alloc]initWithTitle:@">" style:UIBarButtonItemStylePlain target:self action:@selector(goToNextYear:)];
    
    self.navigationItem.leftBarButtonItem = prevYear;
    self.navigationItem.rightBarButtonItem = nextYear;
    
    self.months = @[@"January", @"February", @"March", @"April", @"May", @"June", @"July", @"August", @"September", @"October", @"November", @"December"];
    
    return self;
}

-(void)populateYearDicitonary {
    
    self.yearDictoinary = [[NSMutableDictionary alloc]init];
    
    NSDateFormatter *monthFormatter = [[NSDateFormatter alloc]init];
    [monthFormatter setDateFormat:@"MM"];
    
    NSDateFormatter *yearFormatter = [[NSDateFormatter alloc]init];
    [yearFormatter setDateFormat:@"yyyy"];
    
    NSMutableArray *incomes = [[IncomeCollection sharedCollection]allIncomes];
    
    for(int indexIncomes = 0;  indexIncomes < incomes.count; indexIncomes++) {
        
        IncomeItem *income = incomes[indexIncomes];
    
        int monthNum = [[monthFormatter stringFromDate:income.date]intValue];
        int yearNum = [[yearFormatter stringFromDate:income.date]intValue];
        
        MonthReport *monthReport = [[self.yearDictoinary objectForKey:[NSNumber numberWithInt:yearNum]] objectForKey:[NSNumber numberWithInt:monthNum]];
        
        if(!monthReport) {
            monthReport = [[MonthReport alloc]init];
        }
        
        NSMutableDictionary* monthDictionary = [self.yearDictoinary objectForKey:[NSNumber numberWithInt:yearNum]];
        
        if(!monthDictionary) {
            monthDictionary = [[NSMutableDictionary alloc]init];
        }
        
        monthReport.monthNum = monthNum;
        monthReport.yearNum = yearNum;
        
        if(!monthReport.incomes) {
            monthReport.incomes = [[NSMutableDictionary alloc]init];
        }
        
        //Add Income to month report
        NSMutableArray* monthReportIncomes = [monthReport.incomes objectForKey:income.source];
        
        if(!monthReportIncomes) {
            monthReportIncomes = [[NSMutableArray alloc]init];
        }
        
        [monthReportIncomes addObject:income];
        
        [monthReport.incomes setObject:monthReportIncomes forKey:income.source];
        
        //Add month report to monthdictionary
        [monthDictionary setObject:monthReport forKey:[NSNumber numberWithInt:monthNum]];
        
        //Add month dictionary to year dictionary
        [self.yearDictoinary setObject:monthDictionary forKey:[NSNumber numberWithInt:yearNum]];
    }

    NSMutableArray *expenses = [[ExpensesCollection sharedCollection]allExpenses];
    
    for(int indexExpenses = 0;  indexExpenses < expenses.count; indexExpenses++) {
        
        ExpenseItem *expense = expenses[indexExpenses];
        
        int monthNum = [[monthFormatter stringFromDate:expense.date]intValue];
        int yearNum = [[yearFormatter stringFromDate:expense.date]intValue];
        
        MonthReport *monthReport = [[self.yearDictoinary objectForKey:[NSNumber numberWithInt:yearNum]] objectForKey:[NSNumber numberWithInt:monthNum]];
        
        if(!monthReport) {
            
            monthReport = [[MonthReport alloc]init];
            monthReport.expenses = [[NSMutableDictionary alloc]init];
        }
        
        NSMutableDictionary* monthDictionary = [self.yearDictoinary objectForKey:[NSNumber numberWithInt:yearNum]];
        
        if(!monthDictionary) {
            monthDictionary = [[NSMutableDictionary alloc]init];
        }
        
        monthReport.monthNum = monthNum;
        monthReport.yearNum = yearNum;
        
        if(!monthReport.expenses) {
            monthReport.expenses = [[NSMutableDictionary alloc]init];
        }
        
        NSMutableArray *monthReportExpenses = [monthReport.expenses objectForKey:expense.type];
        
        if(!monthReportExpenses) {
            monthReportExpenses = [[NSMutableArray alloc]init];
        }
        
        [monthReportExpenses addObject:expense];
    
        [monthReport.expenses setObject:monthReportExpenses forKey:expense.type];
        
        //Add month report to monthdictionary
        [monthDictionary setObject:monthReport forKey:[NSNumber numberWithInt:monthNum]];
        
        //Add month dictionary to year dictionary
        [self.yearDictoinary setObject:monthDictionary forKey:[NSNumber numberWithInt:yearNum]];
    }
}

-(void)goToPreviousYear: (id)sender {
    self.yearSelected--;
    
    if(self.yearSelected < 1900){
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Really, are you more than 100 years old!" message:@"The least you can go is to 1900" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        self.yearSelected = 1900;
    }
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.yearSelected];
    
    [self.tableView reloadData];
}


- (void)goToNextYear: (id)sender {
    self.yearSelected++;
    self.navigationItem.title = [NSString stringWithFormat:@"%i", self.yearSelected];
    
    [self.tableView reloadData];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
        
//    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    
    UINib *nib = [UINib nibWithNibName:@"TotalYearBalanceCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"TotalYearBalanceCell"];
    
    nib = [UINib nibWithNibName:@"SourceOrTypeCell" bundle:nil];
    
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return 14;
}

- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    
    
    if(indexPath.row < 12) {
        //Get a new or recycled cell
        //This is to reuse the cells for performance
        SourceOrTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SourceOrTypeCell"];
        
        cell.sourceOrTypeLabel.text = self.months[indexPath.row];
        
        double amount = [self calculateMonthBalanceForMonthNum:(int)indexPath.row+1];
        
        cell.amountLabel.text = [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%0.2f", amount]];
        
        [self setLabelColor:amount label:cell.amountLabel];
        
        return cell;
    }
    else if(indexPath.row == 12){
        
        TotalBalanceCell *totalCell = [tableView dequeueReusableCellWithIdentifier:@"TotalYearBalanceCell" forIndexPath:indexPath];
        
        double totalBalance = [self calculateTotalYearBalance];

        totalCell.totalBalanceLabel.text =  [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%.02f", totalBalance]];
        
        [self setLabelColor:totalBalance label:totalCell.totalBalanceLabel];
        
        totalCell.totalTextLabel.text = [[NSString stringWithFormat:@"%i",self.yearSelected] stringByAppendingString:@" Balance:"];
        
        return  totalCell;
    }
    else {
        TotalBalanceCell *totalCell = [tableView dequeueReusableCellWithIdentifier:@"TotalYearBalanceCell" forIndexPath:indexPath];
        
        double totalBalance = [self currentBalance];
        
        totalCell.totalBalanceLabel.text =  [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%.02f", totalBalance]];
        
        [self setLabelColor:totalBalance label:totalCell.totalBalanceLabel];
        
        totalCell.totalTextLabel.text = @"Current Balance:";
        
        return  totalCell;
    }
}

-(double)currentBalance {
    
    double currenBalance = 0;
    
    currenBalance += [[IncomeCollection sharedCollection]currentIncomesBalance];
    currenBalance += [[ExpensesCollection sharedCollection]currentExpensesBalance];
    
    return currenBalance;
}

-(double)calculateMonthBalanceForMonthNum:(int)monthNumber {
    
    double monthTotal = 0;
    
    MonthReport *monthReport = [[self.yearDictoinary objectForKey:[NSNumber numberWithInt:self.yearSelected]]objectForKey:[NSNumber numberWithInt:monthNumber]];
    
    if(monthReport) {
        monthTotal += [monthReport monthTotalIncomesAndExpensesBalance];
    }
    
    return monthTotal;
}

-(double)calculateTotalYearBalance {
    
    double totalBalance = 0;
    
    NSArray* monthReports = [[self.yearDictoinary objectForKey:[NSNumber numberWithInt:self.yearSelected]] allValues];
    
    if(monthReports){
    
        for(MonthReport* monthReport in monthReports) {
            
            totalBalance += [monthReport monthTotalIncomesAndExpensesBalance];
        }
    }
    
    return totalBalance;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
 
    [self.navigationController setToolbarHidden:NO];
    
    [self.tableView reloadData];
    //TO-DO the settings button
    //Do the settings bundle first
    
    [self populateYearDicitonary];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    //Do not allow to select the last row which is the balance
    if(indexPath.row >= 12) {
        [tableView deselectRowAtIndexPath:indexPath animated:NO];
        return;
    }
    
    MonthlyReportViewController *mrvc = [[MonthlyReportViewController alloc]init];
    
    //TO-DO pass the monthly report object
    int monthNum = (int)indexPath.row+1;
    
    mrvc.monthNum = monthNum;
    mrvc.monthName = self.months[monthNum-1];
    mrvc.year = self.yearSelected;
    
    NSMutableDictionary *monthsDictionary = [self.yearDictoinary objectForKey:[NSNumber numberWithInt:self.yearSelected]];
    
    if(!monthsDictionary) {
        monthsDictionary = [[NSMutableDictionary alloc]init];
        NSLog(@"%i",[[NSNumber numberWithInt:self.yearSelected]intValue]);
        [self.yearDictoinary setObject:monthsDictionary forKey:[NSNumber numberWithInt:self.yearSelected]];
    }
    
    MonthReport* monthReport = [monthsDictionary objectForKey:[NSNumber numberWithInt:monthNum]];
    
    if(!monthReport) {
        monthReport = [[MonthReport alloc]init];
        [monthsDictionary setObject:monthReport forKey:[NSNumber numberWithInt:monthNum]];
        monthReport.monthNum = monthNum;
        monthReport.yearNum = self.yearSelected;
    }
    
    mrvc.monthReport = monthReport;
    
    [self.navigationController pushViewController:mrvc animated:YES];
    
}




@end
