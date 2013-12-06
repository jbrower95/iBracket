//
//  IRPrimitiveLambda.h
//  iBracket
//
//  Created by Justin Brower on 12/5/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRLambda.h"


@interface IRPrimitiveLambda : IRLambda
{
    
    
    
}

//initializes the given IRLambda
- (id)initWithFunctionString:(NSString *)function parameters:(NSArray *)parameters;

- (IRLiteral *)execute;

+ (BOOL)isPrimitiveFunction:(NSString *)input;

@end
