//
//  aboutusViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 27/10/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import "aboutusViewController.h"
#import "SWRevealViewController.h"
#import "Map_ViewController.h"
@interface aboutusViewController ()

@end

@implementation aboutusViewController

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
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    // Do any additional setup after loading the view.
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    self.title =@"關於我們";
    list =[[NSMutableArray alloc]init];
    [list addObject:[NSString stringWithFormat:@"TEQWIN SOLUTION LIMITED"]];
    [list addObject:[NSString stringWithFormat:@"觀塘興業街 31 號,興業工廠大廈 9樓E室"]];
    [list addObject:[NSString stringWithFormat:@"http://www.teqwin.com.hk/"]];
    [list addObject:[NSString stringWithFormat:@"(852)23893939"]];
    [list addObject:[NSString stringWithFormat:@"teqwin@gmail.com"]];
    

       intro_list =[[NSMutableArray alloc]init];
    [intro_list addObject:[NSString stringWithFormat:@"TEQWIN SOLUTION LIMITED"]];


}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 1.0f;
    return 32.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return nil;
    } else {
        return @"xx";
    }
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return nil;
    } else {
        return @"xx";
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0)
        return 1.0f;
    return 32.0f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return [list count];
}
- (CGFloat) tableView: (UITableView*) tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    return 50;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //self.tableView.contentSize = CGSizeMake(self.tableView.frame.size.width,999);//(phoneCellHeight*phoneList.count)
    
    
    static NSString *identifier =@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    
    
    
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:identifier];
    }
    if (tableView == self.tableview) {
        
        switch (indexPath.row) {
                
                
            case 0:
                
            {
                cell.detailTextLabel.textColor =[UIColor whiteColor];
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
                [cell.textLabel setNumberOfLines:2];
                cell.textLabel.text = @"Name：";
                
            }
                
                break;
                
            case 1:
                
            {
                cell.detailTextLabel.textColor =[UIColor whiteColor];
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                [cell.textLabel setNumberOfLines:2];
                cell.textLabel.text = @"Address：";
            }
                
                break;
            case 2:
                
            {
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15 ];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
                cell.detailTextLabel.textColor=[UIColor whiteColor];
                cell.textLabel.text = @"Website：";
                //cell.accessoryType=UITableViewCellAccessoryDetailButton;
            }
                
                break;

            case 3:
                
            {
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15 ];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
                cell.detailTextLabel.textColor=[UIColor whiteColor];
                cell.textLabel.text = @"Tel：";
                //cell.accessoryType=UITableViewCellAccessoryDetailButton;
            }
                
                break;
            case 4:
                
            {
                [cell.detailTextLabel setNumberOfLines:5];
                cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-bold" size:15];
                cell.detailTextLabel.textColor=[UIColor whiteColor];
                cell.textLabel.text = @"Email：";
                //cell.accessoryType=UITableViewCellAccessoryDetailButton;
            }
                
                break;
                
                
            
        }
        
        cell.textLabel.textColor=[UIColor whiteColor];
        cell.detailTextLabel.text =[list objectAtIndex:indexPath.row];
        
        cell.contentView.backgroundColor = [UIColor grayColor];
        
        
    }
    
    
    return cell;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableview) {
        
        switch (indexPath.row) {
            //case 2:{
            //    Map_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Map_ViewController"];
            //    [self.navigationController pushViewController:mapVC animated:YES];
                
            //    mapVC.tattoomasterCell=_tattoomasterCell;
            //    NSLog(@"%@%@",self.tattoomasterCell.latitude,self.tattoomasterCell.longitude);
          //  }
            //    break;
            case 2:{
                
                NSURL *url = [NSURL URLWithString:@"http://www.teqwin.com.hk" ];
                [[UIApplication sharedApplication] openURL:url];
            }
                break;
            case 4:
                //Create the MailComposeViewController
                
            {
                MFMailComposeViewController *Composer = [[MFMailComposeViewController alloc]init];
                
                Composer.mailComposeDelegate = self;
                // email Subject
                [Composer setSubject:@"TEQWIN SOLUTION LIMITED"];
                //email body
                // [Composer setMessageBody:self.selectedTattoo_Master.name isHTML:NO];
                //recipient
                [Composer setToRecipients:[NSArray arrayWithObjects:@"sing.l@teqapps.com", nil]];            //get the filePath resource
                
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
            case 3:
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
                
        }}
    
    
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
    {NSURL *url =[NSURL URLWithString:@"852 23893939"];
        [[UIApplication sharedApplication] openURL:url];
       
        
    }}
- (IBAction)segmented:(id)sender {
    switch (_segmentControl.selectedSegmentIndex) {
        case 0:
            list =[[NSMutableArray alloc]init];
            [list addObject:[NSString stringWithFormat:@"TEQHOST Asia is a dedicated Solution Architect and Systems Integration business. We address business-critical problems in order to implement major change programs in large and complex systems across a variety of industries throughout the APAC, and are driven to be recognized for excellence in performance, value-creation and service, concentrating on delivering outcomes for our clients, rather than simply seeing a series of deliveries."]];
                      [_tableview reloadData];
            break;
        case 1:
            list =[[NSMutableArray alloc]init];
            [list addObject:[NSString stringWithFormat:@"TEQWIN SOLUTION LIMITED"]];
            [list addObject:[NSString stringWithFormat:@"觀塘興業街 31 號,興業工廠大廈 9樓E室"]];
            [list addObject:[NSString stringWithFormat:@"http://www.teqwin.com.hk/"]];
            [list addObject:[NSString stringWithFormat:@"(852)23893939"]];
            [list addObject:[NSString stringWithFormat:@"teqwin@gmail.com"]];
                  [_tableview reloadData];
        default:
            break;
    }}
@end
