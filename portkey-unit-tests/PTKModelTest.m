//
//  PTKModelTest.m
//  portkey
//
//  Created by Seth Samuel on 9/29/16.
//  Copyright © 2016 Airtime Media. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PTKModel.h"

@interface PTKModelTest : XCTestCase

@end

@implementation PTKModelTest

- (void)testInitWithJson {
    [self measureBlock:^{
        PTKModel *model = [[PTKModel alloc] initWithJSON:@{@"id": @"1"}];
        XCTAssertEqual(model.oid, @"1");
    }];
}

@end
