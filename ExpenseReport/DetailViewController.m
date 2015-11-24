//
//  DetailViewController.m
//  ExpenseReport
//
//  Created by Ricardo Cantu on 11/20/15.
//  Copyright © 2015 UHD. All rights reserved.
//

#import "DetailViewController.h"

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
            self.incomeItem = [[IncomeItem alloc]init];
        }
        else {
            self.expenseItem = [[ExpenseItem alloc]init];
        }
    }
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

-(void)viewWillAppear:(BOOL)animated {
    
    //If this is a new the hide the toolbar to diplay the add and cancel buttons
    if(self.isNew) {
        [self.navigationController setToolbarHidden:YES];
    }
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(IBAction)addNewIncomeOrExpense:(id)sender {
    
}

-(IBAction)cancel:(id)sender {
    
}

@end
