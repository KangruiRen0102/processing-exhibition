const fs = require('fs');
const path = require('path');

const codeDir = './code'; // 原始 .pde 文件所在目录
const outputDir = './output'; // 输出文件夹

// 创建输出目录（如果不存在）
if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
}

// 遍历所有 .pde 文件
fs.readdirSync(codeDir).forEach(file => {
    if (file.endsWith('.pde')) {
        const fileName = path.basename(file, '.pde');
        const newFolder = path.join(outputDir, fileName);
        const sourceFile = path.join(codeDir, file);

        // 创建文件夹
        if (!fs.existsSync(newFolder)) {
            fs.mkdirSync(newFolder);
        }

        // 复制文件到新文件夹
        const destFile = path.join(newFolder, file);
        fs.copyFileSync(sourceFile, destFile);

        console.log(`Copied ${file} to ${newFolder}`);
    }
});
