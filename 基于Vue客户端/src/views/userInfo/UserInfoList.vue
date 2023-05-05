<template>
    <div id="userInfo">
        <van-popup v-model="showQueryUserInfoForm"  closeable position="top" :style="{ height: 'auto' }">
            <div class="userInfoQueryForm">
                <h3>用户查询</h3>
                <van-field clearable v-model="user_name" label="手机账号：" placeholder="请输入手机账号" />
                <van-field readonly clickable label="所在学院" :value="areaObj_areaName" right-icon="arrow-down" placeholder="选择所在学院" @click="showAreaObjPicker = true" />
                <van-popup v-model="showAreaObjPicker" position="bottom">
                    <van-picker show-toolbar :columns="areaObjColumns" @cancel="showAreaObjPicker = false" @confirm="onConfirmAreaObj" />
                </van-popup>
                <van-field clearable v-model="name" label="姓名：" placeholder="请输入姓名" />
                <van-field readonly label="出生日期" :value="birthday"   placeholder="选择出生日期" @click="showBirthdayPicker = true">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearBirthday">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showBirthdayPicker" v-model="picker_birthday" type="date" @cancel="showBirthdayPicker = false" title="选择出生日期" @confirm="onConfirmBirthday" />
                <van-field clearable v-model="telephone" label="联系电话：" placeholder="请输入联系电话" />
                <van-field readonly label="注册时间" :value="regTime"   placeholder="选择注册时间" @click="showRegTimePicker = true">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearRegTime">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showRegTimePicker" v-model="picker_regTime" type="date" @cancel="showRegTimePicker = false" title="选择注册时间" @confirm="onConfirmRegTime" />
                <div class="queryBtn">
                    <van-button round  size= small type="primary" @click="queryUserInfo">查询</van-button>
                </div>
            </div>
        </van-popup>

        <nav-bar class="nav" ref="nav" >
            <template v-slot:left><van-icon name="plus" size="25" v-show="false" @click.stop="userInfoAdd" /></template>
            <template v-slot:center>用户列表</template>
            <template v-slot:right><van-icon name="search" size="25"  @click.stop="showQueryUserInfoForm=true" /></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" :isPullDown="true" @pullingDown="pullingDown" :isPullUp="true" @pullingUp="pullingUp"  @iscroll="contentScroll">
            <div class="ignore-pull-down1" ref="pull" v-show="pullFlag">下拉更新</div>
            <div class="ignore-pull-down2" ref="pull" v-show="!pullFlag">
                <span class="ball1"></span><span class="ball2"></span><span class="ball3"></span>
            </div>
            <div class="userInfoList">
                <template v-for="userInfo in userInfoList">
                    <div class="userInfoItem" :key="userInfo.user_name" @click.stop="userInfoDetailClick(`${userInfo.user_name}`)">
                        <div class="content_view">
                            <div class="userInfoImg">
                                <img v-lazy="'/' + userInfo.userPhoto">
                            </div>
                            <div class="userInfoText">
                                <div>手机账号：{{userInfo.user_name}}</div>
                                <div>所在学院：{{userInfo.areaObj.areaName}}</div>
                                <div>姓名：{{userInfo.name}}</div>
                                <div>性别：{{userInfo.sex}}</div>
                                <div>出生日期：{{userInfo.birthday}}</div>
                            </div>
                        </div>
                        <div class="opt_view" v-show="false">
                            <van-button round  size= small type="primary"  @click.stop="userInfoEditClick(`${userInfo.user_name}`)" >编辑</van-button>
                            <van-button round  size= small type="warning" @click.stop="userInfoDeleteClick(`${userInfo.user_name}`)" style="margin-left:10px;">删除</van-button>
                        </div>
                    </div>
                </template>
            </div>
            <div class="block"></div>
        </scroll>
        <return-top @returnTop="returnTop" v-show="isReturnTop"></return-top>
    </div>
</template>

