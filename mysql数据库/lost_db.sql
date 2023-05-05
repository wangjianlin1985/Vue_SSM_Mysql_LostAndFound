/*
 Navicat Premium Data Transfer

 Source Server         : mysql5.6
 Source Server Type    : MySQL
 Source Server Version : 50620
 Source Host           : localhost:3306
 Source Schema         : lost_db

 Target Server Type    : MySQL
 Target Server Version : 50620
 File Encoding         : 65001

 Date: 21/03/2021 12:33:45
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for admin
-- ----------------------------
DROP TABLE IF EXISTS `admin`;
CREATE TABLE `admin`  (
  `username` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '',
  `password` varchar(32) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`username`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of admin
-- ----------------------------
INSERT INTO `admin` VALUES ('a', 'a');

-- ----------------------------
-- Table structure for t_area
-- ----------------------------
DROP TABLE IF EXISTS `t_area`;
CREATE TABLE `t_area`  (
  `areaId` int(11) NOT NULL AUTO_INCREMENT COMMENT '学院id',
  `areaName` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '学院名称',
  PRIMARY KEY (`areaId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_area
-- ----------------------------
INSERT INTO `t_area` VALUES (1, '信息工程学院');
INSERT INTO `t_area` VALUES (2, '外国语学院');
INSERT INTO `t_area` VALUES (3, '地球物理学院');

-- ----------------------------
-- Table structure for t_claim
-- ----------------------------
DROP TABLE IF EXISTS `t_claim`;
CREATE TABLE `t_claim`  (
  `claimId` int(11) NOT NULL AUTO_INCREMENT COMMENT '认领id',
  `lostFoundObj` int(11) NOT NULL COMMENT '招领信息',
  `personName` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '认领人',
  `claimTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '认领时间',
  `contents` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '描述说明',
  `addTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`claimId`) USING BTREE,
  INDEX `lostFoundObj`(`lostFoundObj`) USING BTREE,
  CONSTRAINT `t_claim_ibfk_1` FOREIGN KEY (`lostFoundObj`) REFERENCES `t_lostfound` (`lostFoundId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_claim
-- ----------------------------
INSERT INTO `t_claim` VALUES (1, 1, '黄霞同学', '2021-03-20 15:28:07', '<p>经过失主确认，就是黄同学的u盘，里面还有她的照片为证，已取回</p>', '2021-03-20 15:42:11');
INSERT INTO `t_claim` VALUES (2, 2, '汪同学', '2021-03-21 12:17:33', '<p>经过失主确认，已经物归原主，也给了一点相应的报酬！</p>', '2021-03-21 12:42:11');
INSERT INTO `t_claim` VALUES (3, 3, '李小双同学', '2021-03-21 12:28:24', '<p>已经物归原主！</p>', '2021-03-21 12:47:11');

-- ----------------------------
-- Table structure for t_lookingfor
-- ----------------------------
DROP TABLE IF EXISTS `t_lookingfor`;
CREATE TABLE `t_lookingfor`  (
  `lookingForId` int(11) NOT NULL AUTO_INCREMENT COMMENT '寻物id',
  `title` varchar(30) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标题',
  `goodsName` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '丢失物品',
  `goodsPhoto` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '物品照片',
  `lostTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '丢失时间',
  `lostPlace` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '丢失地点',
  `goodDesc` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '物品描述',
  `reward` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '报酬',
  `telephone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系电话',
  `userObj` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发布人',
  `addTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`lookingForId`) USING BTREE,
  INDEX `userObj`(`userObj`) USING BTREE,
  CONSTRAINT `t_lookingfor_ibfk_1` FOREIGN KEY (`userObj`) REFERENCES `t_userinfo` (`user_name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 6 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_lookingfor
-- ----------------------------
INSERT INTO `t_lookingfor` VALUES (1, '我手机掉了', '苹果12', 'upload/0ca2ab34-2332-422d-89ba-f171ddec91e9.jpg', '2021-03-20 15:26:43', '学校门口', '<p>&nbsp; &nbsp; &nbsp; 我省吃俭用新买的手机，刚用不到几天，不小心掉了，哪位好心人捡到了？我省吃俭用新买的手机，刚用不到几天，不小心掉了，哪位好心人捡到了？我省吃俭用新买的手机，刚用不到几天，不小心掉了，哪位好心人捡到了？我省吃俭用新买的手机，刚用不到几天，不小心掉了，哪位好心人捡到了？我省吃俭用新买的手机，刚用不到几天，不小心掉了，哪位好心人捡到了？我省吃俭用新买的手机，刚用不到几天，不小心掉了，哪位好心人捡到了？<br/><img src=\"/JavaWebProject/upload/20210321/1616298090592079129.jpg\" title=\"1616298090592079129.jpg\" alt=\"2.jpg\"/></p><p><br/><br/></p>', '100元', '13058019342', '18888888888', '2021-03-20 14:11:15');
INSERT INTO `t_lookingfor` VALUES (3, '我家的小泰迪不见了', '宠物狗', 'upload/e7cabb9a-06bd-405d-b798-8ed8882bd270.jpg', '2021-03-18 00:00:00', '宿舍楼外', '<p>&nbsp; 今天早上我带我的宠物小泰迪去公寓外面的花园玩的时候，绳子不小心断了，然后它就跑掉了，谁看见了？&nbsp; 今天早上我带我的宠物小泰迪去公寓外面的花园玩的时候，绳子不小心断了，然后它就跑掉了，谁看见了？&nbsp; 今天早上我带我的宠物小泰迪去公寓外面的花园玩的时候，绳子不小心断了，然后它就跑掉了，谁看见了？</p>', '80元', '13058019832', '18888888888', '2021-03-21 01:14:43');
INSERT INTO `t_lookingfor` VALUES (4, '我的250G移动硬盘不见了', '移动硬盘', 'upload/4f1db827-35af-4383-9481-fda1407233fe.jpg', '2021-03-21 00:00:00', '计算机教室', '<p>今天我们班上计算机课的时候，忘记带走了，咋办啊？今天我们班上计算机课的时候，忘记带走了，咋办啊？今天我们班上计算机课的时候，忘记带走了，咋办啊？今天我们班上计算机课的时候，忘记带走了，咋办啊？今天我们班上计算机课的时候，忘记带走了，咋办啊？今天我们班上计算机课的时候，忘记带走了，咋办啊？</p>', '30元', '13058019342', '13649023423', '2021-03-21 01:22:33');
INSERT INTO `t_lookingfor` VALUES (5, '我的u盘掉了谁捡到了啊', '金士顿u盘', 'upload/e4fb4ad1-77c2-4c92-b6b2-d997058d0ff8.jpg', '2021-03-21 00:00:00', '6A-203教室', '<p>我新买的金士顿u盘，随时不是很值钱，不过里面有我保存的很重要的课件资料，麻烦好心人给我吧！我新买的金士顿u盘，随时不是很值钱，不过里面有我保存的很重要的课件资料，麻烦好心人给我吧！我新买的金士顿u盘，随时不是很值钱，不过里面有我保存的很重要的课件资料，麻烦好心人给我吧！我新买的金士顿u盘，随时不是很值钱，不过里面有我保存的很重要的课件资料，麻烦好心人给我吧！我新买的金士顿u盘，随时不是很值钱，不过里面有我保存的很重要的课件资料，麻烦好心人给我吧！我新买的金士顿u盘，随时不是很值钱，不过里面有我保存的很重要的课件资料，麻烦好心人给我吧！</p>', '20元', '13058080392', '18888888886', '2021-03-21 01:22:35');

-- ----------------------------
-- Table structure for t_lostfound
-- ----------------------------
DROP TABLE IF EXISTS `t_lostfound`;
CREATE TABLE `t_lostfound`  (
  `lostFoundId` int(11) NOT NULL AUTO_INCREMENT COMMENT '招领id',
  `title` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标题',
  `goodsName` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '物品名称',
  `pickUpTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '捡得时间',
  `pickUpPlace` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '拾得地点',
  `contents` varchar(5000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '描述说明',
  `connectPerson` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系人',
  `phone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系电话',
  `userObj` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '发布人',
  `addTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`lostFoundId`) USING BTREE,
  INDEX `userObj`(`userObj`) USING BTREE,
  CONSTRAINT `t_lostfound_ibfk_1` FOREIGN KEY (`userObj`) REFERENCES `t_userinfo` (`user_name`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_lostfound
-- ----------------------------
INSERT INTO `t_lostfound` VALUES (1, '捡到一个u盘', '金士顿u盘', '2021-03-20 15:27:28', '6教学楼', '<p>今天我去上自习的时候，看见教室的课桌上面有个u盘，谁掉了，来找我！</p>', '汪同学', '13508831234', '18888888888', '2021-03-20 12:11:56');
INSERT INTO `t_lostfound` VALUES (2, '捡到一个苹果手机', '苹果手机', '2021-03-15 00:00:00', '学校门口', '<p>学校门口的栏杆上面谁放的苹果手机，估计是玩耍的时候带走了，联系我取回吧！学校门口的栏杆上面谁放的苹果手机，估计是玩耍的时候带走了，联系我取回吧！学校门口的栏杆上面谁放的苹果手机，估计是玩耍的时候带走了，联系我取回吧！</p>', '黄美女', '13501082932', '18888888886', '2021-03-21 00:59:50');
INSERT INTO `t_lostfound` VALUES (3, '捡到一个移动硬盘', '移动硬盘', '2021-03-21 12:12:22', '计算机教室', '<p>谁上计算机课的时候，移动硬盘忘记带走了，还有数据线连着电脑呢，谁的来取！谁上计算机课的时候，移动硬盘忘记带走了，还有数据线连着电脑呢，谁的来取！谁上计算机课的时候，移动硬盘忘记带走了，还有数据线连着电脑呢，谁的来取！</p>', '汪同学', '13508831234', '18888888888', '2021-03-21 12:11:56');

-- ----------------------------
-- Table structure for t_notice
-- ----------------------------
DROP TABLE IF EXISTS `t_notice`;
CREATE TABLE `t_notice`  (
  `noticeId` int(11) NOT NULL AUTO_INCREMENT COMMENT '通知id',
  `title` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标题',
  `content` varchar(4000) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '内容',
  `addTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '发布时间',
  PRIMARY KEY (`noticeId`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_notice
-- ----------------------------
INSERT INTO `t_notice` VALUES (1, '失物招领平台上线了', '<p>同学们有丢失的东西，可以来这里发布了！</p>', '2021-03-20 15:29:13');
INSERT INTO `t_notice` VALUES (2, '你们捡到东西也可以来找失主', '<p>凡是捡到物品，物归原主的同学，可以到时根据拾得记录奖励学分哦！</p>', '2021-03-21 12:31:15');

-- ----------------------------
-- Table structure for t_praise
-- ----------------------------
DROP TABLE IF EXISTS `t_praise`;
CREATE TABLE `t_praise`  (
  `praiseId` int(11) NOT NULL AUTO_INCREMENT COMMENT '表扬id',
  `lostFoundObj` int(11) NOT NULL COMMENT '招领信息',
  `title` varchar(40) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '标题',
  `contents` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '表扬内容',
  `addTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '表扬时间',
  PRIMARY KEY (`praiseId`) USING BTREE,
  INDEX `lostFoundObj`(`lostFoundObj`) USING BTREE,
  CONSTRAINT `t_praise_ibfk_1` FOREIGN KEY (`lostFoundObj`) REFERENCES `t_lostfound` (`lostFoundId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB AUTO_INCREMENT = 4 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_praise
-- ----------------------------
INSERT INTO `t_praise` VALUES (1, 1, 'u盘已经归还，感谢！', '感谢汪同学捡到后立即联系到了失主，物归原主', '2021-03-20 15:29:03');
INSERT INTO `t_praise` VALUES (2, 2, '手机已经归还', '感谢黄霞美女同学的拾金不昧精神，你的精神就和你人一样美丽，特此嘉奖！', '2021-03-21 12:20:03');
INSERT INTO `t_praise` VALUES (3, 3, '硬盘已经找到失主', '感谢汪大神同学捡到的物品，已经给原来的主人', '2021-03-21 12:29:39');

-- ----------------------------
-- Table structure for t_userinfo
-- ----------------------------
DROP TABLE IF EXISTS `t_userinfo`;
CREATE TABLE `t_userinfo`  (
  `user_name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT 'user_name',
  `password` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '登录密码',
  `areaObj` int(11) NOT NULL COMMENT '所在学院',
  `name` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '姓名',
  `sex` varchar(4) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '性别',
  `userPhoto` varchar(60) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '学生照片',
  `birthday` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '出生日期',
  `telephone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '联系电话',
  `address` varchar(50) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL COMMENT '家庭地址',
  `regTime` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT '注册时间',
  `openid` varchar(100) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  PRIMARY KEY (`user_name`) USING BTREE,
  INDEX `areaObj`(`areaObj`) USING BTREE,
  CONSTRAINT `t_userinfo_ibfk_1` FOREIGN KEY (`areaObj`) REFERENCES `t_area` (`areaId`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Compact;

-- ----------------------------
-- Records of t_userinfo
-- ----------------------------
INSERT INTO `t_userinfo` VALUES ('13649023423', '123', 1, '李小双', '男', 'upload/a5cef482-4560-4f55-9eab-f789b06ef773.jpg', '2021-03-10', '13649023423', '四川省成都二仙桥10号', '2021-03-20 15:25:43', NULL);
INSERT INTO `t_userinfo` VALUES ('18888888886', '123456', 1, '黄霞', '女', 'images/avatar/avatar1.png', '2021-01-21', '18888888886', '--', '2021-03-21 01:30:01', '--');
INSERT INTO `t_userinfo` VALUES ('18888888888', '123456', 1, '大神汪', '男', 'images/avatar/avatar8.png', '2021-01-21', '18888888888', '四川省成都二仙桥10号', '2021-03-20 16:38:46', '--');

SET FOREIGN_KEY_CHECKS = 1;
