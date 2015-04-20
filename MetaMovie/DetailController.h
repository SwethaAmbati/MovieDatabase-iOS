//
//  DetailController.h
//  MetaMovie
//
//  Created by Swetha Ambati on 4/4/15.
//  Copyright (c) 2015 Swetha Ambati. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface DetailController : UIViewController <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource,MFMailComposeViewControllerDelegate>
- (IBAction)showEmail:(id)sender;
@property (nonatomic, strong) NSString *dispId,*dispYear,*dispGenre,*dispType;
@property (nonatomic, strong) NSString *sParam,*title,*year,*genre,*type;
@property (weak, nonatomic) IBOutlet UITextField *idParamVal;
@property (nonatomic, strong) NSArray *movieArr;
@property (weak, nonatomic) IBOutlet UITableView *txtDetailDisplay;
@end
