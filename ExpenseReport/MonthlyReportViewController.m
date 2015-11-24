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
#import "DetailViewController.h"
#import "MonthReportCollection.h"
#import "IncomeItem.h"
#import "ExpenseItem.h"

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
    
    if(!self.monthReport){
        self.monthReport = [[MonthReportCollection sharedCollection]createMonthReport:[NSNumber numberWithInt:self.year] WithMonthNumber:[NSNumber numberWithInt:self.monthNum]];
    }
    
    self.expenseType = [NSMutableDictionary new];
    self.incomeSource = [NSMutableDictionary new];
    
//    NSMutableArray *testingArrayExpense = [[NSMutableArray alloc]init];
//    NSMutableArray *testingArrayIncome = [[NSMutableArray alloc]init];
    
//    self.monthReport.expenses = [[nsse]]
    
//    [testingArrayExpense addObject:@2000];
//    [testingArrayIncome addObject:@2000];
    
//    [self.expenseType setObject:testingArrayExpense forKey:@"Best Buy"];
//    [self.incomeSource setObject:testingArrayIncome forKey:@"Best Buy"];
    
    [self populateDictionaries:self.incomeSource dataSet:self.monthReport.incomes classType:[IncomeItem class]];
    [self populateDictionaries:self.expenseType dataSet:self.monthReport.expenses classType:[ExpenseItem class]];
    
    self.expenseKeys = [self.expenseType allKeys];
    self.incomeKeys = [self.incomeSource allKeys];
    
    UINib *nib = [UINib nibWithNibName:@"SourceOrTypeCell" bundle:nil];
    
    [self.incomeTableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
    [self.expenseTableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
    
    NSNumber *totalAmount = [self calculateTotalMonthlyBalance];
    
    self.totalMonthltyBalanceLabel.text = [@"$ " stringByAppendingString:[NSString stringWithFormat:@"%0.2f",[totalAmount doubleValue]]];
    
    [self setLabelColor:totalAmount label:self.totalMonthltyBalanceLabel];
    
}

//Calculate the total monthly balance
-(NSNumber*)calculateTotalMonthlyBalance {
    
    double totalAmount = 0;
    
    for(NSString* incomeKey in self.incomeSource){
        NSMutableArray *incomes = [self.incomeSource objectForKey:incomeKey];
        totalAmount += [[self totalFromSet:incomes] doubleValue];
    }
    
    for(NSString* expenseKey in self.expenseType){
        NSMutableArray *expenses = [self.expenseType objectForKey:expenseKey];
        totalAmount += [[self totalFromSet:expenses] doubleValue];
    }
    
    return [NSNumber numberWithDouble:totalAmount];
}

-(NSNumber*)totalFromSet:(NSMutableArray*)dataSourceArray {
    double totalAmount = 0;
    
    //For now is NSNumber replace with object
    for(NSNumber *amount in dataSourceArray){
        totalAmount += [amount doubleValue];
    }
    
    return [NSNumber numberWithDouble:totalAmount];
}

-(void)populateDictionaries:(NSMutableDictionary*)dictionaryToPopulate dataSet:(NSSet*)dataSourceSet classType:(id)classType {
    
    //array from data set
    NSArray *data = [dataSourceSet allObjects];
    
    //replace number 2 with the data source array
    for(int dataIndex = 0; dataIndex < data.count; dataIndex++){
        
        NSString *key;
        
        //Is income type
        if([classType isKindOfClass:[IncomeItem class]]) {
         
            IncomeItem *income = data[dataIndex];
            key = income.source;
        }
        else {
            
            ExpenseItem *expense = data[dataIndex];
        
            key = expense.type;
        }
       
        //Replace the string with the datasource objects type or source
        if([dictionaryToPopulate objectForKey:key]){
            
            NSMutableArray *arrayFromDictionary = [dictionaryToPopulate objectForKey:key];
            
            [arrayFromDictionary addObject:data[dataIndex]];
            
            [dictionaryToPopulate setObject:arrayFromDictionary forKey:key];
        }
        else{
            
            //replace string and int with dataSource values
            NSMutableArray *otherOne = [[NSMutableArray alloc]init];
            [otherOne addObject:data[dataIndex]];
            [dictionaryToPopulate setObject:otherOne forKey:key];
        }
    }
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
        return self.incomeSource.count;
    }
    //Expense Table View
    else {
        
        //This should be replace with the expense array
        return self.expenseType.count;
    }
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self.incomeTableView reloadData];
    [self.expenseTableView reloadData];
}


