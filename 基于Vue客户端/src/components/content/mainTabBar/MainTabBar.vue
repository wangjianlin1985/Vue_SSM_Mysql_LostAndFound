<template>  <tab-bar>
    <tab-bar-item v-for="(item,index) in tab" :key="index" :icon="item.icon" :path="item.path" activeColor="#4fc08d" deActiveColor="#999">
      <template v-slot:name>{{item.title}}</template>
    </tab-bar-item>
  </tab-bar>
</template>

<script>
import TabBar from '../../../components/common/tabbar/TabBar'
import TabBarItem from '../../../components/common/tabbar/TabBarItem'
export default {
  name: 'CustomerTabBar',
  components: {
    TabBar,
    TabBarItem
  },
  data() {
    return {
      tab: [{
        icon: '&#xe902;',
        title: '首页',
        path: '/home'
      },
      {
        icon: '&#xe907;',
        title: '失物信息',
        path: '/lookingFor/list',
      },
      {
        icon: '&#xe920;',
          title: '招领信息',
          path: '/lostFound/list'
      },
      {
        icon: '&#xe903;',
        title: '个人中心',
        path: '/profile'
      }]
    }
  }
}
</script>

<style scoped>


</style>
