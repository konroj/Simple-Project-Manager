//
//  LoginViewController.m
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "LoginViewController.h"
#import "DBManager.h"
#import "HomeViewController.h"
#import "LoginPresenter.h"

static NSString * const toHomeSegue = @"toHomeSegue";

@interface LoginViewController () <UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;

@property (strong, nonatomic) NSArray *employeesLogin;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupLayout];
}

- (void)setupLayout {
    self.title = @"login";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    if ([self.nameField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"name" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.passField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"password" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont fontWithName:@"Avenir Next" size:18]}];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIFont fontWithName:@"Avenir Next" size:14.0f],NSFontAttributeName,
                                                          nil] forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self queryEmployees];
}

- (void)queryEmployees {
    self.employeesLogin = [LoginPresenter selectNameAndPasswordFromEmployee:self.nameField.text andPassword:self.passField.text];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginAction:(id)sender {
    BOOL logged = NO;
    [self queryEmployees];
    
    for (NSArray *login in self.employeesLogin) {
        if ([login[0] isEqualToString:self.nameField.text] && [login[1] isEqualToString:self.passField.text]) {
            logged = YES;
            [self performSegueWithIdentifier:toHomeSegue sender:login];
        }
    }
    
    if (!logged) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Error"
                                                        message:@"Name or/and password is not correct."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        self.nameField.text = @"";
        self.passField.text = @"";
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
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:toHomeSegue]) {
        // Get reference to the destination view controller
        HomeViewController *vc = [segue destinationViewController];
        NSArray *array = sender;
        vc.name = array[0];
        vc.password = array[1];
    }
}

@end
