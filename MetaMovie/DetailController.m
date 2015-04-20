//
//  DetailController.m
//  MetaMovie
//
//  Created by Swetha Ambati on 4/4/15.
//  Copyright (c) 2015 Swetha Ambati. All rights reserved.
//

#import "DetailController.h"
#import "AppDelegate.h"



@interface DetailController ()

-(void) mailComposeController;
-(void)detailViewMethod;
@property (nonatomic, strong)UIImage *image;
@end
@implementation DetailController
@synthesize idParamVal;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtDetailDisplay.delegate=self;
    self.txtDetailDisplay.dataSource=self;
    idParamVal=self.dispId;
    [self detailViewMethod];
}



#pragma mark - Fetching details of movie implementation
-(void)detailViewMethod{
    NSString *urlString = [NSString stringWithFormat:@"http://www.omdbapi.com/?i=%@",self.idParamVal];
    NSURL *url =     [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [AppDelegate downloadDataFromURL:url withCompletionHandler:^(NSData *data) {
        if (data != nil) {
            NSError *e;
            self.movieArr = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&e];
            if (e != nil) {
                NSLog(@"%@", [e localizedDescription]);
            }
            else{
                NSString *profilePictureID = [self.movieArr valueForKey:@"Poster"];
                NSString *imageUrl = [[NSString alloc] initWithFormat:@"%@",profilePictureID];
                self.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]];
                [self.txtDetailDisplay reloadData];
                // Show the table view.
                self.txtDetailDisplay.hidden = NO;
                self.txtDetailDisplay.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
                self.txtDetailDisplay.scrollEnabled=NO;
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView(txtDetailDisplay)implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.95 green:0.96 blue:0.97 alpha:1.0];
        }
    
    
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image=self.image;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ [%@]", [self.movieArr valueForKey:@"Title"], [self.movieArr valueForKey:@"Year"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ | %@", [self.movieArr valueForKey:@"Runtime"], [self.movieArr valueForKey:@"Genre"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
            break;
        case 1:
            cell.textLabel.text = @"Plot:";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ", [self.movieArr valueForKey:@"Plot"]];
            cell.textLabel.font = [UIFont systemFontOfSize:12.0];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:10.0];
            cell.detailTextLabel.numberOfLines = 0;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            break;
        case 2:
            cell.textLabel.text = [NSString stringWithFormat:@"Ratings: %@/10",[self.movieArr valueForKey:@"imdbRating"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Metascore: " @"%@", [self.movieArr valueForKey:@"Metascore"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
            cell.textLabel.font = [UIFont systemFontOfSize:8.0];
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"Actors: %@",[self.movieArr valueForKey:@"Actors"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"Director: %@",[self.movieArr valueForKey:@"Director"]];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:8.0];
            cell.textLabel.font = [UIFont systemFontOfSize:8.0];
            break;
        default:
            break;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0) {
        return 80.0;
    }
    else if (indexPath.row == 1)
    {
        return 80.0;
    }
    else
    {
        return 35.0;
    }
}



#pragma mark - compose email implementation
- (IBAction)showEmail:(id)sender {
    NSString *emailTitle = [self.movieArr valueForKey:@"Title"];
    // Email Content
    
    NSString *emailBody = [NSString stringWithFormat:@"%@%@",[self.movieArr valueForKey:@"Title"],[self.movieArr valueForKey:@"Year"]];
    // To address
    MFMailComposeViewController *mailView = [[MFMailComposeViewController alloc] init];
    mailView.mailComposeDelegate = self;
    [mailView setSubject:emailTitle];
    [mailView setMessageBody:emailBody isHTML:YES];
    [mailView setTitle:emailTitle];
    // Present mail view controller on screen
    [self presentViewController:mailView animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
