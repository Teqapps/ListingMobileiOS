//
//  Tattoo_Detail_ViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 29/7/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//=
#import "GalleryCell.h"
#import "Gallery.h"
#import "ImageExampleCell.h"
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
    CGRect frame_first;
    UIImageView *fullImageView;
    
}
@end

@implementation Tattoo_Detail_ViewController





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
    [self queryParseMethod_image];
   

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
     [self.imagesCollection setCollectionViewLayout:flowLayout];
    flowLayout.itemSize = CGSizeMake(70, 70);
    self.title =self.tattoomasterCell.name;
    self.count_like.text =[NSString stringWithFormat:@"%d",self.tattoomasterCell.favorites.count    ]   ;
    
    //set segmented control
    if ([self.tattoomasterCell.bookmark containsObject:[PFUser currentUser].objectId]) {
        self.bookmark_image.image =[UIImage imageNamed:@"button_heart_red.png"];
    }
    else {
        self.bookmark_image.image =[UIImage imageNamed:@"button_heart_blue.png"];
    }
    
    if ([self.tattoomasterCell.favorites containsObject:[PFUser currentUser].objectId]) {
        self.fav_image.image =[UIImage imageNamed:@"button_heart_red.png"];
    }
        else {
            self.fav_image.image =[UIImage imageNamed:@"button_heart_blue.png"];
        }
    self.master_name.text=self.tattoomasterCell.name;
    
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
   
    
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.name]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.gender]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.address]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.website]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.email]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.tel]];
    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.personage]];
 //    [list addObject:[NSString stringWithFormat:@"%@",self.tattoomasterCell.description]];
    
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
- (void)queryParseMethod_image{
    NSLog(@"start query_image");
   
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"Master_id" equalTo:self.tattoomasterCell.master_id];
    query.cachePolicy = kPFCachePolicyCacheThenNetwork;

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray_image = [[NSArray alloc] initWithArray:objects];
            
            
            [_imagesCollection reloadData];
            NSLog(@"%d",imageFilesArray_image.count);
        }
    }];
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [imageFilesArray_image count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 9, 10);
    layout.itemSize = CGSizeMake(44, 44);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
  

    static NSString *cellIdentifier = @"imageCell";
    ImageExampleCell *cell = (ImageExampleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PFObject *imageObject = [imageFilesArray_image objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"image"];
    
    cell.loadingSpinner.hidden = NO;
    [cell.loadingSpinner startAnimating];
    
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.parseImage.image = [UIImage imageWithData:data];
            [cell.loadingSpinner stopAnimating];
            cell.loadingSpinner.hidden = YES;
            [ cell.parseImage addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];

        }
    }];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",[imageFilesArray_image objectAtIndex:indexPath.row]);
  

}



- (CGFloat) tableView: (UITableView*) tableView heightForRowAtIndexPath: (NSIndexPath*) indexPath
{
    return 30;
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
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = @"Name：";
            
        }
            
            break;
            
        case 1:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = @"Gender：";
        }
            
            break;
            
        case 2:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Address：";
            //cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
        case 3:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Website：";
            //cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 4:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Email：";
            //cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 5:
            
        {
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Telephone：";
            //cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 6:
            
        {
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = @"Personage：";
            
        }
            
            break;
        case 7:
            
        {
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            cell.textLabel.text = @"Description：";
            
  
        }
    }
    
    [cell.detailTextLabel setNumberOfLines:5];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
    cell.detailTextLabel.text =[list objectAtIndex:indexPath.row];
    
    cell.contentView.backgroundColor = [UIColor grayColor];
    
    cell.textLabel.textColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:1];
    cell.detailTextLabel.textColor = [UIColor colorWithRed:100 green:100 blue:100 alpha:1];
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
    
    [query whereKey:@"Master_id" equalTo:self.tattoomasterCell.master_id];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            imageFilesArray = [[NSArray alloc] initWithArray:objects];
           
        }
    }];
   

}


