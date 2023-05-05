<template>
    <div id="claim">
        <nav-bar class="nav">
            <template v-slot:left><van-icon name="arrow-left" size="25"  @click.stop="back" /></template>
            <template v-slot:center>认领详情</template>
            <template v-slot:right></template>
        </nav-bar>

        <scroll class="content" top="1" bottom="50" ref="scroll" style="padding: 0px 5px">
            <div class="main-box">
                <div class="info-bar">
                    <span class="title2">&nbsp;认领id：</span>
                    <span class="title3">{{claimId}}</span>
                </div>
                <div class="info-bar">
                    <span class="title2">&nbsp;招领信息：</span>
                    <span class="title3">{{lostFoundObj_title}}</span>
                </div>
                <div class="info-bar">
                    <span class="title2">&nbsp;认领人：</span>
                    <span class="title3">{{personName}}</span>
                </div>
                <div class="info-bar">
                    <span class="title2">&nbsp;认领时间：</span>
                    <span class="title3">{{claimTime}}</span>
                </div>
                <div class="info-bar">
                    <span class="title2">&nbsp;描述说明:</span>
                    <span class="desc" v-html="contents"> </span>
                </div>
                <div class="info-bar">
                    <span class="title2">&nbsp;发布时间：</span>
                    <span class="title3">{{addTime}}</span>
                </div>
            </div>
            <div style="margin: 16px;">
                <van-button round block type="info" native-type="submit" @click.stop="back">返回</van-button>
            </div>

        </scroll>
    </div>
</template>

<script>
    import NavBar from '../../components/common/navbar/NavBar'
    import Scroll from '../../components/common/scroll/Scroll'
    import { getClaim } from "../../network/Claim";

    export default {
        name: "ClaimDetail",
        components: {
            NavBar,
            Scroll,
        },
        data() {
            return {
                claimId: "", //认领id
                lostFoundObj_title: "", //招领信息
                personName: "", //认领人
                claimTime: "", //认领时间
                contents: "", //描述说明
                addTime: "", //发布时间
            }
        },
        created() {
            this.claimId = this.$route.params.claimId; //接收到的认领id
            //向后端请求单条认领记录
            getClaim(this.claimId).then(res => {
                var claim = res.data;
                this.lostFoundObj_title = claim.lostFoundObj.title;
                this.personName = claim.personName;
                this.claimTime = claim.claimTime;
                this.contents = claim.contents;
                this.addTime = claim.addTime;
            })
          document.getElementById("tabbar").style.display = "flex";
        },
        methods: {
            back() {
                this.$router.replace('/claim/list')
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

    .header {
        background-color: #fff;
        position: relative;
        padding: 0 15px;
        padding-bottom: 10px;
        overflow-x: scroll;
        box-shadow: 0 1px 6px rgba(0, 0, 0, .08);
    }

    .header p{
        margin-top: 40px;
        color: #3c3c3c;
        line-height: 25px;
        text-indent: 25px;
    }

    .main-box {
        background-color: #fff;
        margin: 10px 0;
        box-shadow: 0 1px 6px rgba(0, 0, 0, .08);
    }

    .info-bar {
        height: auto;
        border-bottom: 1px solid #f3f3f3;
        padding: 0 15px;
        display: block;
        clear:both;
    }

    .title2 {
        width:35%;
        line-height: 46px;
        font-weight: 600;
        font-family: 'icomoon';
    }

    .title3 {
        width: auto;
        height: 100%;
        text-align: right;
        line-height: 46px;
        color: #3c3c3c;
        float: right;
    }

    .desc {
        width: 100%;
        line-height: 25px;
        color: #3c3c3c;
        clear:both;
    }

    .avatar {
        width: 100px;
        height: 100px;
        background-color: #f3f3f3;
        border-radius: 3px;
    }
</style>
