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
    return [self.tweetDictionary count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    NSDictionary *status = [self.tweets objectAtIndex:indexPath.row];
    cell.tweetsLabel = [status valueForKey:@"text"];
    cell.nameLabel = [status valueForKey:@"user.screen_name"];
    cell.dateLabel = [status valueForKey:@"created_at"];
   
    return cell;
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
    } errorBlock:^(NSError *error) {
        
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

- (IBAction)searchButton:(id)sender
{
    [self.view endEditing:YES];
    NSString *searchString = self.searchField.text;
    [_twitter getSearchTweetsWithQuery:searchString successBlock:^(NSDictionary *searchMetadata, NSArray *statuses)
    {
        NSLog(@"Tweets for search field are : %@", [searchMetadata description]);
        self.tweetDictionary = searchMetadata;
        self.tweets = statuses;
        NSLog(@"jkdasjkadshjadsw : %@", statuses);
        [self.tableView reloadData];
    }
    errorBlock:^(NSError *error)
     {
         NSLog(@"Oops! : %@", error);
     }];
    [self.tableView reloadData];
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
