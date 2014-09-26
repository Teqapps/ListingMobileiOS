//
//  DetailFavViewController.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 4/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SWRevealViewController.h"
#import "DetailFavViewController.h"
#import "FavDataManager.h"
#import "Venue.h"
#import "Fav_Map_ViewController.h"
#import "Fav_mappoint_ViewController.h"
#import "FavGallery.h"
@import CoreData;
@interface DetailFavViewController ()
{
    NSArray *_feedItems;
}
@property (strong, nonatomic) NSArray *dataSource;
@end

@implementation DetailFavViewController
const CGFloat kScrollObjHeight	= 200.0;
const CGFloat kScrollObjWidth	= 320.0;
const NSUInteger kNumImages		= 5;
- (void)layoutScrollImages
{
	UIImageView *view = nil;
	NSArray *subviews = [_favscroll subviews];
    
	// reposition all image subviews in a horizontal serial fashion
	CGFloat curXLoc = 0;
	for (view in subviews)
	{
		if ([view isKindOfClass:[UIImageView class]] && view.tag > 0)
		{
			CGRect frame = view.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			view.frame = frame;
			
			curXLoc += (kScrollObjWidth);
		}
	}
	
	// set the content size so it can be scrollable
	[_favscroll setContentSize:CGSizeMake((kNumImages * kScrollObjWidth), [_favscroll bounds].size.height)];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //set segmented control
    UISegmentedControl *favsegCtr;
    favsegCtr = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"找其他師傅", @"作品庫", nil]];
    favsegCtr.tintColor = [UIColor blueColor];
    //设置在点击后是否恢复原样
    favsegCtr.momentary = YES;
    //segCtr.selectedSegmentIndex = 0;
    
    [favsegCtr addTarget:self
               action:@selector(favsegmentAction:)
     forControlEvents:UIControlEventValueChanged];
    self.tabelview.tableHeaderView = favsegCtr;

    
    
    
    _tabelview.bounces=NO;
	[_favscroll setCanCancelContentTouches:NO];
	_favscroll.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	_favscroll.clipsToBounds = YES;		// default is NO, we want to restrict drawing within our scrollview
	_favscroll.scrollEnabled = YES;
    _favscroll.pagingEnabled = YES;
	// pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
	// if you want free-flowing scroll, don't set this property.
	// load all the images from our bundle and add them to the scroll view
	//NSUInteger i;
//	for (i = 1; i <= 5; i++)
	//{
     //   NSString *picURLstring = [NSString stringWithFormat:@"http://localhost:8888/phpMyAdmin///fyp_php/gallery_0%@_%d.jpg",[self.data valueForKey:@"master_id"] , i] ;
      //  NSURL *picURL = [NSURL URLWithString:picURLstring] ;
      //  UIImage *Slide = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:picURL]];
     //   UIImageView *imageView = [[UIImageView alloc] initWithImage:Slide];

		// setup each frame to a default height and width, it will be properly placed when we call "updateScrollList"
	//	CGRect rect = imageView.frame;
	//	rect.size.height = kScrollObjHeight;
	//	rect.size.width = kScrollObjWidth;
	//	imageView.frame = rect;
	//	imageView.tag = i;
        
		//[_favscroll addSubview:imageView];
	//}
   // self.favscroll.layer.cornerRadius = 15.0f;
   // self.favscroll.layer.borderWidth  = 5.0f;
  //  _favscroll.bounces = NO;
