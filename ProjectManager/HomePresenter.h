//
//  HomePresenter.h
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePresenter : NSObject

+ (NSArray *)selectAllFromProjectOrderByProjectID;
+ (NSArray *)selectProjectsForUser:(NSString *)name;
+ (BOOL)dropProject:(NSString *)projectName ofUser:(NSString *)userName;

@end
