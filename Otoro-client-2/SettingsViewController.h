//
//  SettingsViewController.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController {
    IBOutlet UIButton *logoutButton;
    IBOutlet UIButton *backButton;
}

-(IBAction) logout:(id) sender;
-(IBAction) back:(id) sender;

@end