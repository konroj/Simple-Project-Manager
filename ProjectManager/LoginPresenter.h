//
//  LoginPresenter.h
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginPresenter : NSObject

+ (NSArray *)selectNameAndPasswordFromEmployee;
+ (NSArray *)selectNameAndPasswordFromEmployee:(NSString *)userName andPassword:(NSString *)password;

@end
