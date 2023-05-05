//前端路由代码
import Vue from 'vue'
import Router from 'vue-router'
Vue.use(Router)

/**
 * 重写路由的push方法
 */
// const routerPush = Router.prototype.push
// Router.prototype.push = function push(location) {
//     return routerPush.call(this, location).catch(error => error)
// }

const Home = () => import ('../views/home/Home') //引入首页组件页
const UserInfoList = () => import('../views/userInfo/UserInfoList.vue') //引入用户列表组件页
const UserInfoAdd = () => import('../views/userInfo/UserInfoAdd') //引入用户添加组件页
const UserInfoModify = () => import('../views/userInfo/UserInfoModify') //引入用户修改组件页
const UserInfoSelfModify = () => import('../views/userInfo/UserInfoSelfModify') //引入用户修改组件页
const UserInfoDetail = () => import('../views/userInfo/UserInfoDetail') //引入用户详情组件页

const AreaList = () => import('../views/area/AreaList.vue') //引入学院列表组件页
const AreaAdd = () => import('../views/area/AreaAdd') //引入学院添加组件页
const AreaModify = () => import('../views/area/AreaModify') //引入学院修改组件页
const AreaDetail = () => import('../views/area/AreaDetail') //引入学院详情组件页

const LookingForList = () => import('../views/lookingFor/LookingForList.vue') //引入寻物启事列表组件页
const LookingForUserList = () => import('../views/lookingFor/LookingForUserList.vue') //引入寻物启事列表组件页
const LookingForAdd = () => import('../views/lookingFor/LookingForAdd') //引入寻物启事添加组件页
const LookingForModify = () => import('../views/lookingFor/LookingForModify') //引入寻物启事修改组件页
const LookingForDetail = () => import('../views/lookingFor/LookingForDetail') //引入寻物启事详情组件页

const LostFoundList = () => import('../views/lostFound/LostFoundList.vue') //引入失物招领列表组件页
const LostFoundUserList = () => import('../views/lostFound/LostFoundUserList.vue') //引入失物招领列表组件页
const LostFoundAdd = () => import('../views/lostFound/LostFoundAdd') //引入失物招领添加组件页
const LostFoundModify = () => import('../views/lostFound/LostFoundModify') //引入失物招领修改组件页
const LostFoundDetail = () => import('../views/lostFound/LostFoundDetail') //引入失物招领详情组件页

const ClaimList = () => import('../views/claim/ClaimList.vue') //引入认领列表组件页
const ClaimAdd = () => import('../views/claim/ClaimAdd') //引入认领添加组件页
const ClaimModify = () => import('../views/claim/ClaimModify') //引入认领修改组件页
const ClaimDetail = () => import('../views/claim/ClaimDetail') //引入认领详情组件页

const PraiseList = () => import('../views/praise/PraiseList.vue') //引入表扬列表组件页
const PraiseAdd = () => import('../views/praise/PraiseAdd') //引入表扬添加组件页
const PraiseModify = () => import('../views/praise/PraiseModify') //引入表扬修改组件页
const PraiseDetail = () => import('../views/praise/PraiseDetail') //引入表扬详情组件页

const NoticeList = () => import('../views/notice/NoticeList.vue') //引入站内通知列表组件页
const NoticeAdd = () => import('../views/notice/NoticeAdd') //引入站内通知添加组件页
const NoticeModify = () => import('../views/notice/NoticeModify') //引入站内通知修改组件页
const NoticeDetail = () => import('../views/notice/NoticeDetail') //引入站内通知详情组件页

const Profile = () => import ('../views/profile/Profile') //引入个人中心组件页
const Login = () => import ('../views/login/Login') //引入登录组件页
const CreateAccount = () => import ('../views/login/CreateAccount') //引入创建账号组件页
const Coupon = () => import ('../views/profile/CouponExchange') //引入优惠卷组件页
const About = () => import ('../views/profile/About') //引入关于我们组件页

