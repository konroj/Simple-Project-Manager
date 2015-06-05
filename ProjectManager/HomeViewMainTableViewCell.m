//
//  HomeViewMainTableViewCell.m
//  ProjectManager
//
//  Created by Konrad Roj on 04.06.2015.
//  Copyright (c) 2015 Konrad Roj. All rights reserved.
//

#import "HomeViewMainTableViewCell.h"

@implementation HomeViewMainTableViewCell

- (void)awakeFromNib {
    // Initialization code

}

- (void)layoutSubviews {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)workerAction:(id)sender {
    [self.delegate didTapWorkerButton:self.cellIdentifier];
}

- (IBAction)infoAction:(id)sender {
    [self.delegate didTapInfoButton:self.cellIdentifier];
}

@end
