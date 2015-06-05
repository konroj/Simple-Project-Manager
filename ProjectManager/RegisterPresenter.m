//
//  RegisterPresenter.m
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "RegisterPresenter.h"
#import "DBManager.h"

@implementation RegisterPresenter

+ (BOOL)insertEmployee:(NSString *)name rank:(NSString *)rank email:(NSString *)email salary:(NSInteger)salary password:(NSString *)password {
    NSString *maxIdQuery = [NSString stringWithFormat:@"SELECT MAX(employeeid) FROM employee;"];
    
    NSArray *queryRes = [[DBManager sharedInstance] executeQuery:maxIdQuery];
    NSInteger maxId;
    if (queryRes.count) {
        maxId = [queryRes[0][0] integerValue];
    }
    NSString *updateQuery = [NSString stringWithFormat:@"INSERT INTO `employee`(`name`,`rank`,`email`,`salary`,`employeeid`,`password`) VALUES ('%@','%@','%@',%ld,%ld,'%@');", name, rank, email, salary, maxId+1, password];
    
    if ([[DBManager sharedInstance] executeUpdate:updateQuery]) {
        return YES;
    } else {
        return NO;
    }
}

@end
