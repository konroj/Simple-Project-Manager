//
//  RegisterViewController.m
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "RegisterViewController.h"
#import "DBManager.h"
#import "RegisterPresenter.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UITextField *rankField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *salaryField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"register";
    
    if ([self.nameField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"name" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.emailField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"email" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.salaryField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"salary" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.rankField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"rank" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)registerAction:(id)sender {
    if (![self.nameField.text isEqualToString:@""] && self.passField.text.length > 3) {
        [RegisterPresenter insertEmployee:self.nameField.text rank:self.rankField.text email:self.emailField.text salary:self.salaryField.text.integerValue password:self.passField.text];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([self.nameField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Error"
                                                        message:@"Name cannot be empty."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    } else if (self.passField.text.length <= 3) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Register Error"
                                                        message:@"Password must be at least 4 characters."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

#pragma mark - Other

- (void)keyboardWillShow:(NSNotification *)note {
    [self.view addGestureRecognizer:self.tapRecognizer];
}

- (void)keyboardWillHide:(NSNotification *)note {
    [self.view removeGestureRecognizer:self.tapRecognizer];
}

- (void)didTapAnywhere:(UITapGestureRecognizer*)recognizer {
    [self.nameField resignFirstResponder];
    [self.passField resignFirstResponder];
    [self.emailField resignFirstResponder];
    [self.salaryField resignFirstResponder];
    [self.rankField resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
