//
//  SCFirstPageModel.h
//  TinyShoppingCenter
//
//  Created by 忘仙 on 2017/8/16.
//  Copyright © 2017年 ckys. All rights reserved.
//


//@interface CkInfo : RLMObject
//
//@property NSString *logopath;
//@property NSString *name;
//@property NSString *cershow;
//@property NSString *cerpath;
//@property NSString *wxshow;
//@property NSString *wxaccount;
//@property NSString *mobileshow;
//@property NSString *mobile;
//@property NSString *smallname;
//@property NSString *ckid; //3.0.8新增字段
//
//@end

@interface CkInfoModel : RLMObject

@property NSString *cerpath;
@property NSString *cershow;
@property NSString *wxshow;
@property NSString *mobile;
@property NSString *logopath;
@property NSString *smallname;
@property NSString *mobileshow;
@property NSString *wxaccount;
@property NSString *name;
@property NSString *ckid; //3.0.8新增字段

@end

@interface Bannerlist : RLMObject

@property NSString *path;
@property NSString *bannerId;
@property NSString *activityid;
@property NSString *link;
@property NSString *limitnum;
@property NSString *primaryKey;
@property NSString *htmlname;//3.0.8新增字段  商品详情页静态化页面名称

@end
RLM_ARRAY_TYPE(Bannerlist)


@interface Topiclist : RLMObject

@property NSString *path;
@property NSString *link;
@property NSString *topId;
@property NSString *activityid;
@property NSString *primaryKey;
@property NSString *htmlname;//3.0.8新增字段  商品详情页静态化页面名称


@end
RLM_ARRAY_TYPE(Topiclist)


@interface Categorylist : RLMObject

@property NSString *name;
@property NSString *categoryId;

@end
RLM_ARRAY_TYPE(Categorylist)


@interface Goodslist : RLMObject

@property NSString *imgpath;
@property NSString *goodsId;
@property NSString *path;
@property NSString *activityid;
@property NSString *primaryKey;
@property NSString *htmlname;//3.0.8新增字段  商品详情页静态化页面名称

@end
RLM_ARRAY_TYPE(Goodslist)


@interface SCFirstPageModel : RLMObject

@property CkInfoModel *ckInfoM;
@property RLMArray<Bannerlist*><Bannerlist> *bannerlistArray;
@property RLMArray<Topiclist*><Topiclist> *topiclistArray;
@property RLMArray<Categorylist*><Categorylist> *categorylistArray;
@property RLMArray<Goodslist*><Goodslist> *goodslistArray;
@property NSString *firstPageKey;
@property NSString *headerPic;
@property NSString *smallname;//3.0.8新增字段
@property NSString *headimg;//3.0.8新增字段 用户图像
@property NSString *meid;//3.0.8新增字段

@end

