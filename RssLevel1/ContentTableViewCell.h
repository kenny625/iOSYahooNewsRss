//
//  ContentTableViewCell.h
//  RssLevel1
//
//  Created by Kenny Chu on 2015/5/27.
//  Copyright (c) 2015年 Kenny Chu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *thumbImageView;

@end
