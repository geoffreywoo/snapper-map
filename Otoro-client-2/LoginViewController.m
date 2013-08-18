//
//  LoginViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "LoginViewController.h"
#import "OtoroConnection.h"
#import "OtoroContentViewController.h"
#import "OAppDelegate.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    [usernameField becomeFirstResponder];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(IBAction) login:(id) sender {
    NSLog(@"login button hit");

    [[OtoroConnection sharedInstance] loginWithUsername:usernameField.text password:passwordField.text completionBlock:^(NSError *error, NSDictionary *returnData) {
        if (error) {
            NSLog(@"logged in response: %@",error);
        } else {
            NSLog(@"logged in response: %@",returnData);
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: nil forKey:@"username"];
            [defaults synchronize];
        }
    }];
    OtoroContentViewController *otoroViewController = [[OtoroContentViewController alloc] init];
    OAppDelegate *delegate = (OAppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.window.rootViewController = otoroViewController;
    [delegate.window makeKeyAndVisible];
}

-(IBAction) back:(id) sender {
    [self.view removeFromSuperview];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    NSLog(@"touches began");
    [usernameField resignFirstResponder];
    [passwordField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == usernameField) {
        NSLog(@"text field 1");
        [passwordField becomeFirstResponder];
    } else {
        NSLog(@"text field 2");
        [textField resignFirstResponder];
        [self login:textField];
    }
            
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
