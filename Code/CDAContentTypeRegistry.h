//
//  CDAContentTypeRegistry.h
//  ContentfulSDK
//
//  Created by Boris Bügling on 04/03/14.
//
//

#import <Foundation/Foundation.h>

@class CDAContentType;

@interface CDAContentTypeRegistry : NSObject

@property (nonatomic, readonly) BOOL fetched;

-(void)addContentType:(CDAContentType*)contentType;
-(CDAContentType*)contentTypeForIdentifier:(NSString*)identifier;
-(Class)customClassForContentType:(CDAContentType*)contentType;
-(void)registerClass:(Class)customClass forContentType:(CDAContentType*)contentType;
-(void)registerClass:(Class)customClass forContentTypeWithIdentifier:(NSString*)identifier;

@end
