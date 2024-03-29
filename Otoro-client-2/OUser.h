//
//  Friend.h
//  Otoro-client-2
//
//  Created by Geoffrey Woo on 8/17/13.
//  Copyright (c) 2013 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OUser : NSObject

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic) Boolean preferred;
@property (nonatomic) Boolean selected;
@property (nonatomic) Boolean blocked;

- (id)initWithUsername:(NSString *)username;
- (id)initWith:(NSDictionary *)dict;
- (id)initFromNSDefaults;

- (void) debugPrint;
- (BOOL)isEqual:(id)object;

@end
