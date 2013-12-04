//
//  iBracketTests.m
//  iBracketTests
//
//  Created by Justin Brower on 12/4/13.
//  Copyright (c) 2013 Justin Brower. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "IRHelper.h"
@interface iBracketTests : XCTestCase

@end

@implementation iBracketTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testIRHelperValidateCode
{
    //      correct examples
    XCTAssert([IRHelper isParensValid:@"((this) now)"] == YES,@"Failed valid test");
    
    XCTAssert([IRHelper isParensValid:@"(this is (a compound) expression)"] == YES,@"Failed valid test");
    
    XCTAssert([IRHelper isParensValid:@"(((this is) much more) expensive)"] == YES,@"Failed valid test");
    
    //      incorrect examples
    XCTAssert([IRHelper isParensValid:@"(this is invalid))"] == NO, @"Failed invalid test.");

    XCTAssert([IRHelper isParensValid:@"(this is (an invalid( compound expression) invalid)"] == NO, @"Failed invalid test.");

    XCTAssert([IRHelper isParensValid:@"(more invalid(ness (()"] == NO, @"Failed invalid test.");
}

- (void)testIRHelperMatchingParen
{
    
    XCTAssert([IRHelper findMatchingParens:@"(short test)" startAt:0] == 11,@"Failed basic test");
    
    XCTAssert([@"(does this (help))" characterAtIndex:1] == 'd', @"Whoops.");
    
    XCTAssert([IRHelper findMatchingParens:@"(does this (help))" startAt:11] == 16,@"Failed nested test");
    
    
    XCTAssert([IRHelper findMatchingParens:@"(maybe (it doesn't) work)" startAt:7] == 18, @"Failed nested test.");
    
    XCTAssert([IRHelper findMatchingParens:@"(nested (expressions (are cool)))" startAt:8] == 31, @"Failed double nested test.");
    
    XCTAssert([IRHelper findMatchingParens:@"(maybe (this will) fail" startAt:0] == -1, @"Failed invalid test.");
    
    XCTAssert([IRHelper findMatchingParens:@"(this is(a long) (test) for (racket ))" startAt:0] == 37,@"Failed compound test");
    
}

- (void)testIRHelperExplode
{
   
    XCTAssert(([[IRHelper explodeByParts:@"(test)"] isEqualToArray:[NSMutableArray arrayWithObjects:@"test",nil]] == YES), @"Failed valid test" );
    
    XCTAssert(([[IRHelper explodeByParts:@"(if (> 5 4) true false)"] isEqualToArray:[NSMutableArray arrayWithObjects:@"if",[NSMutableArray arrayWithObjects:@">",@"5",@"4",nil],@"true",@"false",nil]] == YES), @"Failed valid test" );
    
    XCTAssert(([[IRHelper explodeByParts:@"(if (= (+ 3 2) 5) true false)"] isEqualToArray:[NSMutableArray arrayWithObjects:@"if",[NSMutableArray arrayWithObjects:@"=",[NSMutableArray arrayWithObjects:@"+",@"3",@"2",nil],@"5",nil],@"true",@"false",nil]] == YES), @"Failed valid test" );
    
    XCTAssert(([[IRHelper explodeByParts:@"(let ((x 15) (y 20)) (+ x y))"] isEqualToArray:[NSMutableArray arrayWithObjects:@"let",
                                                                                                                           [NSMutableArray arrayWithObjects:[NSMutableArray arrayWithObjects:@"x",@"15",nil],
                                                                                                          [NSMutableArray arrayWithObjects:@"y",@"20",nil],
                                                                                                          nil],
                                                                                           [NSMutableArray arrayWithObjects:@"+",@"x",@"y",nil],nil]])
                                                                                           , @"Failed valid test");
    
    XCTAssert(([[IRHelper explodeByParts:@"(test)"] isEqualToArray:[NSMutableArray arrayWithObjects:@"test",nil]] == YES), @"Failed valid test" );
    
}


@end
