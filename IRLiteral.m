//
//  IRLiteral.m
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import "IRLiteral.h"

@implementation IRLiteral
@synthesize numberValue,stringValue,boolValue;

-(id)init
{
    self = [super init];
    
    
    //no extra setup required yet.
    return self;
}

// used to assign different values to the literal
- (void)assignString:(NSString *)input
{
    [self flush];
    stringValue = [[NSString alloc] initWithString:input];
}
- (void)assignNumber:(NSString *)input
{
    [self flush];
    
    if ( [input rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"."]].location == NSNotFound)
    {
        //integer arithmetic
        precision = IRPrecisionInteger;
        numberValue = [[NSNumber alloc] initWithInt:[input intValue]];
        
    }
    else{
        //float arithmetic
        precision = IRPrecisionFloat;
        numberValue = [[NSNumber alloc] initWithFloat:[input floatValue]];
        
    }
    printf("Assigned number: float = %s\n",(precision == IRPrecisionFloat) ? "yes" : "no");
    
    
}

- (IRLiteralType)type
{
    if (numberValue)
    {
        return IRLiteralNumber;
    }
    if (boolValue)
    {
        return IRLiteralBool;
    }
    if (stringValue)
    {
        return IRLiteralString;
    }
    
    @throw [NSException exceptionWithName:@"NSUnknownTypeException" reason:@"Error: Unknown IRLiteralType" userInfo:nil];
}

- (void)assignBool:(BOOL)input
{
    [self flush];
    boolValue = ((input == YES) ? [[NSNumber alloc] initWithInt:0] : [[NSNumber alloc] initWithInt:1]);
}

- (BOOL)getBool
{
        return ([boolValue intValue] == 0);
}

- (void)flush
{
    if ( stringValue != nil)
    {
        // deallocate the stringValue
        [stringValue release];
        stringValue = nil;
    }
    if (boolValue != nil)
    {
        [boolValue release];
        boolValue = nil;
    }
    if ( numberValue )
    {
        // if there was a previous number, release it
        [numberValue release];
        numberValue = nil;
        
    }
}


- (void)printToHandle:(NSFileHandle *)handle
{
    NSData *output;
    
    if ( stringValue != nil)
    {
        output = [stringValue dataUsingEncoding:NSUTF8StringEncoding];
   
    }
    if ( numberValue != nil)
    {
        NSNumberFormatter *x = [[NSNumberFormatter alloc] init];
        [x setNumberStyle:NSNumberFormatterNoStyle];
        [x setMaximumFractionDigits:50];
        NSString *representation = [numberValue stringValue];
        
        output = [representation dataUsingEncoding:NSUTF8StringEncoding];
        
    }
    if ( boolValue != nil)
    {
        //we have a bool
        output = [[NSData alloc] initWithData:(([boolValue intValue] == 0) ? [@"true" dataUsingEncoding:NSUTF8StringEncoding] : [@"false" dataUsingEncoding:NSUTF8StringEncoding])];
        
    }
    // write data to 
    [handle writeData:output];
    [handle writeData:[@"\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
}



@end
