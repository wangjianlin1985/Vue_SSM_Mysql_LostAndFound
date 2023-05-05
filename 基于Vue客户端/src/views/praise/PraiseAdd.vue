<template>
    <div id="praise">
        <nav-bar class="nav">
            <template v-slot:left><van-icon name="arrow-left" size="25"  @click.stop="back" /></template>
            <template v-slot:center>添加表扬</template>
            <template v-slot:right></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" style="padding: 0px 5px">
            <van-form @submit="onSubmit">
                <van-field v-show="false" clearable name="praise.lostFoundObj.lostFoundId" v-model="lostFoundObj_lostFoundId" label="招领信息：" />
                <van-field readonly clickable label="招领信息" :value="lostFoundObj_title"  right-icon="arrow-down" placeholder="选择招领信息" @click="showLostFoundObjPicker = true" />
                <van-picker v-show="showLostFoundObjPicker" show-toolbar :columns="lostFoundObjColumns" :default-index="1" @cancel="showLostFoundObjPicker = false" @confirm="onConfirmLostFoundObj" />
                <van-field autosize clearable name="praise.title" v-model="title" label="标题：" placeholder="请输入标题" :rules="[{ required: true, message: '请填写标题' }]" />
                <van-field autosize clearable name="praise.contents" v-model="contents" label="表扬内容：" placeholder="请输入表扬内容" :rules="[{ required: true, message: '请填写表扬内容' }]" />
                <van-field readonly name="praise.addTime" label="表扬时间" :value="addTime"   placeholder="选择表扬时间" @click="showAddTimePicker = true" :rules="[{ required: true, message: '表扬时间' }]">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearAddTime">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showAddTimePicker"  v-model="picker_addTime" type="date" @cancel="showAddTimePicker = false" title="选择表扬时间" @confirm="onConfirmAddTime" />
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
    import { queryAllLostFound } from '../../network/LostFound'
    import { addPraise} from "../../network/Praise";

    export default {
        name: "PraiseAdd",
        components: {
            NavBar,
            Scroll,
        },
        data() {
            return {
                lostFoundObjList: [], //招领信息列表
                lostFoundObj_lostFoundId: 0, //招领id
                lostFoundObj_title: "", //标题
                showLostFoundObjPicker: false, //是否显示招领信息Picker
                lostFoundObjColumns: [], //招领信息Picker的选项
                title: "", //标题
                contents: "", //表扬内容
                showAddTimePicker:false, //是否显示表扬时间Picker
                addTime: '', //表扬时间
                picker_addTime: new Date(), //表扬时间Picker的日期
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
            back() {
                this.$router.go(-1);
            },

            onConfirmLostFoundObj(value,index) {
                this.lostFoundObj_title = value; //选中某个招领信息后响应
                this.lostFoundObj_lostFoundId = this.lostFoundObjList[index].lostFoundId;
                this.showLostFoundObjPicker = false;
            },
            onSubmit(praise) {  //向后台请求添加表扬
                addPraise(praise).then(res => {
                    console.log(res)
                    this.$notify.success('添加成功~')
                }).catch(error => { this.$notify.error(error)})
            },
            onConfirmAddTime(value) {  //选中某个表扬时间后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.addTime = year + "-" +  month + "-" + day ;
                this.showAddTimePicker = false;
            },
            clearAddTime() { //清空表扬时间
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

    #praise {
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
