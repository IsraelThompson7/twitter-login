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
#import "ContentViewController.h"
#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define CONSUMER_KEY @"B21B40qN0dLnBwx9aSJKZw"
#define CONSUMER_SECRET @"WaixSLDLZ943kDBOrA6TcDEddwaRXbPVOZ4aARxV4"

@interface TableViewController ()

@property (nonatomic, strong) STTwitterAPI *twitter;
@property (nonatomic) ACAccountStore *accountStore;

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
    
    if(cell == nil)
    {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *status = [self.tweets objectAtIndex:indexPath.row];
    NSString *text = [status valueForKey:@"text"];
    NSString *screenName = [status valueForKeyPath:@"user.screen_name"];
    NSString *dateString = [status valueForKey:@"created_at"];
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"ContentViewController";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    ContentViewController * controller = (ContentViewController *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    controller.tweetString = text;
    controller.name = screenName;
    controller.date = dateString;
    [self presentViewController:controller animated:YES completion:NULL];

}

- (IBAction)searchButton:(id)sender
{
    [self.view endEditing:YES];
    NSString *searchString = self.searchField.text;
    if (![self.searchField.text length])
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Oops!" message:@"Please enter some keywords for searching tweets" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
    else
    {
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
             }
                    errorBlock:^(NSError *error)
             {
                 NSLog(@"-- error %@", error);
             }];
        }
    }
}

- (IBAction)back:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)whatsApp:(id)sender
{
    NSURL *whatsappURL = [NSURL URLWithString:@"whatsapp://send?text=Hello%20World!"];
    if ([[UIApplication sharedApplication] canOpenURL: whatsappURL])
    {
        [[UIApplication sharedApplication] openURL: whatsappURL];
    }
    else
    {
        NSLog(@"Oops! whatsApp not found in the device");
        UIAlertView *error = [[UIAlertView alloc]initWithTitle:@"Information" message:@"WhatsApp not found in your device" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [error show];
    }
}

- (IBAction)test:(id)sender
{
    //  Step 0: Check that the user has local Twitter accounts
    if ([self userHasAccessToTwitter])
    {
        //  Step 1:  Obtain access to the user's Twitter accounts
        ACAccountType *twitterAccountType =
        [self.accountStore accountTypeWithAccountTypeIdentifier:
         ACAccountTypeIdentifierTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted)
             {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/statuses/user_timeline.json"];
                 NSDictionary *params = @{@"screen_name" : @"@dobakurMan",
                                          @"include_rts" : @"0",
                                          @"trim_user" : @"1",
                                          @"count" : @"1"};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:
                  ^(NSData *responseData,
                    NSHTTPURLResponse *urlResponse,
                    NSError *error)
                  {
                      
                      if (responseData)
                      {
                          if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
                          {
                              NSError *jsonError;
                              NSDictionary *timelineData =[NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonError];
                              if (timelineData)
                              {
                                  NSLog(@"Timeline Response: %@\n", timelineData);
                              }
                              else
                              {
                                  // Our JSON deserialization went awry
                                  NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                              }
                          }
                          else
                          {
                              // The server did not respond ... were we rate-limited?
                              NSLog(@"The response status code is %d", urlResponse.statusCode);
                          }
                      }
                  }];
             }
             else
             {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
    NSLog(@"dskfklsdfkd");
}

- (BOOL)userHasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

@end