- (UITableViewCell *) tableView:( UITableView *) tableView
          cellForRowAtIndexPath:( NSIndexPath *) indexPath
{
    
    SourceOrTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SourceOrTypeCell"];
    
    if([tableView isEqual:self.incomeTableView]){
        
        cell.sourceOrTypeLabel.text = [self.incomeKeys objectAtIndex:indexPath.row];
                              
        NSString *amountText = @"$ ";
        
        NSMutableArray *incomes = [self.incomeSource objectForKey:self.incomeKeys[indexPath.row]];
        
        NSNumber *amount = [self totalFromSet:incomes];
        
        amountText = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", [amount doubleValue]]];
        
        cell.amountLabel.text = amountText;
        
        [self setLabelColor:amount label:cell.amountLabel];
    }
    else {
        
        cell.sourceOrTypeLabel.text = [self.expenseKeys objectAtIndex:indexPath.row];
        
        NSString *amountText = @"$ ";
        
        NSMutableArray*expenses = [self.expenseType objectForKey:self.expenseKeys[indexPath.row]];
        
        NSNumber *amount = [self totalFromSet:expenses];
        
        amountText = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", [amount doubleValue]]];
        
        cell.amountLabel.text = amountText;
        
        [self setLabelColor:amount label:cell.amountLabel];
    }
    
    return cell;
}

-(void)setLabelColor:(NSNumber*)amount label:(UILabel*)label {
    
    if([amount doubleValue] > 0) {
        
        label.textColor = [self darkerColorForColor:[UIColor greenColor]];
    }
    else if([amount doubleValue] < 0) {
        
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
        
        SourceTypeTableViewController *sttvc = [[SourceTypeTableViewController alloc]init];
        
        //Set the nsMutable array of the sourcetype table view controller to be equal to the incom array
        sttvc.expensesOrIncomeArray = [self.incomeSource objectForKey:self.incomeKeys[indexPath.row]];
        sttvc.title = [@"Income: " stringByAppendingString:self.incomeKeys[indexPath.row]];
        
        [self.navigationController pushViewController:sttvc animated:YES];
        
    }
    //Expense table view selection
    else {
        SourceTypeTableViewController *sttvc = [[SourceTypeTableViewController alloc]init];
        
        //Set the nsMutable array of the sourcetype table view controller to be equal to the incom array
        sttvc.expensesOrIncomeArray = [self.expenseType objectForKey:self.expenseKeys[indexPath.row]];
        sttvc.title = [@"Expense: " stringByAppendingString:self.expenseKeys[indexPath.row]];
        
        [self.navigationController pushViewController:sttvc animated:YES];
    }
}

//Button action to add new incom
- (IBAction)addNewIncome:(id)sender {
    
    DetailViewController *dvc = [[DetailViewController alloc]init];
    
    dvc.isNew = YES;
    dvc.isIncome = YES;
    
    [self.navigationController pushViewController:dvc animated:YES];
    
}

//Button action to add new expense
- (IBAction)addNewExpense:(id)sender {
    
    DetailViewController *dvc = [[DetailViewController alloc]init];
    
    dvc.isNew = YES;
    dvc.isIncome = NO;
    
    [self.navigationController pushViewController:dvc animated:YES];
    
}
@end
