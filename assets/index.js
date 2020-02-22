#!node

const fs = require('fs');
const path = require('path');

let arr = [];

const basename = path.basename(__dirname);

/**
 * 
 * @param name 
 * @description 下划线转驼峰 a_ab_cd =>aAbCd
 */
function camelName(name) {
    if (name.indexOf('_') > -1) {
        let strArr = name.split('_');
        strArr.forEach((str, index) => {
            if (index === 0) {
                strArr[index] = str.toLowerCase();
            } else {
                strArr[index] = str.substring(0, 1).toUpperCase() + str.substring(1);
            }
        }) 
        return strArr.join('');
    } else {
        return name.substring(0, 1).toLowerCase() + name.substring(1);
    }
}

/**
 * 
 * @param fileName 文件名
 * @param dirpath 文件所属的文件夹地址
 */

function readFile(fileName, dirpath) {
    if (fileName === 'index.js') {
        return;
    }
    const filePath = path.join(dirpath, fileName);
    const fileStats =  fs.statSync(filePath)
    if (fileStats.isFile()) {
        
        let name = fileName.substring(0, fileName.lastIndexOf('.'));
        let url = filePath.substring(filePath.indexOf(basename));
        arr.push(`static String ${camelName(name)} = '${url}';\n\t`)
        
    } else {
        readDir(filePath);
    }
}

function readDir(dirName) {
    let fileNames =  fs.readdirSync(dirName, {encoding: 'utf-8'});
    fileNames.forEach(fileName => {
        readFile(fileName, dirName)
    })    
}


readDir(__dirname);

let dartClass = 'class Images {\n\t'
arr.forEach(r => {
    dartClass += r;
})
dartClass += '\n}'


fs.writeFileSync(__dirname + '/Images.dart', dartClass.replace(/\\/g, '/'));
