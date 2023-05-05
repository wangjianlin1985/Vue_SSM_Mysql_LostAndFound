<template>
    <div id="claim">
        <van-popup v-model="showQueryClaimForm"  closeable position="top" :style="{ height: 'auto' }">
            <div class="claimQueryForm">
                <h3>认领查询</h3>
                <van-field readonly clickable label="招领信息" :value="lostFoundObj_title" right-icon="arrow-down" placeholder="选择招领信息" @click="showLostFoundObjPicker = true" />
                <van-popup v-model="showLostFoundObjPicker" position="bottom">
                    <van-picker show-toolbar :columns="lostFoundObjColumns" @cancel="showLostFoundObjPicker = false" @confirm="onConfirmLostFoundObj" />
                </van-popup>
                <van-field clearable v-model="personName" label="认领人：" placeholder="请输入认领人" />
                <van-field readonly label="认领时间" :value="claimTime"   placeholder="选择认领时间" @click="showClaimTimePicker = true">
                    <template #button>
                        <van-button size="small" type="warning" @click.stop="clearClaimTime">清除</van-button>
                    </template>
                </van-field>
                <van-datetime-picker v-if="showClaimTimePicker" v-model="picker_claimTime" type="date" @cancel="showClaimTimePicker = false" title="选择认领时间" @confirm="onConfirmClaimTime" />
                <div class="queryBtn">
                    <van-button round  size= small type="primary" @click="queryClaim">查询</van-button>
                </div>
            </div>
        </van-popup>

        <nav-bar class="nav" ref="nav" >
            <template v-slot:left><van-icon name="plus" size="25" v-show="false" @click.stop="claimAdd" /></template>
            <template v-slot:center>认领列表</template>
            <template v-slot:right><van-icon name="search" size="25"  @click.stop="showQueryClaimForm=true" /></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" :isPullDown="true" @pullingDown="pullingDown" :isPullUp="true" @pullingUp="pullingUp"  @iscroll="contentScroll">
            <div class="ignore-pull-down1" ref="pull" v-show="pullFlag">下拉更新</div>
            <div class="ignore-pull-down2" ref="pull" v-show="!pullFlag">
                <span class="ball1"></span><span class="ball2"></span><span class="ball3"></span>
            </div>
            <div class="claimList">
                <template v-for="claim in claimList">
                    <div class="claimItem" :key="claim.claimId" @click.stop="claimDetailClick(`${claim.claimId}`)">
                        <div class="content_view">
                            <div class="claimText">
                                <div>招领信息：{{claim.lostFoundObj.title}}</div>
                                <div>认领人：{{claim.personName}}</div>
                                <div>认领时间：{{claim.claimTime}}</div>
                                <div>发布时间：{{claim.addTime}}</div>
                            </div>
                        </div>
                        <div class="opt_view" v-show="false">
                            <van-button round  size= small type="primary"  @click.stop="claimEditClick(`${claim.claimId}`)" >编辑</van-button>
                            <van-button round  size= small type="warning" @click.stop="claimDeleteClick(`${claim.claimId}`)" style="margin-left:10px;">删除</van-button>
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

    import {queryClaim,deleteClaim} from '../../network/Claim'
    import { queryAllLostFound } from '../../network/LostFound'
    export default {
        name: 'ClaimList',
        components: {
            NavBar,
            Scroll,
            ReturnTop
        },
        data() {
            return {
                claimList: [],  //界面需要展示的认领列表数据

                lostFoundObjList:[], //招领信息列表
                lostFoundObj_lostFoundId: 0,  //要查询的招领id
                lostFoundObj_title: "不限制", //要查询的标题
                showLostFoundObjPicker: false, //是否显示招领信息Picker
                lostFoundObjColumns: ['不限制'], //招领信息Picker的选项初始化
                personName: "", //认领人查询关键字

                claimTime: "",  //认领时间
                showClaimTimePicker: false, //是否显示选择认领时间Picker
                picker_claimTime: new Date(), //认领时间Picker绑定的日期

                pullFlag: true,  //是否允许下拉刷新标志
                page: 1, //默认显示结果第1页
                showQueryClaimForm: false, //是否显示查询认领表单
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
            //查询认领信息
            this.claimQuery("");
            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
           onConfirmLostFoundObj(value,index) {  //选中某个招领信息后响应
                this.lostFoundObj_title = value;
                if(index == 0) this.lostFoundObj_lostFoundId = 0;
                else this.lostFoundObj_lostFoundId = this.lostFoundObjList[index-1].lostFoundId;
                this.showLostFoundObjPicker = false;
            },

            onConfirmClaimTime(value) {  //选中某个认领时间后的响应
                var year = value.getFullYear();
                var month = (value.getMonth()+1)<10?'0'+ (value.getMonth()+1): (value.getMonth()+1);
                var day = value.getDate()<10?'0'+value.getDate():value.getDate();
                this.claimTime = year + "-" +  month + "-" + day ;
                this.showClaimTimePicker = false;
            },
            clearClaimTime() {  //清空认领时间
               this.claimTime=''
               this.showClaimTimePicker=false;
            },

            claimAdd() {
                this.$router.push('/claim/add');  //打开认领添加页面
            },

            queryClaim() {
                this.page = 1;
                this.claimList = [];
                this.pullFlag = false;
                this.showQueryClaimForm = false;
                this.claimQuery("QUERY");
            },

            claimQuery(action) {
                queryClaim(this.lostFoundObj_lostFoundId,this.personName,this.claimTime,this.page).then(res => {
                    //this.claimList.push(...res.data)
                    this.claimList = this.claimList.concat(res.data.list)
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

            claimDetailClick(claimId) {
                this.$router.push('/claim/detail/' + claimId); //跳转到认领详情页
            },
            claimEditClick(claimId) {
                this.$router.push('/claim/modify/' + claimId); //跳转到认领修改页
            },
            claimDeleteClick(claimId) {
                this.$dialog.confirm({
                    title: '删除认领:' + claimId,
                    message: '确定删除吗？'
                }).then(() => {
                    deleteClaim(claimId).then(res => {
                        console.log(res)
                        this.claimList.forEach(function(claim, index, arr) {
                            if(claim.claimId == claimId) arr.splice(index, 1);
                        });
                    });
                });
            },

            pullingDown() {  //下拉刷新
                this.page = 1;
                this.claimList = [];
                this.pullFlag = false;
                this.claimQuery("DOWN");
            },

            pullingUp() {  //上拉加载
                console.log("上拉加载")
                this.page = this.page + 1;
                this.$refs.scroll.finishPullUp();
                this.claimQuery("UP");
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
    @import "ClaimList.css";
    #claim {
        height: 100vh;
        width: 100vw;
        position: relative;
    }
</style>
