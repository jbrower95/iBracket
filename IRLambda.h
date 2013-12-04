//
//  IRLambda.h
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IRScope.h"
#import "IRExpression.h"
/*
 
 Represents a function. A function is either a primitive function, or composition of primitive functions.
 
 A function has a scope. A scope can either be a parent function (if this is a nested function), or the general scope.
 
 
 */
@interface IRLambda : NSObject
{
    IRScope *parent_scope;
    //this scope represents the scope of the surrounding block
    
    NSMutableArray *parameter_names;
    //stores the names of the parameters in the order they are received
    
    NSString *associated_code;
    //stores the code that this lambda was declared in
    
    IRExpression *body;
    // represents the body of the function
    
    IRScope *scope;
    // the function's scope
    
}
@property (nonatomic, retain) IRScope *parent_scope;
@property (nonatomic, retain) IRScope *scope;
@property (nonatomic, retain) NSMutableArray *parameter_names;
@property (nonatomic, retain) NSString *associated_code;
@property (nonatomic, retain) IRExpression *body;

- (id)initWithBlock:(NSString *)block scope:(IRScope *)scope;

@end
