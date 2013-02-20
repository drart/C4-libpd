//
//  C4WorkSpace.m
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import "C4WorkSpace.h"
#import "C4PureData.h"

@implementation C4WorkSpace

-(void)setup {
    C4PureData *pd = [C4PureData alloc];
    pd.initPD;
    pd.addPatch;
    [pd startPD];
}


@end
