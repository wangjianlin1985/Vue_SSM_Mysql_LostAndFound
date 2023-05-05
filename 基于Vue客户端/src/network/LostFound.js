// 失物招领信息业务处理
import request from './request'
import qs from 'qs'

/* 根据查询条件分页查询失物招领信息 */
export function queryLostFound(title, goodsName, pickUpTime, pickUpPlace, connectPerson, phone, userObj_user_name, page) {
    return request({
        url: '/lostFound/list',
        method: "POST",
        params: {
            "title": title,
            "goodsName": goodsName,
            "pickUpTime": pickUpTime,
            "pickUpPlace": pickUpPlace,
            "connectPerson": connectPerson,
            "phone": phone,
            "userObj.user_name": userObj_user_name,
            "page": page,
            "rows": 10
        }
    })
}


/* 根据查询条件分页查询失物招领信息 */
export function userQueryLostFound(title, goodsName, pickUpTime, pickUpPlace, connectPerson, phone, page) {
    return request({
        url: '/lostFound/userList',
        method: "POST",
        params: {
            "title": title,
            "goodsName": goodsName,
            "pickUpTime": pickUpTime,
            "pickUpPlace": pickUpPlace,
            "connectPerson": connectPerson,
            "phone": phone,
            "page": page,
            "rows": 10
        }
    })
}



/* 查询所有的失物招领信息*/
export function queryAllLostFound() {
    return request({
        url: '/lostFound/listAll',
        method: "POST",
    })
}

/* 添加失物招领信息 */
export function addLostFound(lostFound) {
    return request({
        url: '/lostFound/add',
        method: "POST",
        data: qs.stringify(lostFound),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 更新失物招领信息 */
export function updateLostFound(lostFound) {
    return request({
        url: '/lostFound/update',
        method: "POST",
        data: qs.stringify(lostFound),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 根据主键招领id查询失物招领信息 */
export function getLostFound(lostFoundId) {
    return request({
        url: '/lostFound/get/' + lostFoundId,
        method: "POST"
    })
}

/* 根据主键lostFoundId删除失物招领 */
export function deleteLostFound(lostFoundId) {
    return request({
        url: '/lostFound/delete/' + lostFoundId,
        method: "POST",
    })
}
