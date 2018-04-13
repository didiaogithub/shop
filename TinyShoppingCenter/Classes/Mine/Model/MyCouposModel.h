//
//  MyTeamListModel.h
//  CKYSPlatform
//
//  Created by 庞宏侠 on 16/12/2.
//  Copyright © 2016年 ckys. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCouposModel : NSObject

@property(nonatomic, assign)BOOL  isOpen;
/**顾客id */
@property(nonatomic,copy)NSString *ID;
/**姓名 */
@property(nonatomic,copy)NSString *name;
/** 姓名*/
@property(nonatomic,copy)NSString *realname;
/** 微信昵称*/
@property(nonatomic,copy)NSString *smallname;


/*开店时间 */
@property(nonatomic,copy)NSString *jointime;


/**金额*/
@property(nonatomic,copy)NSString *money;

/**时间*/
@property(nonatomic,copy)NSString *time;


@end
