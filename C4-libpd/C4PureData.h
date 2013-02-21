//
//  C4PureData.h
//  C4-libpd
//
//  Created by Adam Tindale on 2013-02-20.
//  Copyright (c) 2013 Adam Tindale. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PdAudioController.h"
#import "PdDispatcher.h"

@interface C4PureData : NSObject{
    PdDispatcher * dispatcher;
    void * thepatch;
}
-(C4PureData *) init;

-(C4PureData *) initWithPatch: (NSString *) patch;
-(void) openPatch: (NSString *) patch;

-(void) stop;
-(void) start;

@property (strong, nonatomic, readonly) PdAudioController * audioController;
//@property (strong, nonatomic, readonly) PdDispatcher * dispatcher;
@end
