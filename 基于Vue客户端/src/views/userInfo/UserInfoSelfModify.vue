<template>
    <div id="userInfo">
        <nav-bar class="nav">
            <template v-slot:left><van-icon name="arrow-left" size="25"  @click.stop="back" /></template>
            <template v-slot:center>修改个人信息</template>
            <template v-slot:right></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" style="padding: 0px 5px">
            <van-form @submit="onSubmit">
                <van-field readonly name="userInfo.user_name" v-model="user_name" label="手机账号：" placeholder="请输入手机账号" :rules="[{ required: true, message: '请填写手机账号' }]" />
                <van-field autosize clearable type="password" name="userInfo.password" v-model="password" label="登录密码：" placeholder="请输入登录密码" :rules="[{ required: true, message: '请填写登录密码' }]" />
                <van-field v-show="false" clearable name="userInfo.areaObj.areaId" v-model="areaObj_areaId" label="所在学院：" />
                <van-field readonly clickable label="所在学院" :value="areaObj_areaName"  right-icon="arrow-down" placeholder="选择所在学院" @click="showAreaObjPicker = true" />
                <van-picker v-show="showAreaObjPicker" show-toolbar :columns="areaObjColumns" :default-index="1" @cancel="showAreaObjPicker = false" @confirm="onConfirmAreaObj" />
                <van-field autosize clearable name="userInfo.name" v-model="name" label="姓名：" placeholder="请输入姓名" :rules="[{ required: true, message: '请填写姓名' }]" />
                <van-field autosize clearable name="userInfo.sex" v-model="sex" label="性别：" placeholder="请输入性别" :rules="[{ required: true, message: '请填写性别' }]" />
                <van-field  v-show="false" clearable name="userInfo.userPhoto" v-model="userPhoto" label="学生照片："  :rules="[{ required: true, message: '学生照片地址不能为空' }]" />
                <div class="van-cell van-field" style="pointer-events: auto;">
                    <div class="van-cell__title van-field__label"><span>学生照片：</span></div>
                    <div class="van-cell__value van-field__value">
                        <div class="van-field__body">
                            <img class="avatar" :src="userPhotoUrl"/>
                            <!-- 图片上传 -->
                            <img-upload name="userPhoto" @uploadFinished="userPhotoUpload"></img-upload>
                        </div>
                    </div>
                </div>
                <van-field readonly name="userInfo.birthday" label="出生日期" :value="birthday"   placeholder="选择出生日期" @click="showBirthdayPicker = true" :rules="[{ required: true, message: '出生日期' }]">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearBirthday">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showBirthdayPicker"  v-model="picker_birthday" type="date" @cancel="showBirthdayPicker = false" title="选择出生日期" @confirm="onConfirmBirthday" />
                <van-field autosize clearable name="userInfo.telephone" v-model="telephone" label="联系电话：" placeholder="请输入联系电话" :rules="[{ required: true, message: '请填写联系电话' }]" />
                <van-field autosize clearable name="userInfo.address" v-model="address" label="家庭地址：" placeholder="请输入家庭地址" :rules="[{ required: true, message: '请填写家庭地址' }]" />
                <van-field v-show="false" readonly name="userInfo.regTime" label="注册时间" :value="regTime"   placeholder="选择注册时间" @click="showRegTimePicker = true" :rules="[{ required: true, message: '注册时间' }]">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearRegTime">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showRegTimePicker"  v-model="picker_regTime" type="date" @cancel="showRegTimePicker = false" title="选择注册时间" @confirm="onConfirmRegTime" />
                <div style="margin: 16px;">
                    <van-button round block type="info" native-type="submit">更新</van-button>
                </div>
            </van-form>
        </scroll>
    </div>
</template>

