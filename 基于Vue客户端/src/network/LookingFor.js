// 寻物启事信息业务处理
import request from './request'
import qs from 'qs'

/* 根据查询条件分页查询寻物启事信息 */
export function queryLookingFor(title, goodsName, lostTime, lostPlace, telephone, userObj_user_name, page) {
    return request({
        url: '/lookingFor/list',
        method: "POST",
        params: {
            "title": title,
            "goodsName": goodsName,
            "lostTime": lostTime,
            "lostPlace": lostPlace,
            "telephone": telephone,
            "userObj.user_name": userObj_user_name,
            "page": page,
            "rows": 10
        }
    })
}



/* 根据查询条件分页查询寻物启事信息 */
export function userQueryLookingFor(title, goodsName, lostTime, lostPlace, telephone, page) {
    return request({
        url: '/lookingFor/userList',
        method: "POST",
        params: {
            "title": title,
            "goodsName": goodsName,
            "lostTime": lostTime,
            "lostPlace": lostPlace,
            "telephone": telephone,
            "page": page,
            "rows": 10
        }
    })
}


/* 查询所有的寻物启事信息*/
export function queryAllLookingFor() {
    return request({
        url: '/lookingFor/listAll',
        method: "POST",
    })
}

/* 添加寻物启事信息 */
export function addLookingFor(lookingFor) {
    return request({
        url: '/lookingFor/add',
        method: "POST",
        data: qs.stringify(lookingFor),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 更新寻物启事信息 */
export function updateLookingFor(lookingFor) {
    return request({
        url: '/lookingFor/update',
        method: "POST",
        data: qs.stringify(lookingFor),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 根据主键寻物id查询寻物启事信息 */
export function getLookingFor(lookingForId) {
    return request({
        url: '/lookingFor/get/' + lookingForId,
        method: "POST"
    })
}

/* 根据主键lookingForId删除寻物启事 */
export function deleteLookingFor(lookingForId) {
    return request({
        url: '/lookingFor/delete/' + lookingForId,
        method: "POST",
    })
}
