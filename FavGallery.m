//
//  FavGallery.m
//  TEQWIN_PROJECT
//
//  Created by Teqwin on 12/8/14.
//  Copyright (c) 2014年 Teqwin. All rights reserved.
//
#import "FavDataManager.h"
#import "Venue.h"
@import CoreData;
#import "Tattoo_Detail_ViewController.h"
#import "Tattoo_Master_Info.h"
#import "FavGallery.h"
#import "FavGalleryCell.h"
#import "SWRevealViewController.h"
#import "CFShareCircleView.h"
#import <Social/Social.h>
#import <FacebookSDK/FacebookSDK.h>
@interface FavGallery ()<UIScrollViewDelegate,CFShareCircleViewDelegate>
{
    Tattoo_Master_Info *_selected_tattoo_master;
    CFShareCircleView *shareCircleView;
    CGRect frame_first;
    UIImageView *fullImageView;
     int lastClickedRow;
}


@end

@implementation FavGallery

- (void)viewDidLoad
{
    [super viewDidLoad];
    
   
    self.title=@"作品庫";

    self.tableView.bounces=NO;
    // Create array object and assign it to _feedItems variable
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
     self.navigationController.navigationBar.translucent = NO;
    shareCircleView = [[CFShareCircleView alloc] initWithFrame:self.view.frame];
    shareCircleView.delegate = self;
    [self.navigationController.view addSubview:shareCircleView];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"parallaxCell";
    FavGalleryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //cell.titleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"Cell %d",), indexPath.row];
    cell.label.text = @"Like";

    cell.label2.text =@"Comment";
    cell.label3.text =@"Share";
    //cell.subtitleLabel.text = [NSString stringWithFormat:NSLocalizedString(@"This is a parallex cell %d",),indexPath.row];
    
    NSString *picURLstring = [NSString stringWithFormat:@"https://localhost:443/phpMyAdmin/fyp_php/gallery_0%@_%ld.jpg",[self.data valueForKey:@"master_id"],indexPath.row+1] ;
    
    NSURL *picURL = [NSURL URLWithString:picURLstring] ;
    
    UIImage *Slide = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:picURL]];
    cell.image.image = Slide;
    cell.image.tag=9999;
    cell.image.userInteractionEnabled=YES;
    [cell.image addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap:)]];
    return cell;
}

//按圖第一下放大至fullscreen
-(void)actionTap:(UITapGestureRecognizer *)sender{
    
    
    CGPoint location = [sender locationInView:self.tableView];
    NSIndexPath *indexPath  = [self.tableView indexPathForRowAtPoint:location];
    
    UITableViewCell *cell = (UITableViewCell *)[self.tableView  cellForRowAtIndexPath:indexPath];
    
    
    UIImageView *imageView=(UIImageView *)[cell.contentView viewWithTag:9999];
    
    
    frame_first=CGRectMake(cell.frame.origin.x+imageView.frame.origin.x, cell.frame.origin.y+imageView.frame.origin.y-self.tableView.contentOffset.y, imageView.frame.size.width, imageView.frame.size.height);
    
    fullImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
    fullImageView.backgroundColor=[UIColor blackColor];
    fullImageView.userInteractionEnabled=YES;
    [fullImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTap2:)]];
    fullImageView.contentMode=UIViewContentModeScaleAspectFit;
    
    if (![fullImageView superview]) {
        
        fullImageView.image=imageView.image;
        
        [self.view.window addSubview:fullImageView];
        
        
        
        fullImageView.frame=frame_first;
        [UIView animateWithDuration:0.5 animations:^{
            
            fullImageView.frame=CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height);
            
            
        } completion:^(BOOL finished) {
            
            [UIApplication sharedApplication].statusBarHidden=YES;
            
        }];
        UITextField *text = [[UITextField alloc]initWithFrame:CGRectMake(20, 20, 130, 30)];
        
        text.placeholder = @"password";
    }
    
}
////按圖第二下縮回原型
-(void)actionTap2:(UITapGestureRecognizer *)sender{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        fullImageView.frame=frame_first;
        
    } completion:^(BOOL finished) {
        
        [fullImageView removeFromSuperview];
        
    }];
    
    [UIApplication sharedApplication].statusBarHidden=NO;
    
}




