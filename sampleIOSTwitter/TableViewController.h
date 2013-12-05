//
//  TableViewController.h
//  sampleIOSTwitter
//
//  Created by Apple on 04/12/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableViewController  : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) NSArray *tweets;
@property (nonatomic, strong) NSDictionary *tweetDictionary;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITextField *searchField;

- (IBAction)searchButton:(id)sender;
- (IBAction)back:(id)sender;
- (IBAction)whatsApp:(id)sender;

@end
