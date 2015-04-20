//
//  EmailViewController.h
//  MetaMovie
//
//  Created by Swetha Ambati on 4/6/15.
//  Copyright (c) 2015 Swetha Ambati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface EmailViewController : UIViewController <MFMailComposeViewControllerDelegate>

- (IBAction)email:(id)sender;


@end