//	[self layoutScrollImages];	// now place the photos in serial layout within the scrollview
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    _feedItems = [[NSArray alloc] init];
    list =[[NSMutableArray alloc]init];
    [list addObject:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"name"]]];
    [list addObject:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"gender"]]];
    [list addObject:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"address"]]];
    [list addObject:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"website"]]];
    [list addObject:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"email"]]];
    [list addObject:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"tel"]]];
    [list addObject:[NSString stringWithFormat:@"%@",[self.data valueForKey:@"personage"]]];
    
   
}
-(void)favsegmentAction:(UISegmentedControl *)Seg
{
    NSInteger index = Seg.selectedSegmentIndex;
    switch (index) {
        case 0:
        {
            [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"TattooMaster_ViewController"] animated:YES];
            
        }
            
            break;
        case 1:
        {
            
            FavGallery *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FavGallery"];
            [self.navigationController pushViewController:galleryVC animated:YES];
            galleryVC.data=_data;
            
        }
            
            break;
      
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"師傅資料";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30.0f;
}
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    return @"";
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [list count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
        case 3:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Website：";
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 4:
            
        {
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Email：";
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 5:
            
        {
            
            cell.textLabel.font = [cell.textLabel.font fontWithSize:12];
            [cell.textLabel setNumberOfLines:2];
            [cell.detailTextLabel setTextColor:[UIColor blueColor]];
            cell.textLabel.text = @"Telephone：";
            cell.accessoryType=UITableViewCellAccessoryDetailButton;
        }
            
            break;
            
        case 6:
            
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

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    _feedItems = items;
    
    // Reload the table view
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    switch (indexPath.row) {
        case 2:{
        Fav_mappoint_ViewController *galleryVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Fav_mappoint_ViewController"];
            [self.navigationController pushViewController:galleryVC animated:YES];
            galleryVC.data=_data;
        }
            break;
        case 3:{
            NSURL *url = [NSURL URLWithString:[self.data valueForKey:@"website"]];
            [[UIApplication sharedApplication] openURL:url];
        }
            break;
        case 4:
            //Create the MailComposeViewController
            
        {
            MFMailComposeViewController *Composer = [[MFMailComposeViewController alloc]init];
            
            Composer.mailComposeDelegate = self;
            // email Subject
            [Composer setSubject:[self.data valueForKey:@"name"]];
            //email body
            [Composer setMessageBody:@"helloworld" isHTML:NO];
            //recipient
            [Composer setToRecipients:[NSArray arrayWithObjects:[self.data valueForKey:@"email"], nil]];            //get the filePath resource
            
            NSString *filePath = [[NSBundle mainBundle]pathForResource:@"ive" ofType:@"png"];
            
            //Read the file using NSData
            
            NSData *fileData = [NSData dataWithContentsOfFile:filePath];
            
            NSString *mimeType = @"image/png";
            
            //Add attachement
            
            [Composer addAttachmentData:fileData mimeType:mimeType fileName:filePath];
            
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
- (IBAction)getDirectionButtonPressed:(id)sender {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Get Direction"
                                                        message:@"Go to Maps?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Go", nil];
    alertView.delegate = self;
    [alertView show];
}


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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    self.isFav = [self isFavorited];
    if (self.isFav){
        
        //[self.favButton setTitle:@"Unfav" forState:UIControlStateNormal];
        [self.favButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    } else {
        //[self.favButton setTitle:@"Fav" forState:UIControlStateNormal];
        [self.favButton setImage:[UIImage imageNamed:@"heart_empty.png"] forState:UIControlStateNormal];
    }
    
    
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
    NSLog(@"successful copy %@",[list objectAtIndex:indexPath.row]);
}
- (BOOL)isFavorited
{
    FavDataManager *manager = [FavDataManager sharedInstance];
    NSManagedObjectContext *context = [manager mainObjectContext];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Venue" inManagedObjectContext:context];
    [request setEntity:entityDescription];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [self.data valueForKey:@"name"]];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *results = [context executeFetchRequest:request error:&error];
    
    if ([results count] >= 1) {
        if ([results count] > 1){
            NSLog(@"Error:  favs");
        }
        
        return YES;
    } else {
        return NO;
    }
}


- (IBAction)favButton:(id)sender {
    FavDataManager *manager = [FavDataManager sharedInstance];
    NSManagedObjectContext *context = [manager mainObjectContext];
    
    if (self.isFav) {
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityDescription = [NSEntityDescription
                                                  entityForName:@"Venue" inManagedObjectContext:context];
        [request setEntity:entityDescription];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", [self.data valueForKey:@"name"]];
        [request setPredicate:predicate];
        
        NSError *error;
        NSArray *results = [context executeFetchRequest:request error:&error];
        
        
               [manager save];
        // should handle error
        for (NSManagedObject *obj in results) {
            [context deleteObject:obj];
               [manager save];
        }
        

        NSLog(@"Deleted fav");
        
        self.isFav = NO;
        //[self.favButton setTitle:@"Fav" forState:UIControlStateNormal];
        [self.favButton setImage:[UIImage imageNamed:@"heart_empty.png"] forState:UIControlStateNormal];
        [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"AddFavTableViewController"] animated:YES];
    } else {
        
        Venue *venue = [NSEntityDescription insertNewObjectForEntityForName:@"Venue"
                                                     inManagedObjectContext:context];
        
        [venue setValue:self.venueId forKey:@"name"];
        venue.name = [self.data valueForKey:@"name"];
        venue.gender = [self.data valueForKey:@"gender"];
        venue.address = [self.data valueForKey:@"address"];
        venue.website = [self.data valueForKey:@"website"];
        venue.email = [self.data valueForKey:@"email"];
        venue.tel = [self.data valueForKey:@"tel"];
        venue.personage = [self.data valueForKey:@"personage"];
        venue.image = [self.data valueForKey:@"image"];
        venue.gallery1 = [self.data valueForKey:@"gallery1"];
        venue.gallery2 = [self.data valueForKey:@"gallery2"];
        venue.gallery3 = [self.data valueForKey:@"gallery3"];
        venue.gallery4 = [self.data valueForKey:@"gallery4"];
        venue.gallery5 = [self.data valueForKey:@"gallery5"];
        
        [manager save];
        
        NSLog(@"Added fav");
        
        self.isFav = YES;
        //[self.favButton setTitle:@"Unfav" forState:UIControlStateNormal];
        [self.favButton setImage:[UIImage imageNamed:@"heart.png"] forState:UIControlStateNormal];
    }
    
    
    
    
}


@end