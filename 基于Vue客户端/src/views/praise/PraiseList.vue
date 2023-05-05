<template>
    <div id="praise">
        <van-popup v-model="showQueryPraiseForm"  closeable position="top" :style="{ height: 'auto' }">
            <div class="praiseQueryForm">
                <h3>表扬查询</h3>
                <van-field readonly clickable label="招领信息" :value="lostFoundObj_title" right-icon="arrow-down" placeholder="选择招领信息" @click="showLostFoundObjPicker = true" />
                <van-popup v-model="showLostFoundObjPicker" position="bottom">
                    <van-picker show-toolbar :columns="lostFoundObjColumns" @cancel="showLostFoundObjPicker = false" @confirm="onConfirmLostFoundObj" />
                </van-popup>
                <van-field clearable v-model="title" label="标题：" placeholder="请输入标题" />
                <van-field readonly label="表扬时间" :value="addTime"   placeholder="选择表扬时间" @click="showAddTimePicker = true">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearAddTime">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showAddTimePicker" v-model="picker_addTime" type="date" @cancel="showAddTimePicker = false" title="选择表扬时间" @confirm="onConfirmAddTime" />
                <div class="queryBtn">
                    <van-button round  size= small type="primary" @click="queryPraise">查询</van-button>
                </div>
            </div>
        </van-popup>

        <nav-bar class="nav" ref="nav" >
            <template v-slot:left><van-icon name="plus" size="25" v-show="false" @click.stop="praiseAdd" /></template>
            <template v-slot:center>表扬列表</template>
            <template v-slot:right><van-icon name="search" size="25"  @click.stop="showQueryPraiseForm=true" /></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" :isPullDown="true" @pullingDown="pullingDown" :isPullUp="true" @pullingUp="pullingUp"  @iscroll="contentScroll">
            <div class="ignore-pull-down1" ref="pull" v-show="pullFlag">下拉更新</div>
            <div class="ignore-pull-down2" ref="pull" v-show="!pullFlag">
                <span class="ball1"></span><span class="ball2"></span><span class="ball3"></span>
            </div>
            <div class="praiseList">
                <template v-for="praise in praiseList">
                    <div class="praiseItem" :key="praise.praiseId" @click.stop="praiseDetailClick(`${praise.praiseId}`)">
                        <div class="content_view">
                            <div class="praiseText">
                                <div>招领信息：{{praise.lostFoundObj.title}}</div>
                                <div>标题：{{praise.title}}</div>
                                <div>表扬时间：{{praise.addTime}}</div>
                            </div>
                        </div>
                        <div class="opt_view" v-show="false">
                            <van-button round  size= small type="primary"  @click.stop="praiseEditClick(`${praise.praiseId}`)" >编辑</van-button>
                            <van-button round  size= small type="warning" @click.stop="praiseDeleteClick(`${praise.praiseId}`)" style="margin-left:10px;">删除</van-button>
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

    import {queryPraise,deletePraise} from '../../network/Praise'
    import { queryAllLostFound } from '../../network/LostFound'
    export default {
        name: 'PraiseList',
        components: {
            NavBar,
            Scroll,
            ReturnTop
        },
        data() {
            return {
                praiseList: [],  //界面需要展示的表扬列表数据

                lostFoundObjList:[], //招领信息列表
                lostFoundObj_lostFoundId: 0,  //要查询的招领id
                lostFoundObj_title: "不限制", //要查询的标题
                showLostFoundObjPicker: false, //是否显示招领信息Picker
                lostFoundObjColumns: ['不限制'], //招领信息Picker的选项初始化
                title: "", //标题查询关键字

                addTime: "",  //表扬时间
                showAddTimePicker: false, //是否显示选择表扬时间Picker
                picker_addTime: new Date(), //表扬时间Picker绑定的日期

                pullFlag: true,  //是否允许下拉刷新标志
                page: 1, //默认显示结果第1页
                showQueryPraiseForm: false, //是否显示查询表扬表单
                isReturnTop: false,
            }
        },

        created() {
            //初始化招领信息下拉框数据
            queryAllLostFound().then(res => {
                this.lostFoundObjList = res.data;
                for(var i=0;i<this.lostFoundObjList.length;i++) {
                    this.lostFoundObjColumns.push(this.lostFoundObjList[i].title)
                }
            });
            //查询表扬信息
            this.praiseQuery("");
            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
           onConfirmLostFoundObj(value,index) {  //选中某个招领信息后响应
                this.lostFoundObj_title = value;
                if(index == 0) this.lostFoundObj_lostFoundId = 0;
                else this.lostFoundObj_lostFoundId = this.lostFoundObjList[index-1].lostFoundId;
                this.showLostFoundObjPicker = false;
            },

            onConfirmAddTime(value) {  //选中某个表扬时间后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.addTime = year + "-" +  month + "-" + day ;
                this.showAddTimePicker = false;
            },
            clearAddTime() {  //清空表扬时间
               this.addTime=''
               this.showAddTimePicker=false;
            },

            praiseAdd() {
                this.$router.push('/praise/add');  //打开表扬添加页面
            },

            queryPraise() {
                this.page = 1;
                this.praiseList = [];
                this.pullFlag = false;
                this.showQueryPraiseForm = false;
                this.praiseQuery("QUERY");
            },

            praiseQuery(action) {
                queryPraise(this.lostFoundObj_lostFoundId,this.title,this.addTime,this.page).then(res => {
                    //this.praiseList.push(...res.data)
                    this.praiseList = this.praiseList.concat(res.data.list)
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

            praiseDetailClick(praiseId) {
                this.$router.push('/praise/detail/' + praiseId); //跳转到表扬详情页
            },
            praiseEditClick(praiseId) {
                this.$router.push('/praise/modify/' + praiseId); //跳转到表扬修改页
            },
            praiseDeleteClick(praiseId) {
                this.$dialog.confirm({
                    title: '删除表扬:' + praiseId,
                    message: '确定删除吗？'
                }).then(() => {
                    deletePraise(praiseId).then(res => {
                        console.log(res)
                        this.praiseList.forEach(function(praise, index, arr) {
                            if(praise.praiseId == praiseId) arr.splice(index, 1);
                        });
                    });
                });
            },

            pullingDown() {  //下拉刷新
                this.page = 1;
                this.praiseList = [];
                this.pullFlag = false;
                this.praiseQuery("DOWN");
            },

            pullingUp() {  //上拉加载
                console.log("上拉加载")
                this.page = this.page + 1;
                this.$refs.scroll.finishPullUp();
                this.praiseQuery("UP");
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
    @import "PraiseList.css";
    #praise {
        height: 100vh;
        width: 100vw;
        position: relative;
    }
</style>
