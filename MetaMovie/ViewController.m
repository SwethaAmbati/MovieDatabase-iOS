//
//  ViewController.m
//  MetaMovie
//
//  Created by Swetha Ambati on 4/3/15.
//  Copyright (c) 2015 Swetha Ambati. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "DetailController.h"

@interface ViewController ()
@property (nonatomic, strong) NSString *sParam,*title,*year,*genre,*type,*idParam,*yParam,*typeParam;
@property (nonatomic, strong) NSDictionary *moviesDictionary;
@property (nonatomic, strong) NSMutableDictionary *dict;
@property (nonatomic, strong) NSArray *movieArr;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.txtTitle.delegate=self;
    self.txtYear.delegate=self;
    self.txtType.delegate=self;
    self.txtDisplay.delegate=self;
    self.txtDisplay.dataSource=self;
    self.viewDisplay.backgroundColor = [UIColor colorWithRed:1.00 green:1.00 blue:1.00 alpha:1.0];
    self.txtTitle.backgroundColor= [UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0];
    self.txtType.backgroundColor= [UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0];
    self.txtYear.backgroundColor=[UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0];
    self.txtDisplay.hidden=YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.text=nil;
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.moviesDictionary=[[self.dict objectForKey:@"Search"] objectAtIndex:indexPath.row];
    self.idParam = [self.moviesDictionary objectForKey:@"imdbID"];
    [self performSegueWithIdentifier:@"cellSelectorSegue" sender:self];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"cellSelectorSegue"]) {
        DetailController *detailController = segue.destinationViewController;
        detailController.dispId = self.idParam;
    }
}



#pragma mark - UITableView(txtDisplay) implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    self.movieArr=self.dict[@"Search"];
    NSInteger numberOfRows = [self.movieArr count];
    return numberOfRows;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    self.moviesDictionary=[[self.dict objectForKey:@"Search"] objectAtIndex:indexPath.row];
    cell.textLabel.text =[NSString stringWithFormat:@"%@ (%@)", [self.moviesDictionary objectForKey:@"Title"], [self.moviesDictionary objectForKey:@"Year"]];
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30.0;
}

#pragma mark - Search Button - Fetching JSON implementation
- (IBAction)search:(id)sender {
    self.sParam=_txtTitle.text;
    self.yParam=_txtYear.text;
    self.typeParam=_txtType.text;
    if([self.sParam isEqual:@""])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert!!!"
                                                        message:@"Please enter a title"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
    NSString *urlString = [NSString stringWithFormat:@"http://www.omdbapi.com/?s=%@&y=%@&type=%@",self.sParam,self.yParam,self.typeParam];
    NSURL *url =     [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *e;
            self.dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
            if (e != nil) {
                NSLog(@"%@", [e localizedDescription]);
            }
            else{
                // Reload the table view.
                [self.txtDisplay reloadData];
                // Show the table view.
                self.txtDisplay.hidden = NO;
                self.txtDisplay.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            }
        }
    }];
    }
}

#pragma mark - handle orientation changes implementation
-(void)rotateToInterfaceDirection{
CGSize screenSize = [UIScreen mainScreen].bounds.size;
CGPoint center;
CGRect bounds = CGRectMake(0, 0, screenSize.width, screenSize.height);

if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
    center.x = screenSize.height * 0.5;
    center.y = screenSize.width * 0.5;
} else {
    center.x = screenSize.width * 0.5;
    center.y = screenSize.height * 0.5;
}

// Is the iOS version less than 8?
if( [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending ) {
    if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
        bounds.size.width = screenSize.height;
        bounds.size.height = screenSize.width;
    }
} else {
    bool sameAspect = ((UIInterfaceOrientationIsPortrait(self.interfaceOrientation) && UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) || (UIInterfaceOrientationIsLandscape(self.interfaceOrientation) && UIInterfaceOrientationIsLandscape(self.interfaceOrientation))) ? true : false;
        if (sameAspect) {
        bounds.size.width = screenSize.width;
        bounds.size.height = screenSize.height;
    } else {
        bounds.size.width = screenSize.height;
        bounds.size.height = screenSize.width;
    }
}
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    CGPoint center;
    if( [[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] == NSOrderedAscending ) {
        if(UIInterfaceOrientationIsLandscape(self.interfaceOrientation)) {
            center.x = screenSize.height * 0.5;
            center.y = screenSize.width * 0.5;
        } else {
            center.x = screenSize.width * 0.5;
            center.y = screenSize.height * 0.5;
        }
    } else {
        center.x = screenSize.width * 0.5;
        center.y = screenSize.height * 0.5;
    }
}
@end



















































