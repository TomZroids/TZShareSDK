//
//  TZShareData.h
//
//  Created by by TomZRoid on 2018/1/5.
//

#ifndef TZShareData_h
#define TZShareData_h

#import <Foundation/Foundation.h>

@interface TZShareData : NSObject

@property(nonatomic) NSString* qqappid;

@property(nonatomic) NSString* wxappid;

+(instancetype)instance;
@end

#endif /* TZShareData_h */
