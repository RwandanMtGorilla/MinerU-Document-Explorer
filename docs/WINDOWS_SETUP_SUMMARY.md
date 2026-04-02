# Windows 支持更新说明

本次更新为 MinerU Document Explorer 添加了完整的 Windows 平台支持。

## 更新内容

### 1. 新增文件

#### 安装脚本
- **`scripts/setup.bat`** - Windows 批处理安装脚本
  - 自动检测 Python 3.10+ 环境
  - 安装所有依赖包
  - 验证 CLI 工具可用性
  - 生成配置文件

- **`scripts/test-setup.bat`** - 安装验证脚本
  - 快速检查安装是否成功
  - 提供下一步操作指引

#### 文档
- **`docs/WINDOWS.md`** - Windows 用户详细指南
  - 完整的安装步骤
  - 常见问题解答
  - 使用示例
  - 故障排除

### 2. 修改文件

#### `.gitattributes`
- 添加了跨平台换行符配置
- `.sh` 和 `.py` 文件强制使用 LF
- `.bat` 和 `.cmd` 文件使用 CRLF
- 确保跨平台一致性

#### `references/setup.md`
- 添加 Windows 安装说明
- 区分 Linux/macOS 和 Windows 的安装命令

#### `README.md` / `README_ZH.md`
- 添加 Windows 安装部分
- 链接到详细文档

## 技术细节

### setup.bat 实现要点

1. **Python 版本检测**
   - 优先使用 `py` Launcher（Windows 推荐）
   - 回退到 `python` 和 `python3` 命令
   - 验证版本 ≥ 3.10

2. **路径处理**
   - 使用 `%~dp0` 获取脚本目录
   - 处理 Windows 路径分隔符
   - 使用 `cd /d` 切换驱动器

3. **依赖安装**
   - 使用 `pip install -e scripts\doc-search[all]`
   - 支持所有可选依赖

4. **配置文件生成**
   - 使用 Python 内嵌 JSON 生成（跨平台可靠）
   - 避免复杂的批处理字符串转义

5. **彩色输出**
   - 使用 ANSI 转义码（Windows 10+ 支持）
   - 兼容旧版 CMD（显示原始代码）

### 跨平台兼容性保证

所有依赖包验证：
- ✅ `mineru-open-sdk` - 纯 Python，跨平台
- ✅ `pymupdf` - 提供 Windows wheels
- ✅ `faiss-cpu` - 提供 Windows wheels
- ✅ 其他依赖均为纯 Python

## 测试建议

### 在纯净 Windows 环境测试

1. **Windows 10/11 + Python 3.10-3.13**
   ```batch
   scripts\setup.bat
   scripts\test-setup.bat
   doc-search init --doc_path test.pdf --lazy_ocr
   ```

2. **验证功能**
   - [ ] 安装成功
   - [ ] `doc-search` 命令可用
   - [ ] 可以初始化 PDF
   - [ ] 基本命令可以运行

### 在 Linux/macOS 测试

确保修改未破坏原有功能：
```bash
bash scripts/setup.sh
```

## 已知限制

1. **命令行输出**
   - 彩色 ANSI 码在旧版 Windows CMD 中会显示为乱码
   - 建议 Windows 10+ 或使用 Windows Terminal

2. **路径长度**
   - Windows 有 260 字符路径限制
   - 如遇到问题，启用长路径支持或使用短路径

3. **防火墙**
   - 首次运行可能需要允许 Python 访问网络
   - 依赖远程服务器时需要网络连接

## 后续改进建议

1. **添加 CI/CD 测试**
   - 在 GitHub Actions 中添加 Windows 测试
   - 自动化验证跨平台兼容性

2. **创建 Windows 安装包**
   - 使用 Inno Setup 或 NSIS 创建安装程序
   - 自动处理 Python 依赖

3. **添加 PowerShell 模块**
   - 提供更友好的 PowerShell 接口
   - 支持命令补全

## 相关文件清单

```
MinerU-Document-Explorer/
├── scripts/
│   ├── setup.sh              (原有)
│   ├── setup.bat             (新增)
│   └── test-setup.bat        (新增)
├── docs/
│   └── WINDOWS.md            (新增)
├── .gitattributes            (更新)
├── README.md                 (更新)
├── README_ZH.md              (更新)
└── references/
    └── setup.md              (更新)
```

## 使用方式

### Windows 用户

```batch
# 1. 安装
scripts\setup.bat

# 2. 验证
scripts\test-setup.bat

# 3. 使用
doc-search init --doc_path "your_file.pdf"
```

### Linux/macOS 用户

```bash
# 1. 安装
bash scripts/setup.sh

# 2. 使用
doc-search init --doc_path "your_file.pdf"
```

---

**更新时间**: 2026-03-31
**测试状态**: 待测试
**兼容性**: Windows 10+, Python 3.10+
