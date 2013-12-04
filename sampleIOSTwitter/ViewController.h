//
//  ViewController.h
//  sampleIOSTwitter
//
//  Created by Apple on 04/12/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) NSArray *statuses;

- (IBAction)loginWithiOS:(id)sender;
- (IBAction)getTimeline:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *loginStatus;
@property (strong, nonatomic) IBOutlet UILabel *timeLineStatus;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verfier;

@end