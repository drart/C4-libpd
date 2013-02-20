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
    PdDispatcher *dispatcher;
    void *patch;
}
-(BOOL) initPD;
-(BOOL) addPatch;
-(void) stopPD;
-(void) startPD;
@property (strong, nonatomic, readonly) PdAudioController *audioController;
@end
