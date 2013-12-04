//
//  ViewController.m
//  sampleIOSTwitter
//
//  Created by Apple on 04/12/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//
#import "ViewController.h"
#import "STTwitter.h"

//warning Replace these demo tokens with yours
#define CONSUMER_KEY @"B21B40qN0dLnBwx9aSJKZw"
#define CONSUMER_SECRET @"WaixSLDLZ943kDBOrA6TcDEddwaRXbPVOZ4aARxV4"

@interface ViewController ()

@property (nonatomic, strong) STTwitterAPI *twitter;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginWithiOS:(id)sender
{
    
    self.twitter = [STTwitterAPI twitterAPIOSWithFirstAccount];
    
    self.loginStatus.text = @"Trying to login with iOS...";
    self.loginStatus.text = @"";
    
    [_twitter verifyCredentialsWithSuccessBlock:^(NSString *username) {
        
        self.loginStatus.text = username;
        
    } errorBlock:^(NSError *error) {
        self.loginStatus.text = [error localizedDescription];
    }];
    
}

- (IBAction)loginInSafari:(id)sender
{
    
    self.twitter = [STTwitterAPI twitterAPIWithOAuthConsumerKey:CONSUMER_KEY consumerSecret:CONSUMER_SECRET];
    
    self.loginStatus.text = @"Trying to login with Safari...";
    self.loginStatus.text = @"";
    
    [_twitter postTokenRequest:^(NSURL *url, NSString *oauthToken) {
        NSLog(@"-- url: %@", url);
        NSLog(@"-- oauthToken: %@", oauthToken);
        
        [[UIApplication sharedApplication] openURL:url];
        
    } oauthCallback:@"iostwitter://twitter_access_tokens/"
                    errorBlock:^(NSError *error) {
                        NSLog(@"-- error: %@", error);
                        self.loginStatus.text = [error localizedDescription];
                    }];
}

- (void)setOAuthToken:(NSString *)token oauthVerifier:(NSString *)verifier {
    
    [_twitter postAccessTokenRequestWithPIN:verifier successBlock:^(NSString *oauthToken, NSString *oauthTokenSecret, NSString *userID, NSString *screenName) {
        NSLog(@"-- screenName: %@", screenName);
        
        self.loginStatus.text = screenName;
        
    } errorBlock:^(NSError *error) {
        
        self.loginStatus.text = [error localizedDescription];
        NSLog(@"-- %@", [error localizedDescription]);
    }];
}

- (IBAction)getTimeline:(id)sender
{
    
    self.timeLineStatus.text = @"";
    
    [_twitter getHomeTimelineSinceID:nil
                               count:20
                        successBlock:^(NSArray *statuses) {
                            
                            NSLog(@"-- statuses: %@", statuses);
                            
                            self.timeLineStatus.text = [NSString stringWithFormat:@"%lu statuses", (unsigned long)[statuses count]];
                            
                            self.statuses = statuses;
                            
                            [self.tableView reloadData];
                            
                        } errorBlock:^(NSError *error) {
                            self.timeLineStatus.text = [error localizedDescription];
                        }];
    [_twitter postStatusUpdate:@"test"
            inReplyToStatusID:nil
                     latitude:nil
                    longitude:nil
                      placeID:nil
           displayCoordinates:nil
                     trimUser:nil
                 successBlock:^(NSDictionary *status) {
                     // ...
                 } errorBlock:^(NSError *error) {
                     // ...
                 }];
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.statuses count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    
    NSDictionary *status = [self.statuses objectAtIndex:indexPath.row];
    
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@ | %@", screenName, dateString];
    
    return cell;
}

@end
