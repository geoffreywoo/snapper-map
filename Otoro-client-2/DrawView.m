//
//  DrawView.m
//  snappermap
//
//  Created by Geoffrey Woo on 2/8/14.
//  Copyright (c) 2014 Serrice Corp. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView
{
    UIBezierPath *path; // (3)
    
    NSMutableArray *pathsArray;
    NSMutableArray *currentPath;
    
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
}

- (id)initWithCoder:(NSCoder *)aDecoder // (1)
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self setMultipleTouchEnabled:NO]; // (2)
        path = [UIBezierPath bezierPath];
        [path setLineWidth:2.0];
        pathsArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)drawRect:(CGRect)rect // (5)
{
    [[UIColor blackColor] setStroke];
    [path stroke];
}

- (void)clear
{
    path = [UIBezierPath bezierPath];
    [path setLineWidth:2.0];
    pathsArray = [[NSMutableArray alloc] init];
    [self setNeedsDisplay];
}

- (void)clearLast
{
    path = [UIBezierPath bezierPath];
    [path setLineWidth:2.0];
    [pathsArray removeLastObject];
    
    for (int i = 0; i < [pathsArray count]; i++) {
        [path moveToPoint:[pathsArray[i][0] CGPointValue]];
        for (int j = 1; j < [pathsArray[i] count]; j++) {
            [path addLineToPoint:[pathsArray[i][j] CGPointValue]];
        }
    }
    
    [self setNeedsDisplay];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch began");

    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path moveToPoint:p];
    
    currentPath = [[NSMutableArray alloc] init];
    [currentPath addObject:[NSValue valueWithCGPoint:p]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    [path addLineToPoint:p]; // (4)
    [self setNeedsDisplay];
    [currentPath addObject:[NSValue valueWithCGPoint:p]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesMoved:touches withEvent:event];
    [pathsArray addObject:[[NSArray alloc] initWithArray:currentPath]];
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"touch began");
    ctr = 0;
    UITouch *touch = [touches anyObject];
    pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    ctr++;
    pts[ctr] = p;
    if (ctr == 4)
    {
        pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0); // move the endpoint to the middle of the line joining the second control point of the first Bezier segment and the first control point of the second Bezier segment
        
        [path moveToPoint:pts[0]];
        [path addCurveToPoint:pts[3] controlPoint1:pts[1] controlPoint2:pts[2]]; // add a cubic Bezier from pt[0] to pt[3], with control points pt[1] and pt[2]
        
        [self setNeedsDisplay];
        // replace points and get ready to handle the next segment
        pts[0] = pts[3];
        pts[1] = pts[4];
        ctr = 1;
    }
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    [self drawBitmap];
    [self setNeedsDisplay];
 //   [path removeAllPoints];
    ctr = 0;
}
 */
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
@end