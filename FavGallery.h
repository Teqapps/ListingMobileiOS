//
//  FavGallery.h
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 12/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DetailFavViewController.h"
@interface FavGallery : UIViewController<UIDocumentInteractionControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, assign) BOOL isFav;
@property (nonatomic, strong) NSString *venueId;
@property (weak, nonatomic) IBOutlet UITextView *textview;
- (IBAction)btn_like:(id)sender;
- (IBAction)btn_comment:(id)sender;
- (IBAction)btn_share:(id)sender;
@property (strong, nonatomic) NSManagedObject *data;
@property(nonatomic,retain) UIDocumentInteractionController *documentationInteractionController;
@end
