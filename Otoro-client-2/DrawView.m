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

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}
@end