<script>
    import NavBar from '../../components/common/navbar/NavBar'
    import Scroll from '../../components/common/scroll/Scroll'
    import ReturnTop from '../../components/common/returntop/ReturnTop'

    import {queryUserInfo,deleteUserInfo} from '../../network/UserInfo'
    import { queryAllArea } from '../../network/Area'
    export default {
        name: 'UserInfoList',
        components: {
            NavBar,
            Scroll,
            ReturnTop
        },
        data() {
            return {
                userInfoList: [],  //界面需要展示的用户列表数据
                user_name: "", //手机账号查询关键字

                areaObjList:[], //所在学院列表
                areaObj_areaId: 0,  //要查询的学院id
                areaObj_areaName: "不限制", //要查询的学院名称
                showAreaObjPicker: false, //是否显示所在学院Picker
                areaObjColumns: ['不限制'], //所在学院Picker的选项初始化
                name: "", //姓名查询关键字

                birthday: "",  //出生日期
                showBirthdayPicker: false, //是否显示选择出生日期Picker
                picker_birthday: new Date(), //出生日期Picker绑定的日期
                telephone: "", //联系电话查询关键字

                regTime: "",  //注册时间
                showRegTimePicker: false, //是否显示选择注册时间Picker
                picker_regTime: new Date(), //注册时间Picker绑定的日期

                pullFlag: true,  //是否允许下拉刷新标志
                page: 1, //默认显示结果第1页
                showQueryUserInfoForm: false, //是否显示查询用户表单
                isReturnTop: false,
            }
        },

        created() {
            //初始化所在学院下拉框数据
            queryAllArea().then(res => {
                this.areaObjList = res.data;
                for(var i=0;i<this.areaObjList.length;i++) {
                    this.areaObjColumns.push(this.areaObjList[i].areaName)
                }
            });
            //查询用户信息
            this.userInfoQuery("");
            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
           onConfirmAreaObj(value,index) {  //选中某个所在学院后响应
                this.areaObj_areaName = value;
                if(index == 0) this.areaObj_areaId = 0;
                else this.areaObj_areaId = this.areaObjList[index-1].areaId;
                this.showAreaObjPicker = false;
            },

            onConfirmBirthday(value) {  //选中某个出生日期后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.birthday = year + "-" +  month + "-" + day ;
                this.showBirthdayPicker = false;
            },
            clearBirthday() {  //清空出生日期
               this.birthday=''
               this.showBirthdayPicker=false;
            },

            onConfirmRegTime(value) {  //选中某个注册时间后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.regTime = year + "-" +  month + "-" + day ;
                this.showRegTimePicker = false;
            },
            clearRegTime() {  //清空注册时间
               this.regTime=''
               this.showRegTimePicker=false;
            },

            userInfoAdd() {
                this.$router.push('/userInfo/add');  //打开用户添加页面
            },

            queryUserInfo() {
                this.page = 1;
                this.userInfoList = [];
                this.pullFlag = false;
                this.showQueryUserInfoForm = false;
                this.userInfoQuery("QUERY");
            },

            userInfoQuery(action) {
                queryUserInfo(this.user_name,this.areaObj_areaId,this.name,this.birthday,this.telephone,this.regTime,this.page).then(res => {
                    //this.userInfoList.push(...res.data)
                    this.userInfoList = this.userInfoList.concat(res.data.list)
                    if(action == "QUERY") {
                        this.$notify.success('查询成功~');
                        this.$refs.scroll.refresh();
                    }
                    if(action == "UP") {  //上拉加载操作
                        if(res.data.list.length < 10){
                            this.$notify.error('没有更多数据了~')
                            return;
                        }
                        this.$refs.scroll.refresh();
                    }
                    if(action == "DOWN") {  //下拉刷新操作
                        this.$notify.success('刷新成功~');
                        this.$refs.scroll.finishPullDown();
                        this.$refs.scroll.refresh();
                        this.pullFlag = true
                    }
                })
            },

            userInfoDetailClick(user_name) {
                this.$router.push('/userInfo/detail/' + user_name); //跳转到用户详情页
            },
            userInfoEditClick(user_name) {
                this.$router.push('/userInfo/modify/' + user_name); //跳转到用户修改页
            },
            userInfoDeleteClick(user_name) {
                this.$dialog.confirm({
                    title: '删除用户:' + user_name,
                    message: '确定删除吗？'
                }).then(() => {
                    deleteUserInfo(user_name).then(res => {
                        console.log(res)
                        this.userInfoList.forEach(function(userInfo, index, arr) {
                            if(userInfo.user_name == user_name) arr.splice(index, 1);
                        });
                    });
                });
            },

            pullingDown() {  //下拉刷新
                this.page = 1;
                this.userInfoList = [];
                this.pullFlag = false;
                this.userInfoQuery("DOWN");
            },

            pullingUp() {  //上拉加载
                console.log("上拉加载")
                this.page = this.page + 1;
                this.$refs.scroll.finishPullUp();
                this.userInfoQuery("UP");
            },

            returnTop() {
                this.$refs.scroll.scrollTo(0, 0)
            },

            //滚动事件
            contentScroll(position) {
                this.isReturnTop = position.y < -800
            },
        }
    }
</script>

<style scoped>
    @import "../../assets/css/list_base.css";
    @import "UserInfoList.css";
    #userInfo {
        height: 100vh;
        width: 100vw;
        position: relative;
    }
</style>
