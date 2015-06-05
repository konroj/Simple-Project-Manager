//
//  LoginPresenter.m
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "LoginPresenter.h"
#import "DBManager.h"

@implementation LoginPresenter

+ (NSArray *)selectNameAndPasswordFromEmployee {
    NSString *query = [NSString stringWithFormat:@"SELECT name, password FROM employee;"];
    return [[DBManager sharedInstance] executeQuery:query];
}

+ (NSArray *)selectNameAndPasswordFromEmployee:(NSString *)userName andPassword:(NSString *)password {
    NSString *query = [NSString stringWithFormat:@"SELECT name, password FROM employee WHERE name = '%@' AND password = '%@';", userName, password];
    return [[DBManager sharedInstance] executeQuery:query];
}

@end
