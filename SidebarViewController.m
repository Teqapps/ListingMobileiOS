//
//  SidebarViewController.m
//  SidebarDemo
//
//  Created by Simon on 29/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//

#import "SidebarViewController.h"
#import "SWRevealViewController.h"
#import "LoginUIViewController.h"

#import "LoginUIViewController.h"
@interface SidebarViewController ()

@end

@implementation SidebarViewController {
    NSArray *menuItems;
}
@synthesize tableview;

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([PFUser currentUser]) {
        self.profile_image.layer.cornerRadius =self.profile_image.frame.size.width / 2;
        self.profile_image.layer.borderWidth = 3.0f;
        self.profile_image.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profile_image.clipsToBounds = YES;

        
        
        if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
            // If user is linked to Twitter, we'll use their Twitter screen name
            self.welcome.text =[NSString stringWithFormat:NSLocalizedString(@"@%@!", nil), [PFTwitterUtils twitter].screenName];
            
            
            
            
        } else if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            // If user is linked to Facebook, we'll use the Facebook Graph API to fetch their full name. But first, show a generic Welcome label.
            self.welcome.text =[NSString stringWithFormat:NSLocalizedString(@"", nil)];
            
            // Create Facebook Request for user's details
            FBRequest *request = [FBRequest requestForMe];
            [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                
                
                
                
                // handle response
                if (!error) {
                    // Parse the data received
                    NSDictionary *userData = (NSDictionary *)result;
                    
                    NSString *facebookID = userData[@"id"];
                    NSMutableDictionary *userProfile = [NSMutableDictionary dictionaryWithCapacity:7];
                    if (facebookID) {
                        userProfile[@"facebookId"] = facebookID;
                    }
                    
                    NSString *name = userData[@"name"];
                    if (name) {
                        userProfile[@"name"] = name;
                    }
                    
                    userProfile[@"pictureURL"] = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID];
                    [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
                    [[PFUser currentUser] saveInBackground];
                    [self _updateProfileData];
                    NSString *displayName = result[@"name"];
                    if (displayName) {
                        self.welcome.text =[NSString stringWithFormat:NSLocalizedString(@"%@", nil), name];
                    }
                }
            }];
            
        } else {
            // If user is linked to neither, let's use their username for the Welcome label.
            self.welcome.text =[NSString stringWithFormat:NSLocalizedString(@"歡迎 %@", nil), [PFUser currentUser].username];
            
        }
        
    } else {
        self.profile_image.layer.cornerRadius =self.profile_image.frame.size.width / 2;
        self.profile_image.layer.borderWidth = 3.0f;
        self.profile_image.layer.borderColor = [UIColor whiteColor].CGColor;
        self.profile_image.clipsToBounds = YES;

        self.profile_image.image = [UIImage imageNamed:@"FACEBOOK.JPG"];
        self.welcome.text = nil;
    }
    
}



// Set received values if they are not nil and reload the table
- (void)_updateProfileData {
    
    
    // Set the name in the header view label
    NSString *name = [PFUser currentUser][@"profile"][@"name"];
    if (name) {
        self.welcome.text = name;
    }
    
    NSString *userProfilePhotoURLString = [PFUser currentUser][@"profile"][@"pictureURL"];
    // Download the user's facebook profile picture
    if (userProfilePhotoURLString) {
        NSURL *pictureURL = [NSURL URLWithString:userProfilePhotoURLString];
        NSURLRequest *urlRequest = [NSURLRequest requestWithURL:pictureURL];
        
        [NSURLConnection sendAsynchronousRequest:urlRequest
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                   if (connectionError == nil && data != nil) {
                                       self.profile_image.image = [UIImage imageWithData:data];
                                       
                                       // Add a nice corner radius to the image
                                       self.profile_image.layer.cornerRadius =self.profile_image.frame.size.width / 2;
                                       self.profile_image.layer.borderWidth = 3.0f;
                                       self.profile_image.layer.borderColor = [UIColor whiteColor].CGColor;
                                       self.profile_image.clipsToBounds = YES;

                                   } else {
                                       NSLog(@"Failed to load profile photo.");
                                   }
                               }];
    }
}


- (void)viewDidLoad
{
 
    
    
    
         self.tableview.backgroundColor = [UIColor clearColor];
self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background1.jpg"]];
    menuItems = @[@"title", @"新消息",@"紋身歷史" ,@"紋身注意事項",@"找紋身師傅",@"我的最愛"];
    list =[[NSMutableArray alloc]init];
    [list addObject:[NSString stringWithFormat:@"title"]];
    
    [list addObject:[NSString stringWithFormat:@"新消息"]];
    [list addObject:[NSString stringWithFormat:@"紋身歷史"]];
    [list addObject:[NSString stringWithFormat:@"紋身注意事項"]];
    [list addObject:[NSString stringWithFormat:@"找紋身師傅"]];
[list addObject:[NSString stringWithFormat:@"我的最愛"]];
   ;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (cell==nil) {
        cell =[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }

    switch (indexPath.row) {
            case 0:
        {
            cell.textLabel.text=@"TEQWIN";
            cell.textLabel.font=[cell.textLabel.font fontWithSize:18];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
            break;
        case 1:
        {
            cell.imageView.image =[UIImage imageNamed:@"new-icon.png"];
            cell.textLabel.text=@"新消息";
            cell.textLabel.font=[cell.textLabel.font fontWithSize:12];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
            break;
        case 2:
        {
            cell.imageView.image =[UIImage imageNamed:@"history.png"];
            cell.textLabel.text=@"紋身歷史";
            cell.textLabel.font=[cell.textLabel.font fontWithSize:12];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
            break;
        case 3:
        {
            cell.imageView.image =[UIImage imageNamed:@"notice.png"];
            cell.textLabel.text=@"紋身注意事項";
            cell.textLabel.font=[cell.textLabel.font fontWithSize:12];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
            break;

               case 4 :
        {
            cell.imageView.image =[UIImage imageNamed:@"master_icon.png"];
            cell.textLabel.text=@"找紋身師傅";
            cell.textLabel.font=[cell.textLabel.font fontWithSize:12];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
            break;
        case 5:
        {
            cell.imageView.image =[UIImage imageNamed:@"Favorites-icon.png"];
            cell.textLabel.text=@"我的最愛";
            cell.textLabel.font=[cell.textLabel.font fontWithSize:12];
            [cell.textLabel setTextColor:[UIColor whiteColor]];
        }
            break;
       
      
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.backgroundView.backgroundColor = [UIColor clearColor];

    return cell;
}

- (void) prepareForSegue: (UIStoryboardSegue *) segue sender: (id) sender
{
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableview indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[menuItems objectAtIndex:indexPath.row] capitalizedString];
    
       
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
    
}




@end
