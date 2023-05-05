// 学院信息业务处理
import request from './request'
import qs from 'qs'

/* 根据查询条件分页查询学院信息 */
export function queryArea(page) {
    return request({
        url: '/area/list',
        method: "POST",
        params: {
            "page": page,
            "rows": 10
        }
    })
}

/* 查询所有的学院信息*/
export function queryAllArea() {
    return request({
        url: '/area/listAll',
        method: "POST",
    })
}

/* 添加学院信息 */
export function addArea(area) {
    return request({
        url: '/area/add',
        method: "POST",
        data: qs.stringify(area),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 更新学院信息 */
export function updateArea(area) {
    return request({
        url: '/area/update',
        method: "POST",
        data: qs.stringify(area),
        headers: { //添加请求头
            'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8'
        }
    })
}

/* 根据主键学院id查询学院信息 */
export function getArea(areaId) {
    return request({
        url: '/area/get/' + areaId,
        method: "POST"
    })
}

/* 根据主键areaId删除学院 */
export function deleteArea(areaId) {
    return request({
        url: '/area/delete/' + areaId,
        method: "POST",
    })
}
