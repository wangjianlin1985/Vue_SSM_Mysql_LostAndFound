<template>
    <div id="area">
        <nav-bar class="nav">
            <template v-slot:left><van-icon name="arrow-left" size="25"  @click.stop="back" /></template>
            <template v-slot:center>编辑学院</template>
            <template v-slot:right></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" style="padding: 0px 5px">
            <van-form @submit="onSubmit">
                <van-field readonly name="area.areaId" v-model="areaId" label="学院id：" placeholder="请输入学院id" :rules="[{ required: true, message: '请填写学院id' }]" />
                <van-field autosize clearable name="area.areaName" v-model="areaName" label="学院名称：" placeholder="请输入学院名称" :rules="[{ required: true, message: '请填写学院名称' }]" />
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
    import { updateArea} from "../../network/Area";
    import { getArea } from "../../network/Area";
    export default {
        name: "AreaAdd",
        components: {
            NavBar,
            Scroll,
        },
        data() {
            return {
                areaId: "",  //学院id
                areaName: "", //学院名称
            }
        },

        mounted() {

        },

        created() {
            this.areaId = this.$route.params.areaId;  //接收学院id参数
            //向后端请求单条学院记录
            getArea(this.areaId).then(res => {
                var area = res.data;
                this.areaId = area.areaId; //学院id
                this.areaName = area.areaName;  //学院名称
            })
            document.getElementById("tabbar").style.display = "flex";
        },

        methods: {
            back() {
                this.$router.go(-1);
            },

            onSubmit(area) {  //向后台请求更新学院
                updateArea(area).then(res => {
                    console.log(res)
                    this.$notify.success('更新成功~')
                }).catch(error => { this.$notify.error(error)})
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

    #area {
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

