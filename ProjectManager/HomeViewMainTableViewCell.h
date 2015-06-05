//
//  HomeViewMainTableViewCell.h
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeViewMainTableViewCellDelegate <NSObject>

- (void)didTapWorkerButton:(NSIndexPath *)cellIdentifier;
- (void)didTapInfoButton:(NSIndexPath *)cellIdentifier;

@end

@interface HomeViewMainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *projectName;
@property (weak, nonatomic) IBOutlet UILabel *precentage;
@property (weak, nonatomic) IBOutlet UIButton *workersButton;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *counter;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;

@property (assign, nonatomic) NSIndexPath *cellIdentifier;
@property (weak, nonatomic) id<HomeViewMainTableViewCellDelegate> delegate;

@end
