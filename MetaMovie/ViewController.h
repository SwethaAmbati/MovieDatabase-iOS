//
//  ViewController.h
//  MetaMovie
//
//  Created by Swetha Ambati on 4/3/15.
//  Copyright (c) 2015 Swetha Ambati. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController  <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtYear;
@property (weak, nonatomic) IBOutlet UITextField *txtType;
@property (strong, nonatomic) IBOutlet UIView *viewDisplay;
@property (weak, nonatomic) IBOutlet UITableView *txtDisplay;
- (IBAction)search:(id)sender;
@end

