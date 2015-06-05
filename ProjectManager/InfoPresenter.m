//
//  InfoPresenter.m
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "InfoPresenter.h"
#import "DBManager.h"

@implementation InfoPresenter

+ (BOOL)updateProjectProgress:(NSString *)progress ofProject:(NSString *)projectName {
    NSLog(@"Update Project called");
    
    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE project SET precentage = %ld WHERE projectname = '%@';", progress.integerValue, projectName];
    if ([[DBManager sharedInstance] executeUpdate:updateQuery]) {
        NSLog(@"Update Success");
        return YES;
    } else {
        NSLog(@"Cannot update %@", projectName);
        return NO;
    }
}

@end