const routes = [{
    path: '',  // 根路径跳到登录页路由
    redirect: '/login'
  },
  {
    path: '/login', // 系统登录页路由
    component: Login
  },
  {
    path: '/register', // 创建新账号页路由
    component: CreateAccount
  },
  {
    path: '/home',   // 首页路由
    component: Home
  },

  {
    path: '/userInfo/add', // 添加用户页路由
    component: UserInfoAdd
  },
  {
    path: '/userInfo/modify/:user_name', // 修改用户页路由
    component: UserInfoModify
  },
  {
    path: '/userInfo/selfModify', // 修改用户页路由
    component: UserInfoSelfModify
  },
  {
    path: '/userInfo/list', // 用户查询页路由
    component: UserInfoList
  },
  {
    path: '/userInfo/detail/:user_name', // 用户详情页路由
    component: UserInfoDetail
  },
  {
    path: '/area/add', // 添加学院页路由
    component: AreaAdd
  },
  {
    path: '/area/modify/:areaId', // 修改学院页路由
    component: AreaModify
  },
  {
    path: '/area/list', // 学院查询页路由
    component: AreaList
  },
  {
    path: '/area/detail/:areaId', // 学院详情页路由
    component: AreaDetail
  },
  {
    path: '/lookingFor/add', // 添加寻物启事页路由
    component: LookingForAdd
  },
  {
    path: '/lookingFor/modify/:lookingForId', // 修改寻物启事页路由
    component: LookingForModify
  },
  {
    path: '/lookingFor/list', // 寻物启事查询页路由
    component: LookingForList
  },
  {
    path: '/lookingFor/userList', // 寻物启事查询页路由
    component: LookingForUserList
  },
  {
    path: '/lookingFor/detail/:lookingForId', // 寻物启事详情页路由
    component: LookingForDetail
  },
  {
    path: '/lostFound/add', // 添加失物招领页路由
    component: LostFoundAdd
  },
  {
    path: '/lostFound/modify/:lostFoundId', // 修改失物招领页路由
    component: LostFoundModify
  },
  {
    path: '/lostFound/list', // 失物招领查询页路由
    component: LostFoundList
  },
  {
    path: '/lostFound/userList', // 失物招领查询页路由
    component: LostFoundUserList
  },
  {
    path: '/lostFound/detail/:lostFoundId', // 失物招领详情页路由
    component: LostFoundDetail
  },
  {
    path: '/claim/add', // 添加认领页路由
    component: ClaimAdd
  },
  {
    path: '/claim/modify/:claimId', // 修改认领页路由
    component: ClaimModify
  },
  {
    path: '/claim/list', // 认领查询页路由
    component: ClaimList
  },
  {
    path: '/claim/detail/:claimId', // 认领详情页路由
    component: ClaimDetail
  },
  {
    path: '/praise/add', // 添加表扬页路由
    component: PraiseAdd
  },
  {
    path: '/praise/modify/:praiseId', // 修改表扬页路由
    component: PraiseModify
  },
  {
    path: '/praise/list', // 表扬查询页路由
    component: PraiseList
  },
  {
    path: '/praise/detail/:praiseId', // 表扬详情页路由
    component: PraiseDetail
  },
  {
    path: '/notice/add', // 添加站内通知页路由
    component: NoticeAdd
  },
  {
    path: '/notice/modify/:noticeId', // 修改站内通知页路由
    component: NoticeModify
  },
  {
    path: '/notice/list', // 站内通知查询页路由
    component: NoticeList
  },
  {
    path: '/notice/detail/:noticeId', // 站内通知详情页路由
    component: NoticeDetail
  },

  {
    path: '/Profile', // 个人中心页路由
    component: Profile,
  },
  {
    path: '/about', //关于我们页路由
    component: About
  },
  {
    path: '/coupon', // 优惠卷页路由
    component: Coupon
  }
]

const router = new Router({
  routes,
  mode: 'history'
})

export default router

