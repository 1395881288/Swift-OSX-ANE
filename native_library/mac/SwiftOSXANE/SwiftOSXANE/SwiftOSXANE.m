//
// Created by User on 04/12/2016.
// Copyright (c) 2017 Tua Rua Ltd. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "FreMacros.h"
#include "SwiftOSXANE_oc.h"

#import "SwiftOSXANE-Swift.h"
#include <Adobe AIR/Adobe AIR.h>

SWIFT_DECL(TRSOA) // use unique prefix throughout to prevent clashes with other ANEs

CONTEXT_INIT(TRSOA) {
    SWIFT_INITS(TRSOA)
    
    /**************************************************************************/
    /******* MAKE SURE TO ADD FUNCTIONS HERE THE SAME AS SWIFT CONTROLLER *****/
    /**************************************************************************/
    static FRENamedFunction extensionFunctions[] =
    {
         MAP_FUNCTION(TRSOA, runStringTests)
        ,MAP_FUNCTION(TRSOA, runNumberTests)
        ,MAP_FUNCTION(TRSOA, runIntTests)
        ,MAP_FUNCTION(TRSOA, runArrayTests)
        ,MAP_FUNCTION(TRSOA, runObjectTests)
        ,MAP_FUNCTION(TRSOA, runBitmapTests)
        ,MAP_FUNCTION(TRSOA, runByteArrayTests)
        ,MAP_FUNCTION(TRSOA, runErrorTests)
        ,MAP_FUNCTION(TRSOA, runErrorTests2)
        ,MAP_FUNCTION(TRSOA, runDataTests)
    };
    /**************************************************************************/
    /**************************************************************************/
    
    SET_FUNCTIONS
    
}

CONTEXT_FIN(TRSOA) {
    //any clean up code here
}
EXTENSION_INIT(TRSOA)
EXTENSION_FIN(TRSOA)
