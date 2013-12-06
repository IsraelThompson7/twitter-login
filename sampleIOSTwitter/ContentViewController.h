//
//  ContentViewController.h
//  sampleIOSTwitter
//
//  Created by Apple on 06/12/13.
//  Copyright (c) 2013 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (strong, nonatomic)NSString *tweetString;
@property (strong, nonatomic)IBOutlet UITextView *tweetsView;
@property (strong, nonatomic)NSString *name;
@property (strong, nonatomic)NSString *date;

- (IBAction)back:(id)sender;

@end
