// 认领信息业务处理
import request from './request'
import qs from 'qs'

/* 根据查询条件分页查询认领信息 */
export function queryClaim(lostFoundObj_lostFoundId, personName, claimTime, page) {
    return request({
        url: '/claim/list',
        method: "POST",
        params: {
            "lostFoundObj.lostFoundId": lostFoundObj_lostFoundId,
            "personName": personName,
            "claimTime": claimTime,
            "page": page,
            "rows": 10
        }
    })
}

/* 查询所有的认领信息*/
export function queryAllClaim() {
    return request({
        url: '/claim/listAll',
        method: "POST",
    })
}

/* 添加认领信息 */
export function addClaim(claim) {
    return request({
        url: '/claim/add',
        method: "POST",
        data: qs.stringify(claim),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 更新认领信息 */
export function updateClaim(claim) {
    return request({
        url: '/claim/update',
        method: "POST",
        data: qs.stringify(claim),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 根据主键认领id查询认领信息 */
export function getClaim(claimId) {
    return request({
        url: '/claim/get/' + claimId,
        method: "POST"
    })
}

/* 根据主键claimId删除认领 */
export function deleteClaim(claimId) {
    return request({
        url: '/claim/delete/' + claimId,
        method: "POST",
    })
}
