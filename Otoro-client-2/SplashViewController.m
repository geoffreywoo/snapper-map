//
//  SplashViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "SplashViewController.h"
#import "OtoroConnection.h"
#import "OtoroContentViewController.h"
#import "OAppDelegate.h"
#import "UAPush.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

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
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

-(IBAction) registerButton:(id) sender {
    NSLog(@"register");
    
    if (_registrationViewController == nil) {
        _registrationViewController = [[RegistrationViewController alloc] init];
    }
    
    [[self navigationController] pushViewController:_registrationViewController animated:YES];
}

-(IBAction) login:(id) sender {
    NSLog(@"login button hit");
    
    [[OtoroConnection sharedInstance] loginWithUsername:usernameField.text password:passwordField.text completionBlock:^(NSError *error, NSDictionary *returnData) {
        if (error) {
            NSLog(@"logged in response: %@",error);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                            message:error.domain
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
            
            usernameField.text = @"";
            passwordField.text = @"";
            [usernameField resignFirstResponder];
            
        } else {
            NSLog(@"logged in response: %@",returnData);
            OUser *me = [[OUser alloc]initWith:[returnData objectForKey:@"user"] ];
            [[OtoroConnection sharedInstance] setUser: me];
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject: [me username] forKey:@"username"];
            [defaults setObject: [me email] forKey:@"email"];
            [defaults setObject: [me phone] forKey:@"phone"];
            [defaults synchronize];

            [UAPush shared].alias = [me username];
            [[UAPush shared] updateRegistration];
            
            OtoroContentViewController *rootViewController = [[OtoroContentViewController alloc] init];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
            navigationController.navigationBarHidden = YES;
            
            OAppDelegate *delegate = (OAppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate.window.rootViewController = navigationController;
            [delegate.window makeKeyAndVisible];
        }
    }];
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
