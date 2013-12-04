//
//  IRLiteral.h
//  iRacket
//
//  Created by Justin Brower on 10/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <Foundation/Foundation.h>


//allows us to pass around "values" in racket. A blanket object that houses a lot of data.

typedef enum {IRPrecisionFloat, IRPrecisionInteger} IRPrecisionType;

typedef enum {IRLiteralNumber, IRLiteralString, IRLiteralBool} IRLiteralType;

@interface IRLiteral : NSObject
{
    NSNumber *numberValue;
    NSString *stringValue;
    NSNumber *boolValue;
    IRPrecisionType precision;
    
    
}
@property (nonatomic, assign) IRPrecisionType precision;
@property (nonatomic, retain) NSNumber *numberValue;
@property (nonatomic, retain) NSString *stringValue;
@property (nonatomic, assign) NSNumber *boolValue;

// used to assign different values to the literal
- (void)assignString:(NSString *)input;
- (void)assignNumber:(NSString *)input;
- (void)assignBool:(BOOL)input;

- (BOOL)getBool;
- (IRLiteralType)type;
// used to print the value of an IRLiteral
- (void)printToHandle:(NSFileHandle *)handle;


@end
