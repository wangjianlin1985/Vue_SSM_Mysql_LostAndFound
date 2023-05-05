<template>
    <div id="claim">
        <nav-bar class="nav">
            <template v-slot:left><van-icon name="arrow-left" size="25"  @click.stop="back" /></template>
            <template v-slot:center>添加认领</template>
            <template v-slot:right></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" style="padding: 0px 5px">
            <van-form @submit="onSubmit">
                <van-field v-show="false" clearable name="claim.lostFoundObj.lostFoundId" v-model="lostFoundObj_lostFoundId" label="招领信息：" />
                <van-field readonly clickable label="招领信息" :value="lostFoundObj_title"  right-icon="arrow-down" placeholder="选择招领信息" @click="showLostFoundObjPicker = true" />
                <van-picker v-show="showLostFoundObjPicker" show-toolbar :columns="lostFoundObjColumns" :default-index="1" @cancel="showLostFoundObjPicker = false" @confirm="onConfirmLostFoundObj" />
                <van-field autosize clearable name="claim.personName" v-model="personName" label="认领人：" placeholder="请输入认领人" :rules="[{ required: true, message: '请填写认领人' }]" />
                <van-field readonly name="claim.claimTime" label="认领时间" :value="claimTime"   placeholder="选择认领时间" @click="showClaimTimePicker = true" :rules="[{ required: true, message: '认领时间' }]">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearClaimTime">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showClaimTimePicker"  v-model="picker_claimTime" type="date" @cancel="showClaimTimePicker = false" title="选择认领时间" @confirm="onConfirmClaimTime" />
                <div class="van-cell van-field" style="pointer-events: auto;">
                    <div class="van-cell__title van-field__label"><span>描述说明：</span></div>
                    <div class="van-cell__value van-field__value">
                        <div class="van-field__body"></div>
                    </div>
                </div>
                <van-field  v-show="false" name="claim.contents" v-model="contents" rows="5" label="描述说明" type="textarea" maxlength="8000"  placeholder="请输入描述说明" show-word-limit />
                <VueUeditorWrap  v-model="contents" :config="editorConfig"  @ready="contentsEditorReady" />
                <van-field autosize clearable name="claim.addTime" v-model="addTime" label="发布时间：" placeholder="请输入发布时间" :rules="[{ required: true, message: '请填写发布时间' }]" />
                <div style="margin: 16px;">
                    <van-button round block type="info" native-type="submit">提交</van-button>
                </div>
            </van-form>
        </scroll>
    </div>
</template>

<script>
    import NavBar from '../../components/common/navbar/NavBar'
    import Scroll from '../../components/common/scroll/Scroll'
    import VueUeditorWrap from 'vue-ueditor-wrap'
    import { queryAllLostFound } from '../../network/LostFound'
    import { addClaim} from "../../network/Claim";

    export default {
        name: "ClaimAdd",
        components: {
            NavBar,
            Scroll,
            VueUeditorWrap
        },
        data() {
            return {
                lostFoundObjList: [], //招领信息列表
                lostFoundObj_lostFoundId: 0, //招领id
                lostFoundObj_title: "", //标题
                showLostFoundObjPicker: false, //是否显示招领信息Picker
                lostFoundObjColumns: [], //招领信息Picker的选项
                personName: "", //认领人
                showClaimTimePicker:false, //是否显示认领时间Picker
                claimTime: '', //认领时间
                picker_claimTime: new Date(), //认领时间Picker的日期
                contents: "", //描述说明
                addTime: "", //发布时间
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
            /*查询所有招领信息初始化下拉Picker*/
            queryAllLostFound().then(res => {
                this.lostFoundObjList = res.data;
                for(var i=0;i<this.lostFoundObjList.length;i++) {
                    this.lostFoundObjColumns.push(this.lostFoundObjList[i].title)
                }
                if(this.lostFoundObjList.length > 0) {
                    var firstLostFoundObj = this.lostFoundObjList[0]; //默认选中第一个选项
                    this.lostFoundObj_title = firstLostFoundObj.title;
                    this.lostFoundObj_lostFoundId = firstLostFoundObj.lostFoundId;
                }
            });

            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
            contentsEditorReady(editorInstance) {
                // 这里可以拿到ueditor的实例，比如editorInstance.getContent()就可以拿到编辑器的html内容
                //this.evtHub.$emit('editor.data', editorInstance);
                console.log("准备编辑器ok",editorInstance);
            },
            back() {
                this.$router.go(-1);
            },

            onConfirmLostFoundObj(value,index) {
                this.lostFoundObj_title = value; //选中某个招领信息后响应
                this.lostFoundObj_lostFoundId = this.lostFoundObjList[index].lostFoundId;
                this.showLostFoundObjPicker = false;
            },
            onSubmit(claim) {  //向后台请求添加认领
                addClaim(claim).then(res => {
                    console.log(res)
                    this.$notify.success('添加成功~')
                }).catch(error => { this.$notify.error(error)})
            },
            onConfirmClaimTime(value) {  //选中某个认领时间后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.claimTime = year + "-" +  month + "-" + day ;
                this.showClaimTimePicker = false;
            },
            clearClaimTime() { //清空认领时间
                this.claimTime='';
                this.showClaimTimePicker=false;
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

    #claim {
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

</style>
