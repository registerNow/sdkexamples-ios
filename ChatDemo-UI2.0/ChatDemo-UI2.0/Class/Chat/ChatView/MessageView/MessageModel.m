/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import "MessageModel.h"

@implementation MessageModel

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _observerKeys = [NSMutableDictionary dictionary];
    }
    
    return self;
}

- (void)dealloc{
    
}

- (void)finalize
{
    [super finalize];
    
    [self clearObservers];
}

#pragma mark - setter

- (void)setIsPlaying:(BOOL)isPlaying
{
    if (_isPlaying != isPlaying) {
        _isPlaying = isPlaying;
        if (self.type == eMessageBodyType_Voice && [self observeKeyPath:@"isPlaying"]) {
            [self setValue:[NSNumber numberWithInteger:isPlaying] forKeyPath:@"isPlaying"];
        }
    }
}

- (void)setIsPlayed:(BOOL)isPlayed
{
    if (_isPlayed != isPlayed) {
        _isPlayed = isPlayed;
        if (self.type == eMessageBodyType_Voice && [self observeKeyPath:@"isPlayed"]) {
            [self setValue:[NSNumber numberWithInteger:isPlayed] forKeyPath:@"isPlayed"];
        }
    }
}

#pragma mark - public

- (BOOL)observeKeyPath:(NSString *)keyPath
{
    if (keyPath && keyPath.length > 0) {
        NSMutableArray *observers = [_observerKeys objectForKey:keyPath];
        
        return (observers && [observers count] > 0) ? YES : NO;
    }
    
    return NO;
}

- (void)addObserver:(NSObject *)object keyPath:(NSString *)keyPath
{
    if (object && keyPath && keyPath.length > 0) {
        NSMutableArray *observers = [_observerKeys objectForKey:keyPath];
        if (observers == nil) {
            observers = [NSMutableArray array];
        }
        if (![observers containsObject:object]) {
            [observers addObject:object];
            [_observerKeys setObject:observers forKey:keyPath];
            
            [self addObserver:object forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
        }
    }
}

- (void)removeObserver:(NSObject *)object keyPath:(NSString *)keyPath
{
    if (object && keyPath && keyPath.length > 0) {
        NSMutableArray *observers = [_observerKeys objectForKey:keyPath];
        if (observers != nil) {
            if ([observers containsObject:object]) {
                [observers removeObject:object];
                [_observerKeys setObject:observers forKey:keyPath];
                
                [self removeObserver:object forKeyPath:keyPath context:NULL];
            }
        }
    }
}

- (void)clearObservers
{
    if ([_observerKeys count] > 0) {
        for (NSString *keyPath in _observerKeys) {
            NSMutableArray *observers = [_observerKeys objectForKey:keyPath];
            if (observers && [observers count] > 0) {
                for (NSObject *object in observers) {
                    [self removeObserver:object forKeyPath:keyPath context:NULL];
                }
            }
        }
        
        [_observerKeys removeAllObjects];
    }
}

@end