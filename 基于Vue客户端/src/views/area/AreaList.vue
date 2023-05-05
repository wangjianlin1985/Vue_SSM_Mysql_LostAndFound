<template>
    <div id="area">
        <van-popup v-model="showQueryAreaForm"  closeable position="top" :style="{ height: 'auto' }">
            <div class="areaQueryForm">
                <h3>学院查询</h3>
                <div class="queryBtn">
                    <van-button round  size= small type="primary" @click="queryArea">查询</van-button>
                </div>
            </div>
        </van-popup>

        <nav-bar class="nav" ref="nav" >
            <template v-slot:left><van-icon name="plus" size="25" v-show="false" @click.stop="areaAdd" /></template>
            <template v-slot:center>学院列表</template>
            <template v-slot:right><van-icon name="search" size="25"  @click.stop="showQueryAreaForm=true" /></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" :isPullDown="true" @pullingDown="pullingDown" :isPullUp="true" @pullingUp="pullingUp"  @iscroll="contentScroll">
            <div class="ignore-pull-down1" ref="pull" v-show="pullFlag">下拉更新</div>
            <div class="ignore-pull-down2" ref="pull" v-show="!pullFlag">
                <span class="ball1"></span><span class="ball2"></span><span class="ball3"></span>
            </div>
            <div class="areaList">
                <template v-for="area in areaList">
                    <div class="areaItem" :key="area.areaId" @click.stop="areaDetailClick(`${area.areaId}`)">
                        <div class="content_view">
                            <div class="areaText">
                                <div>学院id：{{area.areaId}}</div>
                                <div>学院名称：{{area.areaName}}</div>
                            </div>
                        </div>
                        <div class="opt_view" v-show="false">
                            <van-button round  size= small type="primary"  @click.stop="areaEditClick(`${area.areaId}`)" >编辑</van-button>
                            <van-button round  size= small type="warning" @click.stop="areaDeleteClick(`${area.areaId}`)" style="margin-left:10px;">删除</van-button>
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

    import {queryArea,deleteArea} from '../../network/Area'
    export default {
        name: 'AreaList',
        components: {
            NavBar,
            Scroll,
            ReturnTop
        },
        data() {
            return {
                areaList: [],  //界面需要展示的学院列表数据

                pullFlag: true,  //是否允许下拉刷新标志
                page: 1, //默认显示结果第1页
                showQueryAreaForm: false, //是否显示查询学院表单
                isReturnTop: false,
            }
        },

        created() {
            //查询学院信息
            this.areaQuery("");
            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
            areaAdd() {
                this.$router.push('/area/add');  //打开学院添加页面
            },

            queryArea() {
                this.page = 1;
                this.areaList = [];
                this.pullFlag = false;
                this.showQueryAreaForm = false;
                this.areaQuery("QUERY");
            },

            areaQuery(action) {
                queryArea(this.page).then(res => {
                    //this.areaList.push(...res.data)
                    this.areaList = this.areaList.concat(res.data.list)
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

            areaDetailClick(areaId) {
                this.$router.push('/area/detail/' + areaId); //跳转到学院详情页
            },
            areaEditClick(areaId) {
                this.$router.push('/area/modify/' + areaId); //跳转到学院修改页
            },
            areaDeleteClick(areaId) {
                this.$dialog.confirm({
                    title: '删除学院:' + areaId,
                    message: '确定删除吗？'
                }).then(() => {
                    deleteArea(areaId).then(res => {
                        console.log(res)
                        this.areaList.forEach(function(area, index, arr) {
                            if(area.areaId == areaId) arr.splice(index, 1);
                        });
                    });
                });
            },

            pullingDown() {  //下拉刷新
                this.page = 1;
                this.areaList = [];
                this.pullFlag = false;
                this.areaQuery("DOWN");
            },

            pullingUp() {  //上拉加载
                console.log("上拉加载")
                this.page = this.page + 1;
                this.$refs.scroll.finishPullUp();
                this.areaQuery("UP");
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
    @import "AreaList.css";
    #area {
        height: 100vh;
        width: 100vw;
        position: relative;
    }
</style>
