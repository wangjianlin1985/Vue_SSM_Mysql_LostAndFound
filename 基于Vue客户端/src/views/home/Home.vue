<template>
  <div class="home">
    <div class="bgc"></div>
    <location :locationInfo="locationInfo"></location>
    <!--<scroll  class="content" ref="scroll" top="66" >-->
    <scroll class="content" top="1" bottom="50" ref="scroll" :isPullDown="true" @pullingDown="pullingDown" :isPullUp="true" @pullingUp="pullingUp" >
      <div class="ignore-pull-down1" ref="pull" v-show="pullFlag">下拉更新</div>
      <div class="ignore-pull-down2" ref="pull" v-show="!pullFlag">
        <span class="ball1"></span><span class="ball2"></span><span class="ball3"></span>
      </div>
      <home-swiper></home-swiper>

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
          </div>
        </template>
      </div>
      <div class="block"></div>

    </scroll>
  </div>
</template>

<script>
import Scroll from '../../components/common/scroll/Scroll'

import Location from './childComps/Location'
import HomeSwiper from './childComps/HomeSwiper'

import { getShop } from '../../network/home'
import {getLocation, getDistance} from '../../common/utils'
import {queryPraise,deletePraise} from '../../network/Praise'

export default {
  name: 'Home',
  components: {
    Scroll,
    Location,
    HomeSwiper
  },
  data() {
    return {
      praiseList: [],  //界面需要展示的表扬列表数据
      page: 1, //默认显示结果第1页
      pullFlag: true,  //是否允许下拉刷新标志
      storeList: [],
      locationInfo: "定位中...",
      sticky: false,
      position: {lng: 0, lat: 0}
    }
  },
  created() {
    this.$toast.loading()
    this.getLocation()
  },
  methods: {
    getShop() {
      getShop().then(ret => {
        let data = ret.data
        for(let i in data) {
          data[i].distance = getDistance(data[i].lng, data[i].lat, this.position.lng, this.position.lat)
        }
        function compare(property){
          return function(a,b){
            var value1 = a[property];
            var value2 = b[property];
            return value1 - value2;
          }
        }
        data.sort(compare('distance'))
        this.storeList = data
      })
    },
    getLocation() {
      //等待 1000ms 
      new Promise((resolve, reject) => {
        let timer = setTimeout(() => {
          reject()
        },3000)
        getLocation(ret => {
          console.log('定位信息', ret)
          if(ret) {
            let address = ret.formattedAddress
            address = address.replace(ret.addressComponent.province,"")
            address = address.replace(ret.addressComponent.city,"")
            address = address.replace(ret.addressComponent.district,"")
            address = address.replace(ret.addressComponent.township,"")
            address = address.replace(ret.addressComponent.streetNumber,"")
            this.locationInfo = address
            this.position.lng = ret.position.lng
            this.position.lat = ret.position.lat
          }
          this.$toast.hide()
          clearTimeout(timer)
          resolve()
          // this.$bus.$emit('aflocation')
        })
      }).then(() => {
        this.$toast.hide()
      }).catch(() => {
        this.locationInfo = "设备不支持定位"
        this.$toast.hide()
        // this.$bus.$emit('aflocation')
      })

      //获取表扬信息
      this.praiseQuery("");
    },

    praiseDetailClick(praiseId) {
      this.$router.push('/praise/detail/' + praiseId); //跳转到表扬详情页
    },


    praiseQuery(action) {
      queryPraise(0,"","",this.page).then(res => {
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

  },
  activated() {
    this.$refs.scroll.refresh()
  }

}
</script>

<style scoped>
  @import "../../assets/css/list_base.css";
  @import "../praise/PraiseList.css";
.home {
  width: 100vw;
  height: 100vh;
  position: relative;
  background-color: #54bf8e;
  background-size: 100%;
}
.content {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 49px;
}
.bgc {
  width: 375px;
  height: 170px;
  /*background: url(~assets/images/homebg.png) no-repeat;*/
  background-size: 100%;
  position: fixed;
  top: 0;
}

</style>