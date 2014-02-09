//
//  ToroViewController.m
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/4/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import "ToroViewController.h"
#import "Toro.h"
#import "SnapperMapAnnotation.h"
#import "SnapperMapAnnotationView.h"

@implementation ToroViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithToro:(Toro *)toro
{
    self = [super initWithNibName: @"ToroViewController" bundle: nil];
    if (self) {
        _toro = toro;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _location.latitude  = [[self toro] lat];
    _location.longitude = [[self toro] lng];
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(_location.latitude,_location.longitude);
    SnapperMapAnnotation *pin = [[SnapperMapAnnotation alloc] initWithTitle:[_toro sender] andCoordinate:coord];

    [mapView addAnnotation:pin];
    
    [self.view sendSubviewToBack:mapView];
    [[self countDown] setText:[NSString stringWithFormat:@"%d",[[self toro] maxTime]]];
   
    if (![[_toro message] isEqualToString:@""])
        [_message setText:[NSString stringWithFormat:@"%@",[_toro message]]];
    else
        _message.hidden = YES;
    
    NSMutableString *headerStr = [NSMutableString stringWithString:[_toro created_string]];
    if ([_toro venue] && ([[_toro venue].name isKindOfClass:[NSString class]])) {
        if (![[_toro venue].name isEqualToString:@""]) {
            [headerStr appendString:[NSString stringWithFormat:@" at %@",[_toro venue].name]];
        }
    }
    [_venue setText:headerStr];
    [self centerMapOnSnapperLocation];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self centerMapOnSnapperLocation];
}

-(void)centerMapOnSnapperLocation
{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    _location.latitude  = [[self toro] lat];
    _location.longitude = [[self toro] lng];
    
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    region.span = span;
    region.center = _location;
    
    [mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id < MKAnnotation >)annotation
{
    if ([annotation isKindOfClass:[SnapperMapAnnotation class]]) {
        NSString *annotationIdentifier = @"SnapperMapAnnotationView";
		SnapperMapAnnotationView *annotationView = (SnapperMapAnnotationView *)[map dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
		if (annotationView == nil) {
		    annotationView = [[SnapperMapAnnotationView alloc] initWithAnnotation:annotation  reuseIdentifier:@"SnapperMapAnnotationView"];
		}
        annotationView.annotation = annotation;
        return annotationView;
	}
    return nil;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    // Pass to top of chain
    NSLog(@"touches began");
    UIResponder *responder = self;
    while (responder.nextResponder != nil){
        responder = responder.nextResponder;
        if ([responder isKindOfClass:[UIViewController class]]) {
            // Got ViewController
            break;
        }
    }
    [responder touchesBegan:touches withEvent:event];
}

@end
