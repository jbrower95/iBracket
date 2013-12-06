//
//  IRScope.m
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRScope.h"

@implementation IRScope
@synthesize definitions,expressions,children,parent;

- (id)initWithParent:(IRScope *)aParent
{
    self = [super init];
    
    
    self.definitions = [[NSMutableDictionary alloc] init];
    self.expressions = [[NSMutableArray alloc] init];
    
    if(aParent == nil)
    {
        [self loadPrimitives];
    }
    else{
        self.parent = aParent;
    }
    
    return self;
}


-(void)loadPrimitives
{
    /*
    NSArray *prims = [[NSArray alloc] initWithObjects:[[^(int firstValue, int secondValue) {return firstValue * secondValue;} copy] autorelease],[[^(int firstValue, int secondValue) {return firstValue + secondValue;} copy] autorelease],[[^(int firstValue, int secondValue) {return (firstValue - secondValue);} copy] autorelease],[[^(int firstValue, int secondValue) {return firstValue / secondValue;} copy] autorelease],[[^(int firstValue, int secondValue) {return firstValue < secondValue;} copy] autorelease],[[^(int firstValue, int secondValue) {return firstValue > secondValue;} copy] autorelease],[[^(int firstValue, int secondValue) {return firstValue >= secondValue;} copy] autorelease],[[^(int firstValue, int secondValue) {return firstValue <= secondValue;} copy] autorelease],[[^(int firstValue, int secondValue) {return firstValue % secondValue;} copy] autorelease],[[^(double firstValue, double secondValue) {return pow(firstValue,secondValue);} copy] autorelease],
             [[^(int firstValue) {return log10(firstValue);} copy] autorelease],
             [[^(int firstValue) {return log(firstValue);} copy] autorelease],
             [[^(int firstValue, int secondValue){return (firstValue == secondValue);} copy] autorelease],
             [[^(int firstValue, int secondValue){return ((secondValue > firstValue) ? secondValue : firstValue);} copy] autorelease],
             [[^(int firstValue, int secondValue){return ((secondValue < firstValue) ? secondValue : firstValue);} copy] autorelease],
             [[^(int firstValue){return pow(firstValue, 2);} copy] autorelease],
             [[^(int firstValue){return sqrt(firstValue);} copy] autorelease],nil];
    
    NSArray *identifiers = [NSArray arrayWithObjects:@"*",@"+",@"-",@"/",@"<",@">",@">=",@"<=",@"%",@"expt",@"log",@"ln",@"=",@"max",@"min",@"sqr",@"sqrt",nil];
    
    IRLambda *times = [[IRLambda alloc] init];
    IRExpression *body = [[IRExpression alloc] init];
    [body setParameters:[NSArray arrayWithObjects:@"a",@"b"]];
     
    [times setParameterNames:[NSArray arrayWithObjects:@"a",@"b",nil]];
    
    [times setBody:body];
    
    
    NSArray *prim = [NSArray arrayWithObjects:
                     
                     
                     
                     
                     
                     
                     
                     
                     
                     nil];
    
    
    for (id b in prims)
    {
        
        
        
        
        
        
    }
    */
    
    //[[self.scope definitions] addObject:_prim_product];
    
    
}
     
//takes an identifier string and returns an associated variable
- (id)variableLookup:(NSString *)identifier
{
    printf("Scope -------- Looking up symbol '%s'\n",[identifier UTF8String]);
    //check the current namespace
    if ([[definitions allKeys] containsObject:identifier])
    {
        // this identifier is in the current namespace! return the value
        return [definitions objectForKey:identifier];
        
    }
    else
    {
        // it's not in the current namespace.
        // do we have a parent?
        if ( self.parent != nil)
        {
            //we have a parent ! :)
            return [self.parent variableLookup:identifier];
            
        }
        else
        {
            //we've reached the top of the tree: unfortunately, this variable does not exist for allowed scopes.
            return nil;
            
        }
        
    }
   
}

@end
