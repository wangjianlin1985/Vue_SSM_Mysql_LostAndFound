// 用户信息业务处理
import request from './request'
import qs from 'qs'

/* 根据查询条件分页查询用户信息 */
export function queryUserInfo(user_name, areaObj_areaId, name, birthday, telephone, regTime, page) {
    return request({
        url: '/userInfo/list',
        method: "POST",
        params: {
            "user_name": user_name,
            "areaObj.areaId": areaObj_areaId,
            "name": name,
            "birthday": birthday,
            "telephone": telephone,
            "regTime": regTime,
            "page": page,
            "rows": 10
        }
    })
}

/* 查询所有的用户信息*/
export function queryAllUserInfo() {
    return request({
        url: '/userInfo/listAll',
        method: "POST",
    })
}

/* 添加用户信息 */
export function addUserInfo(userInfo) {
    return request({
        url: '/userInfo/add',
        method: "POST",
        data: qs.stringify(userInfo),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 更新用户信息 */
export function updateUserInfo(userInfo) {
    return request({
        url: '/userInfo/update',
        method: "POST",
        data: qs.stringify(userInfo),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 根据主键手机账号查询用户信息 */
export function getUserInfo(user_name) {
    return request({
        url: '/userInfo/get/' + user_name,
        method: "POST"
    })
}

/* 查询用户个人信息 */
export function getSelfUserInfo() {
    return request({
        url: '/userInfo/selfGet',
        method: "POST"
    })
}



/* 根据主键user_name删除用户 */
export function deleteUserInfo(user_name) {
    return request({
        url: '/userInfo/delete/' + user_name,
        method: "POST",
    })
}
