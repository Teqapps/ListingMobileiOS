//
//  ViewController.m
//  SidebarDemo
//
//  Created by Simon on 28/6/13.
//  Copyright (c) 2013 Appcoda. All rights reserved.
//
#import "Tattoo_Master_Info.h"
#import "MainViewController.h"
#import "SWRevealViewController.h"
#import <Parse/Parse.h>
@interface MainViewController ()

{
    
    HomeModel *_homeModel;
    NSArray *_feedItems;
    Tattoo_Master_Info *_selected_tattoo_master;
    NSArray *searchResults;
}



@end

@implementation MainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        self.test.text = @"hihiuser";
    } else {
        self.test.text = @"on9son";
        
    }

   


    self.title = @"News";
self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.jpg"]];
    // Change button color
    _sidebarButton.tintColor = [UIColor colorWithWhite:0.1f alpha:0.9f];
    
    // Set the side bar button action. When it's tapped, it'll show up the sidebar.
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
   }

-(void)itemsDownloaded:(NSArray *)items
{
    // This delegate method will get called when the items are finished downloading
    
    // Set the downloaded items to the array
    _feedItems = items;
    
    
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
