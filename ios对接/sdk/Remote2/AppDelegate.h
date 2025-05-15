//
//  AppDelegate.h
//  Remote2
//
//  Created by rrrr on 2024/3/26.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic ,strong)UIWindow * window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

