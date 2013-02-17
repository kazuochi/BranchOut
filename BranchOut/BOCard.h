//
//  BOCard.h
//  BranchOut
//
//  Created by Kazuhito Ochiai on 2/15/13.
//  Copyright (c) 2013 Kazuhito Ochiai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BOCard : NSObject
@property (retain, nonatomic) NSString* id;
@property (retain, nonatomic) NSString* name;
@property (readonly, nonatomic) NSInteger score;
@property (nonatomic) BOOL displayedOnce; 

-(id)init;
-(id)initWithId:(NSString *)id andName:(NSString *)name;
-(void)addScore:(NSInteger)value;
-(void)resetScore;

@end