- (void) likeImage {
   
    [object addUniqueObject:[PFUser currentUser].objectId forKey:@"favorites"];
    
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            //[self likedSuccess];
             self.isFav = YES;
        }
        else {
            [self likedFail];
        }
    }];
}
- (void) dislike {
        [object removeObject:[PFUser currentUser].objectId forKey:@"favorites"];
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
           // [self dislikedSuccess];
             self.isFav = NO;
            
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
               case 2:{
            Map_ViewController * mapVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Map_ViewController"];
            [self.navigationController pushViewController:mapVC animated:YES];
            mapVC.tattoomasterCell=_tattoomasterCell;
            NSLog(@"%@%@",self.tattoomasterCell.latitude,self.tattoomasterCell.longitude);
        }
            break;
        case 3:{
            
            NSURL *url = [NSURL URLWithString:self.tattoomasterCell.website ];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 4:
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
        case 5:
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



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"GOGALLERY"]) {
        
        
        if ([segue.destinationViewController isKindOfClass:[Gallery class]]){
            NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
            Gallery *receiver = (Gallery*)segue.destinationViewController;
            receiver.tattoomasterCell=_tattoomasterCell;
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }
    if ([segue.identifier isEqualToString:@"GOGALLERY_collection"]) {
        
        
        if ([segue.destinationViewController isKindOfClass:[Gallery class]]){
            NSIndexPath * indexPath = [self.tableView indexPathForCell:sender];
            Gallery *receiver = (Gallery*)segue.destinationViewController;
            receiver.tattoomasterCell=_tattoomasterCell;
            [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
    }

}


- (IBAction)favButton:(id)sender {
      if ([PFUser currentUser]) {
          
  UIButton* button = sender;
    CGPoint correctedPoint =
    [button convertPoint:button.bounds.origin toView:self.tableView];
   NSIndexPath* indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
          object = [imageFilesArray objectAtIndex:indexPath.row];
          imageObject = [imageFilesArray objectAtIndex:indexPath.row];
    lastClickedRow = indexPath.row;
    object = [imageFilesArray objectAtIndex:indexPath.row];
          NSLog(@"%@",imageFilesArray);
          
          
          if ([[object objectForKey:@"favorites"]containsObject:[PFUser currentUser].objectId]) {
              
              [self dislike];
              
              NSLog(@"disliked");
                self.fav_image.image =[UIImage imageNamed:@"button_heart_blue.png"];

          }
          
          else{
              
              
              [self likeImage];
              
              NSLog(@"liked");
  self.fav_image.image =[UIImage imageNamed:@"button_heart_red.png"];

                        }
      }
      else{
          NSLog(@"請登入")
          ; }
    [self.tableView reloadData];
}


- (IBAction)bookmarkbtn:(id)sender {
    if ([PFUser currentUser]) {
        
        UIButton* button = sender;
        CGPoint correctedPoint =
        [button convertPoint:button.bounds.origin toView:self.tableView];
        NSIndexPath* indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
        object = [imageFilesArray objectAtIndex:indexPath.row];
        imageObject = [imageFilesArray objectAtIndex:indexPath.row];
        lastClickedRow = indexPath.row;
        object = [imageFilesArray objectAtIndex:indexPath.row];
        NSLog(@"%@",imageFilesArray);
        
        
        if ([[object objectForKey:@"bookmark"]containsObject:[PFUser currentUser].objectId]) {
            
            [self nobookmark];
            
            NSLog(@"disliked");
            self.bookmark_image.image =[UIImage imageNamed:@"button_heart_blue.png"];
            
        }
        
        else{
            
            
            [self bookmark];
            
            NSLog(@"liked");
            self.bookmark_image.image =[UIImage imageNamed:@"button_heart_red.png"];
            
        }
    }
    else{
        NSLog(@"請登入")
        ; }
    [self.tableView reloadData];
}
- (void) bookmark {
    
    [object addUniqueObject:[PFUser currentUser].objectId forKey:@"bookmark"];

    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            //[self likedSuccess];
            self.isbookmark = YES;
        }
        else {
            [self bookmarkFail];
        }
    }];
}
- (void) nobookmark {
    [object removeObject:[PFUser currentUser].objectId forKey:@"bookmark"];
    [object saveInBackground];
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            
            // [self dislikedSuccess];
            self.isbookmark = NO;
            
        }
        else {
            [self nobookmarkFail];
        }
    }];
}
- (void) nobookmarkSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"已經取消我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) nobookmarkFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"失敗" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) bookmarkSuccess {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success!" message:@"已經成功加入我的最愛" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}

- (void) bookmarkFail {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oooops!" message:@"失敗" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}
@end
