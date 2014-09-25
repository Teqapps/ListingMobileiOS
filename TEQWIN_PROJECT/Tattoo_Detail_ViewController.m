//
//  Tattoo_Detail_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 29/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import "Gallery.h"
#import "ParseImageViewController.h"
#import "Tattoo_Detail_ViewController.h"
#import "SWRevealViewController.h"
#import "TattooMaster_ViewController.h"
#import "Master_Map_ViewController.h"
#import "FavDataManager.h"
#import "Venue.h"
#import "Map_ViewController.h"

@import CoreData;
@interface Tattoo_Detail_ViewController ()
{
    int lastClickedRow;
}
@end

@implementation Tattoo_Detail_ViewController




-(void)change:(UISegmentedControl *)segmentControl{
    NSLog(@"segmentControl %d",segmentControl.selectedSegmentIndex);
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self queryParseMethod];
    count=self.tattoomasterCell.favorites;
    _count_like.text=[NSString stringWithFormat:@"Liked:%d",count.count];
    
    //set segmented control
    
    
    self.profileimage.file=self.tattoomasterCell.imageFile;
    self.profileimage.layer.cornerRadius =self.profileimage.frame.size.width / 2;
    self.profileimage.layer.borderWidth = 3.0f;
    self.profileimage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.profileimage.clipsToBounds = YES;
    _tableView.bounces=YES;
	//
	// note: the following can be done in Interface Builder, but we show this in code for clarity
	
	
    
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
    
    
    
    
    list =[[NSMutableArray alloc]init];
    [list addObject:[NSString stringWithFormat:@"加入到我的最愛!!"]];
    
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.name]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.gender]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.address]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.website]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.email]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.tel]];
    
    
    
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.personage]];
    
    
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"師傅資料";
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"";
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [list count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width,999);//(phoneCellHeight*phoneList.count)
    
    
    static NSString *identifier =@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    switch (indexPath.row) {
            
        case 0:
            
        {
            cell.textLabel.text=@"%@";
            
            
        }
            
            break;
            
        case 1:
            
        {
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = @"Name：";
            
        }
            
            break;
            
        case 2:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = @"Gender：";
        }
            
            break;
            
        case 3:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Address：";
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
        case 4:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Website：";
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 5:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Email：";
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 6:
            
        {
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Telephone：";
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 7:
            
        {
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = @"Personage：";
            
        }
            
            break;
            
            
            
    }
    
    [cell.detailTextLabel setNumberOfLines:5];
    
    cell.detailTextLabel.text =[list objectAtIndex:indexPath.row];
    cell.detailTextLabel.font = [cell.textLabel.font fontWithSize:12];
    
    return cell;
    
}
- (BOOL)tableView:(UITableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (BOOL)tableView:(UITableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    return (action == @selector(copy:));
    
}

- (void)tableView:(UITableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender
{
    if (action == @selector(copy:))
        [UIPasteboard generalPasteboard].string = [list objectAtIndex:indexPath.row];
    NSLog(@"COPY  %@",[UIPasteboard generalPasteboard].string);
}
- (void)queryParseMethod {
    NSLog(@"start query");
    
    PFQuery *query = [PFQuery queryWithClassName:@"Tattoo_Master"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
            
            
            
        }
    }];
}
- (void) dislike {
    [object removeObject:[PFUser currentUser].objectId forKey:@"favorites"];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [self dislikedSuccess];
            
        }
        else {
            [self dislikedFail];
        }
    }];
}
- (void) dislikedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"已經取消我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) dislikedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"失敗" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
- (void) likeImage {
    [object addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            [self likedSuccess];
            
        }
        else {
            [self likedFail];
        }
    }];
}

