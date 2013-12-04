//
//  CustomCell.h
//  sampleIOSTwitter
//
//  Created by Apple on 04/12/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *tweetsLabel;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;

@end
