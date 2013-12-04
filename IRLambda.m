//
//  IRLambda.m
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRLambda.h"

@implementation IRLambda
@synthesize parent_scope,scope,parameter_names,associated_code,body;

-(id)init
{
    self = [super init];
    self.parameter_names = [[NSMutableArray alloc] init];
    self.parent_scope = nil;
    self.associated_code = nil;
    self.body = nil;
    
    return self;
}


- (id)executeWithParameters:(NSArray *)parameters
{
    IRExpression *block = [[IRExpression alloc] init];
    //if parameter names is "nil", this means that the function can take as many variables as it wants
    
    return nil;
}


- (id)initWithBlock:(NSString *)block scope:(IRScope *)scope
{
    
    
    
    return nil;
    
}

@end
