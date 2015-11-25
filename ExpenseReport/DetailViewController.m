//
//  DetailViewController.m
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/20/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "DetailViewController.h"
#import "IncomeCollection.h"
#import "ExpensesCollection.h"

@interface DetailViewController ()

@property (weak, nonatomic) IBOutlet UITextField *sourceOrTypeTextField;
@property (weak, nonatomic) IBOutlet UILabel *sourceOrTypeLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;
@property (weak, nonatomic) IBOutlet UITextView *commentsTextBox;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    if(self.isIncome) {
        self.sourceOrTypeLabel.text = @"Source:";
    }
    else {
        self.sourceOrTypeLabel.text = @"Type:";
    }
    
    if(self.isNew) {
        
        if(self.isIncome) {
            self.incomeItem = [[IncomeCollection sharedCollection]createIncome];
            
            self.sourceOrTypeTextField.text = self.incomeItem.source;
            self.amountTextField.text = [NSString stringWithFormat:@"%0.2f", self.incomeItem.amount];
        }
        else {
            self.expenseItem = [[ExpensesCollection sharedCollection]createExpense];
            
            self.sourceOrTypeTextField.text = self.expenseItem.type;
            double amount = self.expenseItem.amount;
            
            if(amount < 0){
                amount *= -1;
            }
            
            self.amountTextField.text = [NSString stringWithFormat:@"%0.2f", amount];
        }
        
        if(self.sourceOrTypeTile) {
            self.sourceOrTypeTextField.text = self.sourceOrTypeTile;
        }
    }
    else {
        if(self.isIncome) {
            self.sourceOrTypeTextField.text = self.incomeItem.source;
            self.datePicker.date = self.incomeItem.date;
            self.amountTextField.text = [NSString stringWithFormat:@"%0.2f", self.incomeItem.amount];
            self.commentsTextBox.text = self.incomeItem.comments;
        }
        else {
            self.sourceOrTypeTextField.text = self.expenseItem.type;
            self.datePicker.date = self.expenseItem.date;
            self.amountTextField.text = [NSString stringWithFormat:@"%0.2f", self.expenseItem.amount];
            self.commentsTextBox.text = self.expenseItem.comments;
        }
    }
    
    [self setMaxAndMinimumDate];
}

-(void)setMaxAndMinimumDate {
    
    //Set the constrains for the datepicker to stay in bounds of the month and year
    NSDate *minDate;
    NSDate *maxDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM/yyyy"];
    
    NSString *minDateStr;
    NSString *maxDateStr;
    
    if(self.monthReport){
        minDateStr = [NSString stringWithFormat:@"%i/%i",
                      self.monthReport.monthNum,
                      self.monthReport.yearNum];
        
    }
    else {
        minDateStr = [NSString stringWithFormat:@"%i/%i",
                      self.monthNum,
                      self.year];
    }
    
    minDate = [dateFormatter dateFromString:minDateStr];
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:minDate];
    
    // set last of month
    [comps setMonth:[comps month]+1];
    [comps setDay:0];
    maxDate = [calendar dateFromComponents:comps];
    
    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
    maxDateStr = [dateFormatter stringFromDate:maxDate];
    //NSLog(maxDateStr);
    [dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm a"];
    maxDateStr = [maxDateStr stringByAppendingString:@" 11:59 PM"];
    maxDate = [dateFormatter dateFromString:maxDateStr];
    
    self.datePicker.minimumDate = minDate;
    NSLog(@"Minimum Date: %@", minDate);
    self.datePicker.maximumDate = maxDate;
    NSLog(@"Maximum Date: %@", maxDate);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//Dismissing keyboard when done or tap outside
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.sourceOrTypeTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    [self.commentsTextBox resignFirstResponder];
}

//Dismiss when tap return
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)viewWillAppear:(BOOL)animated {
    
    //If this is a new the hide the toolbar to diplay the add and cancel buttons
    if(self.isNew) {
        [self.navigationController setToolbarHidden:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    
    //if is a new item
    if(self.isNew) {
        
        if(self.isIncome) {
            [[IncomeCollection sharedCollection]removeIncome:self.incomeItem];
        }
        else {
            [[ExpensesCollection sharedCollection]removeExpense:self.expenseItem];
        }
    }
    else {

        if(self.isIncome) {
            
            IncomeItem *item = self.incomeItem;
            item.source = self.sourceOrTypeTextField.text;
            item.date = self.datePicker.date;
            item.amount = [self.amountTextField.text doubleValue];
            item.comments = self.commentsTextBox.text;
            
            if(self.monthReport) {
                
                if(!self.monthReport.incomes){
                    self.monthReport.incomes = [[NSMutableDictionary alloc]init];
                }
            
                NSMutableArray* incomes = [self.monthReport.incomes objectForKey:item.source];
            
                if(!incomes) {
                    incomes = [[NSMutableArray alloc]init];
                    [self.monthReport.incomes setObject:incomes forKey:item.source];
                }
            
                [incomes addObject:item];
            }
        }
        else {
            
            ExpenseItem *item = self.expenseItem;
            
            item.type = self.sourceOrTypeTextField.text;
            item.date = self.datePicker.date;
            item.comments = self.commentsTextBox.text;
            
            double amount = [self.amountTextField.text doubleValue];
            
            if(amount > 0) {
                amount *= -1;
            }
            
            item.amount = amount;
            
            if(self.monthReport) {
                if(!self.monthReport.expenses){
                    self.monthReport.expenses = [[NSMutableDictionary alloc]init];
                }
            
                NSMutableArray* expenses = [self.monthReport.expenses objectForKey:item.type];
            
                if(!expenses) {
                    expenses = [[NSMutableArray alloc]init];
                    [self.monthReport.expenses setObject:expenses forKey:item.type];
                }
            
                [expenses addObject:item];
            }
        }
    }
    
    [super viewWillDisappear:YES];
    
    [self.navigationController setToolbarHidden:NO animated:YES];    
}

-(IBAction)addNewIncomeOrExpense:(id)sender {
 
    if(![self.sourceOrTypeTextField.text isEqualToString:@""] && ![self.amountTextField.text isEqualToString:@""]) {
        
        self.isNew = false;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle: @"Missing Information" message:@"Enter complete information" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
            [alert dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [alert addAction:ok];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

-(IBAction)cancel:(id)sender {
    
    if(self.isIncome) {
        [[IncomeCollection sharedCollection]removeIncome:self.incomeItem];
    }
    else {
        [[ExpensesCollection sharedCollection]removeExpense:self.expenseItem];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
