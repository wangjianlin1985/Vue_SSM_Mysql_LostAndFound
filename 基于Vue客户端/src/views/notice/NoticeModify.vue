<template>
    <div id="notice">
        <nav-bar class="nav">
            <template v-slot:left><van-icon name="arrow-left" size="25"  @click.stop="back" /></template>
            <template v-slot:center>编辑站内通知</template>
            <template v-slot:right></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" style="padding: 0px 5px">
            <van-form @submit="onSubmit">
                <van-field readonly name="notice.noticeId" v-model="noticeId" label="通知id：" placeholder="请输入通知id" :rules="[{ required: true, message: '请填写通知id' }]" />
                <van-field autosize clearable name="notice.title" v-model="title" label="标题：" placeholder="请输入标题" :rules="[{ required: true, message: '请填写标题' }]" />
                <div class="van-cell van-field" style="pointer-events: auto;">
                    <div class="van-cell__title van-field__label"><span>内容：</span></div>
                    <div class="van-cell__value van-field__value">
                        <div class="van-field__body"></div>
                    </div>
                </div>
                <van-field  v-show="false" name="notice.content" v-model="content" rows="5" label="内容" type="textarea" maxlength="8000"  placeholder="请输入内容" show-word-limit />
                <VueUeditorWrap  v-model="content" :config="editorConfig" />
                <van-field readonly name="notice.addTime" label="发布时间" :value="addTime"   placeholder="选择发布时间" @click="showAddTimePicker = true" :rules="[{ required: true, message: '发布时间' }]">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearAddTime">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showAddTimePicker"  v-model="picker_addTime" type="date" @cancel="showAddTimePicker = false" title="选择发布时间" @confirm="onConfirmAddTime" />
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
    import VueUeditorWrap from 'vue-ueditor-wrap'
    import { updateNotice} from "../../network/Notice";
    import { getNotice } from "../../network/Notice";
    export default {
        name: "NoticeAdd",
        components: {
            NavBar,
            Scroll,
            VueUeditorWrap
        },
        data() {
            return {
                noticeId: "",  //通知id
                title: "", //标题
                content: "", //内容
                showAddTimePicker:false, //是否显示发布时间Picker
                addTime: '', //发布时间
                picker_addTime: new Date(), //发布时间Picker的日期
                // 简单配置
                editorConfig: {
                    // 编辑器不自动被内容撑高
                    autoHeightEnabled: false,
                    // 初始容器高度
                    initialFrameHeight: 280,
                    // 初始容器宽度
                    initialFrameWidth: '100%',
                    // 上传文件接口
                    //serverUrl: 'http://localhost:8080/JavaWebProject/ueditor1_4_3/jsp/controller.jsp',
                }
            }
        },

        mounted() {

        },

        created() {
            this.noticeId = this.$route.params.noticeId;  //接收通知id参数
            //向后端请求单条站内通知记录
            getNotice(this.noticeId).then(res => {
                var notice = res.data;
                this.noticeId = notice.noticeId; //通知id
                this.title = notice.title;  //标题
                this.content = notice.content;  //内容
                this.addTime = notice.addTime; //发布时间
                this.picker_addTime = new Date(this.addTime.replace(/-/g, '/'))
            })
            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
            back() {
                this.$router.go(-1);
            },

            onSubmit(notice) {  //向后台请求更新站内通知
                updateNotice(notice).then(res => {
                    console.log(res)
                    this.$notify.success('更新成功~')
                }).catch(error => { this.$notify.error(error)})
            },
            onConfirmAddTime(value) {  //选中某个发布时间后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.addTime = year + "-" +  month + "-" + day ;
                this.showAddTimePicker = false;
            },
            clearAddTime() { //清空发布时间
                this.addTime='';
                this.showAddTimePicker=false;
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

    #notice {
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

