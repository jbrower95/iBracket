//
//  IRPrimitiveLambda.m
//  iBracket
//
//  Created by Justin Brower on 12/5/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRPrimitiveLambda.h"

//defines a primitive lambda type
@implementation IRPrimitiveLambda


- (id)initWithFunctionString:(NSString *)function parameters:(NSArray *)parameters
{
    
    NSArray *identifiers = [NSArray arrayWithObjects:@"*",@"+",@"-",@"/",@"<",@">",@">=",@"<=",@"%",@"expt",@"log",@"ln",@"=",@"max",@"min",@"sqr",@"sqrt",nil];

    if ( [IRPrimitiveLambda isPrimitiveFunction:function] )
    {
        //this function is acceptable
        
        
        
    }

}

+ (BOOL)isPrimitiveFunction:(NSString *)input
{
    return [[NSArray arrayWithObjects:@"*",@"+",@"-",@"/",@"<",@">",@">=",@"<=",@"%",@"expt",@"log",@"ln",@"=",@"max",@"min",@"sqr",@"sqrt",nil] containsObject:input];
}


@end
