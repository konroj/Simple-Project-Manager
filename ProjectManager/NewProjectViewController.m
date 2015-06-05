//
//  NewProjectViewController.m
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "NewProjectViewController.h"
#import "NewProjectPresenter.h"

@interface NewProjectViewController ()

@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *typeField;
@end

@implementation NewProjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"new";
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    self.tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    
    if ([self.nameField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        self.nameField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"name" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        self.typeField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"type" attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    }
}

- (IBAction)addAction:(id)sender {
    if (![self.nameField.text isEqualToString:@""] && ([self.typeField.text isEqualToString:@"ios"] || [self.typeField.text isEqualToString:@"html"] || [self.typeField.text isEqualToString:@"cpp"])) {
        
        [NewProjectPresenter insertNewProject:self.nameField.text ofType:self.typeField.text];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } else if ([self.nameField.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add Error"
                                                        message:@"Please use 'ios', 'html' or 'cpp' type."
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
    [self.typeField resignFirstResponder];
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
