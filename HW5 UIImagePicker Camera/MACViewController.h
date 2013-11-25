//
//  MACViewController.h
//  HW5 UIImagePicker Camera
//
//  Created by Macy Aviles on 11/6/13.
//  Copyright (c) 2013 Macy Aviles. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import <MessageUI/MessageUI.h>

@interface MACViewController : UIViewController <MFMailComposeViewControllerDelegate>


- (IBAction)postToTwitter:(id)sender;
- (IBAction)postToFacebook:(id)sender;
- (IBAction)showEmail:(id)sender;




@end
