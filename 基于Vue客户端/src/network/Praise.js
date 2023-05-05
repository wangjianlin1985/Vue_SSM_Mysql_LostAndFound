// 表扬信息业务处理
import request from './request'
import qs from 'qs'

/* 根据查询条件分页查询表扬信息 */
export function queryPraise(lostFoundObj_lostFoundId, title, addTime, page) {
    return request({
        url: '/praise/list',
        method: "POST",
        params: {
            "lostFoundObj.lostFoundId": lostFoundObj_lostFoundId,
            "title": title,
            "addTime": addTime,
            "page": page,
            "rows": 10
        }
    })
}

/* 查询所有的表扬信息*/
export function queryAllPraise() {
    return request({
        url: '/praise/listAll',
        method: "POST",
    })
}

/* 添加表扬信息 */
export function addPraise(praise) {
    return request({
        url: '/praise/add',
        method: "POST",
        data: qs.stringify(praise),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 更新表扬信息 */
export function updatePraise(praise) {
    return request({
        url: '/praise/update',
        method: "POST",
        data: qs.stringify(praise),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 根据主键表扬id查询表扬信息 */
export function getPraise(praiseId) {
    return request({
        url: '/praise/get/' + praiseId,
        method: "POST"
    })
}

/* 根据主键praiseId删除表扬 */
export function deletePraise(praiseId) {
    return request({
        url: '/praise/delete/' + praiseId,
        method: "POST",
    })
}
