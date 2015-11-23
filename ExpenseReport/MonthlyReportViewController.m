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
    
    //TO-DO set title from the monthly report object for now created an array
    self.navigationItem.title = self.tempMonths[self.tempMonthNum];
    
    self.expenseType = [NSMutableDictionary new];
    self.incomeSource = [NSMutableDictionary new];
    
    [self.expenseType setObject:@2000.00 forKey:@"Best Buy"];
    [self.incomeSource setObject:@2000.00 forKey:@"Best Buy"];
    
    [self populateDictionaries:self.incomeSource dataArrays:nil];
    [self populateDictionaries:self.expenseType dataArrays:nil];
    
    self.expenseKeys = [self.expenseType allKeys];
    self.incomeKeys = [self.incomeSource allKeys];
    
    UINib *nib = [UINib nibWithNibName:@"SourceOrTypeCell" bundle:nil];
    
    [self.incomeTableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
    [self.expenseTableView registerNib:nib forCellReuseIdentifier:@"SourceOrTypeCell"];
}

-(void)populateDictionaries:(NSMutableDictionary*)dictionaryToPopulate dataArrays:(NSMutableArray*)dataSourceArray {
    
    //replace number 2 with the data source array
    for(int indexOfDataSourceArray = 0; indexOfDataSourceArray < 2; indexOfDataSourceArray++){
        
        //Replace the string with the datasource objects type or source
        if([dictionaryToPopulate objectForKey:@"Best Buy"] && indexOfDataSourceArray==0){
            
            NSNumber *prevAmount = [dictionaryToPopulate objectForKey:@"Best Buy"];
            double amount = [prevAmount doubleValue];
            amount += 500.00;
            prevAmount = [NSNumber numberWithDouble:amount];
            [dictionaryToPopulate setObject:[NSNumber numberWithDouble:amount] forKey:@"Best Buy"];
        }
        else{
            
            //replace string and int with dataSource values
            [dictionaryToPopulate setObject:@2000 forKey:@"UHD"];
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
        
        NSNumber *amount = [self.incomeSource objectForKey:self.incomeKeys[indexPath.row]];
        
        amountText = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", [amount doubleValue]]];
        
        cell.amountLabel.text = amountText;
        
        [self setCellAmountLabelColor:amount cell:cell];
    }
    else {
        
        cell.sourceOrTypeLabel.text = [self.expenseKeys objectAtIndex:indexPath.row];
        
        NSString *amountText = @"$ ";
        
        NSNumber *amount = [self.expenseType objectForKey:self.expenseKeys[indexPath.row]];
        
        amountText = [amountText stringByAppendingString:[NSString stringWithFormat:@"%.02f", [amount doubleValue]]];
        
        cell.amountLabel.text = amountText;
        
        [self setCellAmountLabelColor:amount cell:cell];
    }
    
    return cell;
}

-(void)setCellAmountLabelColor:(NSNumber*)amount cell:(SourceOrTypeCell*)cell {
    
    if([amount doubleValue] > 0) {
        
        cell.amountLabel.textColor = [self darkerColorForColor:[UIColor greenColor]];
    }
    else if([amount doubleValue] < 0) {
        
        cell.amountLabel.textColor = [UIColor redColor];
    }
    else {
        cell.amountLabel.textColor = [UIColor blackColor];
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