- (void) likedSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"You have succesfully liked the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) likedFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"There was an error when liking the image" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    switch (indexPath.row) {
        case 0:{
            {
                
                
                object = [imageFilesArray objectAtIndex:indexPath.row];
                imageObject = [imageFilesArray objectAtIndex:indexPath.row];
                
                count=[imageObject objectForKey:@"favorites"];
                
                NSLog(@"%d",count.count);
                NSLog(@"%@",object);
                
                if (self.isFav) {
                    [self likeImage];
                }
                else
                {
                    [self dislike];
                    
                }
            }}
            break;
        case 3:{
            Map_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Map_ViewController"];
            [self.navigationController pushViewController:mapVC animated:YES];
            mapVC.tattoomasterCell=_tattoomasterCell;
            NSLog(@"%@%@",self.tattoomasterCell.latitude,self.tattoomasterCell.longitude);
        }
            break;
        case 4:{
            
            NSURL *url = [NSURL URLWithString:self.tattoomasterCell.website ];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 5:
            //Create the MailComposeViewController
            
        {
            MFMailComposeViewController *Composer = [[MFMailComposeViewController alloc]init];
            
            Composer.mailComposeDelegate = self;
            // email Subject
            [Composer setSubject:self.tattoomasterCell.name];
            //email body
            // [Composer setMessageBody:self.selectedTattoo_Master.name isHTML:NO];
            //recipient
            [Composer setToRecipients:[NSArray arrayWithObjects:self.tattoomasterCell.email, nil]];            //get the filePath resource
            
            // NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ive" ofType:@"png"];
            
            //Read the file using NSData
            
            //   NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            
            // NSString *mimeType = @"image/png";
            
            //Add attachement
            
            //  [Composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
            
            //Present it on the screen
            
            [self presentViewController:Composer animated:YES completion:nil];
            
            break;}
            
            //make alert box and phonecall function
        case 6:
        {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"撥號"
                                                            message:@"確定要撥號嗎？"
                                                           delegate:self
                                                  cancelButtonTitle:@"否"
                                                  otherButtonTitles:@"是",nil];
            //然后这里设定关联，此处把indexPath关联到alert上
            
            [alert show];
            
            
            
        }
            break;
            
    }
}
//- (IBAction)getDirectionButtonPressed:(id)sender {
// UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get Direction"
//                                                     message:@"Go to Maps?"
//                                                  delegate:self
//                                         cancelButtonTitle:@"取消"
//                                         otherButtonTitles:@"確定", nil];
// alertView.delegate = self;
//[alertView show];
//}


-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error

{
    switch (result) {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail Cancelled");
            break;
            
        case MFMailComposeResultSaved:
            
            NSLog(@"Mail Saved");
            break;
            
        case MFMailComposeResultSent:
            NSLog(@"Mail Sent");
            break;
            
        case MFMailComposeResultFailed:
            
            NSLog(@"Mail Failed");
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *button = [alertView buttonTitleAtIndex:buttonIndex];
    if([button isEqualToString:@"是"])
    {NSURL *url =[NSURL URLWithString:self.tattoomasterCell.tel];
        [[UIApplication sharedApplication] openURL:url];
        NSLog(@"done%@",self.tattoomasterCell.tel);
        
    }}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.isFav = [self isFavorited];
    if (self.isFav){
        NSLog(@"like");
        //[self.favButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
        
        //[self.favButton setTitle:@"Unfav" forState:UIControlStateNormal];
    } else {
        
        NSLog(@"unlike");
        
        //[self.favButton setImage:[UIImage imageNamed:@"heart_empty.png"] forState:UIControlStateNormal];
        
        //[self.favButton setTitle:@"Fav" forState:UIControlStateNormal];
    }
    
    
}
- (BOOL)isFavorited
{
    
    PFQuery *innerQuery = [PFQuery queryWithClassName:@ "Tattoo_Master" ];
    [innerQuery whereKeyExists:[PFUser currentUser].objectId];
    PFQuery *query = [PFQuery queryWithClassName:@ "Tattoo_Master" ];
    [query whereKey:@ "favorites"  matchesQuery:innerQuery];
    NSLog(@"%@",innerQuery);
    
    return YES;
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"GOGALLERY"]) {
        
        
        if ([segue.destinationViewController isKindOfClass:[Gallery class]]){
            NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
            Gallery *receiver = (Gallery*)segue.destinationViewController;
            receiver.tattoomasterCell=_tattoomasterCell;
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
}




@end
