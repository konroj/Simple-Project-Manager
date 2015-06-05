//
//  RegisterPresenter.h
//  ProjectManager
//
//  Created by Konrad Roj on 05.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterPresenter : NSObject

+ (BOOL)insertEmployee:(NSString *)name rank:(NSString *)rank email:(NSString *)email salary:(NSInteger)salary password:(NSString *)password;

@end