- (IBAction)btn_like:(id)sender {
     [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginUIViewController"] animated:YES];
}

- (IBAction)btn_comment:(id)sender {
    [self.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginUIViewController"] animated:YES];
}

- (IBAction)btn_share:(id)sender {
    UIButton *button = sender;
    CGPoint correctedPoint =
    [button convertPoint:button.bounds.origin toView:self.tableView];
    NSIndexPath *indexPath =  [self.tableView indexPathForRowAtPoint:correctedPoint];
    
    
    NSLog(@"%ld",(long)button.tag);
    NSLog(@"%ld",(long)indexPath.row);
   // lastClickedRow = indexPath.row;
     [shareCircleView show];
}
- (void)shareCircleView:(CFShareCircleView *)aShareCircleView didSelectSharer:(CFSharer *)sharer{
    if ([sharer.name isEqual:@"Facebook"]) {
        
        // Check if the Facebook app is installed and we can present the share dialog
        FBLinkShareParams *params = [[FBLinkShareParams alloc] init];
        params.link = [NSURL URLWithString:@"https://developers.facebook.com/docs/ios/share/"];
        
        // If the Facebook app is installed and we can present the share dialog
        if ([FBDialogs canPresentShareDialogWithParams:params]) {
            
            // Present share dialog
            [FBDialogs presentShareDialogWithLink:params.link
                                          handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                              if(error) {
                                                  // An error occurred, we need to handle the error
                                                  // See: https://developers.facebook.com/docs/ios/errors
                                                  NSLog(@"Error publishing story: %@", error.description);
                                              } else {
                                                  // Success
                                                  NSLog(@"result %@", results);
                                              }
                                          }];
            
            // If the Facebook app is NOT installed and we can't present the share dialog
        } else {
            // FALLBACK: publish just a link using the Feed dialog
            
            // Put together the dialog parameters
            NSString *picURLstring = [NSString stringWithFormat:@"https://localhost:443/phpMyAdmin/fyp_php/gallery_0%@_%d.jpg",[self.data valueForKey:@"master_id"],lastClickedRow+1] ;
            
            
            
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           [self.data valueForKey:@"name"], @"name",
                                           @"TEQWIN SOLUTION", @"caption",
                                           @"作品", @"description",
                                           picURLstring, @"link",
                                           picURLstring,@"picture",
                                           nil];
            // Show the feed dialog
            [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                                   parameters:params
                                                      handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                          if (error) {
                                                              // An error occurred, we need to handle the error
                                                              // See: https://developers.facebook.com/docs/ios/errors
                                                              NSLog(@"Error publishing story: %@", error.description);
                                                          } else {
                                                              if (result == FBWebDialogResultDialogNotCompleted) {
                                                                  // User canceled.
                                                                  NSLog(@"User cancelled.");
                                                              } else {
                                                                  // Handle the publish feed callback
                                                                  NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                                  
                                                                  if (![urlParams valueForKey:@"post_id"]) {
                                                                      // User canceled.
                                                                      NSLog(@"User cancelled.");
                                                                      
                                                                  } else {
                                                                      // User clicked the Share button
                                                                      NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                                      NSLog(@"result %@", result);
                                                                  }
                                                              }
                                                          }
                                                      }];
        }}
    if ([sharer.name isEqual:@"Twitter"]) {
        // 判斷社群網站的服務是否可用
        if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
            
            // 建立對應社群網站的ComposeViewController
            SLComposeViewController *mySocialComposeView = [[SLComposeViewController alloc] init];
            mySocialComposeView = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
            
            // 插入文字
            [mySocialComposeView setInitialText:[self.data valueForKey:@"name"]];
            
            // 插入網址
            // NSURL *myURL = [[NSURL alloc] initWithString:@"http://cg2010studio.wordpress.com/"];
            // [mySocialComposeView addURL: myURL];
            
            // 插入圖片
            
            NSString *picURLstring = [NSString stringWithFormat:@"https://localhost:443/phpMyAdmin/fyp_php/gallery_0%@_%d.jpg",[self.data valueForKey:@"master_id"],lastClickedRow+1] ;
            
            NSURL *picURL = [NSURL URLWithString:picURLstring] ;
            
            UIImage *Slide = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:picURL]];
            
            UIImage *myImage = Slide;
            [mySocialComposeView addImage:myImage];
            
            
            // 呼叫建立的SocialComposeView
            [self presentViewController:mySocialComposeView animated:YES completion:^{
                NSLog(@"成功呼叫 SocialComposeView");
            }];
            
            // 訊息成功送出與否的之後處理
            [mySocialComposeView setCompletionHandler:^(SLComposeViewControllerResult result){
                switch (result) {
                    case SLComposeViewControllerResultCancelled:
                        NSLog(@"取消送出");
                        break;
                    case SLComposeViewControllerResultDone:
                        NSLog(@"完成送出");
                        break;
                    default:
                        NSLog(@"其他例外");
                        break;
                }
            }];
        }
        else {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"提醒" message:@"請先在系統設定中登入推特帳號。" delegate:nil cancelButtonTitle:@"好" otherButtonTitles:nil, nil];
            [av show];
        }
        
    }
    if ([sharer.name isEqual:@"Whatsapp"]) {
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,     NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        
        NSString *getImagePath = [documentsDirectory stringByAppendingPathComponent:@"savedImage.png"]; //here i am fetched image path from document directory and convert it in to URL and use bellow
        
        
        NSURL *imageFileURL =[NSURL fileURLWithPath:getImagePath];
        NSLog(@"imag %@",imageFileURL);
        
        self.documentationInteractionController.delegate = self;
        self.documentationInteractionController.UTI = @"net.whatsapp.image";
        self.documentationInteractionController = [self setupControllerWithURL:imageFileURL usingDelegate:self];
        [self.documentationInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
        
        
    }
}

- (UIDocumentInteractionController *) setupControllerWithURL: (NSURL*) fileURL

                                               usingDelegate: (id ) interactionDelegate {
    
    
    
    self.documentationInteractionController =
    
    [UIDocumentInteractionController interactionControllerWithURL: fileURL];
    
    self.documentationInteractionController.delegate = interactionDelegate;
    
    
    
    return self.documentationInteractionController;
    
}- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}



@end