<script>
    import NavBar from '../../components/common/navbar/NavBar'
    import Scroll from '../../components/common/scroll/Scroll'
    import ImgUpload from '../../components/content/ImgUpload'
    import { queryAllArea } from '../../network/Area'
    import { updateUserInfo} from "../../network/UserInfo";
    import { getSelfUserInfo } from "../../network/UserInfo";

    export default {
        name: "UserInfoAdd",
        components: {
            NavBar,
            Scroll,
            ImgUpload,
        },
        data() {
            return {
                user_name: "",  //手机账号
                password: "", //登录密码
                areaObjList: [], //所在学院列表
                areaObj_areaId: 0, //学院id
                areaObj_areaName: "", //学院名称
                showAreaObjPicker: false, //是否显示所在学院Picker
                areaObjColumns: [], //所在学院Picker的选项
                name: "", //姓名
                sex: "", //性别
                userPhoto: 'upload/NoImage.jpg', //学生照片路径
                userPhotoUrl: '/upload/NoImage.jpg', //学生照片路径
                showBirthdayPicker:false, //是否显示出生日期Picker
                birthday: '', //出生日期
                picker_birthday: new Date(), //出生日期Picker的日期
                telephone: "", //联系电话
                address: "", //家庭地址
                showRegTimePicker:false, //是否显示注册时间Picker
                regTime: '', //注册时间
                picker_regTime: new Date(), //注册时间Picker的日期
            }
        },

        mounted() {

        },

        created() {
            /*查询所有所在学院初始化下拉Picker*/
            queryAllArea().then(res => {
                this.areaObjList = res.data;
                for(var i=0;i<this.areaObjList.length;i++) {
                    this.areaObjColumns.push(this.areaObjList[i].areaName)
                }
            });

            this.user_name = this.$route.params.user_name;  //接收手机账号参数
            //向后端请求单条用户记录
            getSelfUserInfo().then(res => {
                var userInfo = res.data;
                this.user_name = userInfo.user_name; //手机账号
                this.password = userInfo.password;  //登录密码
                this.areaObj_areaId = userInfo.areaObj.areaId; //所在学院
                this.areaObj_areaName = userInfo.areaObj.areaName;
                this.name = userInfo.name;  //姓名
                this.sex = userInfo.sex;  //性别
                this.userPhoto = userInfo.userPhoto; //学生照片
                this.userPhotoUrl = "/" + userInfo.userPhoto;
                this.birthday = userInfo.birthday; //出生日期
                this.picker_birthday = new Date(this.birthday.replace(/-/g, '/'))
                this.telephone = userInfo.telephone;  //联系电话
                this.address = userInfo.address;  //家庭地址
                this.regTime = userInfo.regTime; //注册时间
                this.picker_regTime = new Date(this.regTime.replace(/-/g, '/'))
            })
            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
            back() {
                this.$router.go(-1);
            },

            onConfirmAreaObj(value,index) {
                this.areaObj_areaName = value; //选中某个所在学院后响应
                this.areaObj_areaId = this.areaObjList[index].areaId;
                this.showAreaObjPicker = false;
            },
            onSubmit(userInfo) {  //向后台请求更新用户
                updateUserInfo(userInfo).then(res => {
                    console.log(res)
                    this.$notify.success('更新成功~')
                }).catch(error => { this.$notify.error(error)})
            },
            onConfirmBirthday(value) {  //选中某个出生日期后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.birthday = year + "-" +  month + "-" + day ;
                this.showBirthdayPicker = false;
            },
            clearBirthday() { //清空出生日期
                this.birthday='';
                this.showBirthdayPicker=false;
            },
            onConfirmRegTime(value) {  //选中某个注册时间后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.regTime = year + "-" +  month + "-" + day ;
                this.showRegTimePicker = false;
            },
            clearRegTime() { //清空注册时间
                this.regTime='';
                this.showRegTimePicker=false;
            },
            userPhotoUpload(name,data) {  //上传学生照片后的回调方法
                if(name == "userPhoto") {
                    this.userPhoto = data;
                }
            },
        },
    }
</script>

<style scoped>
    .nav {
        background-color: #54bf8e;
        color: #fff;
    }

    .back {
        font-family: 'icomoon';
        font-size: 30px;
    }

    #userInfo {
        height: 100vh;
        width: 100vw;
        position: relative;
    }

    .content {
        position: fixed;
        top: 50px;
        left: 0;
        right: 0px;
        bottom: 49px;
    }

    .van-dropdown-menu {  width: 100%; }

    .avatar {
        width: 100px;
        height: 100px;
        background-color: #f3f3f3;
        float: left;
        top: 5px;
        right: 5px;
        border-radius: 3px;
       margin-bottom: 26px;
    }
</style>

