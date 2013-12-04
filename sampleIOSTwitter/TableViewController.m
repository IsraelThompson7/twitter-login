//
//  TableViewController.m
//  sampleIOSTwitter
//
//  Created by Apple on 04/12/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import "TableViewController.h"
#import "STTwitter.h"
#import "CustomCell.h"

#define CONSUMER_KEY @"B21B40qN0dLnBwx9aSJKZw"
#define CONSUMER_SECRET @"WaixSLDLZ943kDBOrA6TcDEddwaRXbPVOZ4aARxV4"

@interface TableViewController ()

@property (nonatomic, strong) STTwitterAPI *twitter;

@end

@implementation TableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary *status = [self.tweets objectAtIndex:indexPath.row];
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    
    return cell;
}

- (IBAction)searchButton:(id)sender
{
    [self.view endEditing:YES];
    NSString *searchString = self.searchField.text;
    self.twitter = [STTwitterAPI twitterAPIAppOnlyWithConsumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET];
    {
        [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username)
         {
    [_twitter getSearchTweetsWithQuery:searchString successBlock:^(NSDictionary *searchMetadata, NSArray *statuses)
     {
         NSLog(@"Tweets for search field are : %@", [searchMetadata description]);
         self.tweetDictionary = searchMetadata;
         self.tweets = statuses;
         NSLog(@"tweets status array : %@", statuses);
         [self.tableView reloadData];
     }
    errorBlock:^(NSError *error)
     {
         NSLog(@"Oops! : %@", error);
     }];
         } errorBlock:^(NSError *error) {
             NSLog(@"-- error %@", error);
         }];
    }
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
