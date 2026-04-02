# Windows 用户指南

本文档为 Windows 用户提供额外的安装和使用说明。

## 安装要求

- **操作系统**: Windows 10 或更高版本
- **Python**: 3.10 或更高版本
- **网络**: 需要访问互联网（使用公共服务时）

## 安装步骤

### 1. 检查 Python 安装

打开命令提示符（CMD）或 PowerShell，运行：

```batch
python --version
```

如果显示版本号且 ≥ 3.10，则 Python 已正确安装。如果未安装：

- 访问 [Python 官网](https://www.python.org/downloads/) 下载安装程序
- 安装时务必勾选 **"Add Python to PATH"**

### 2. 运行安装脚本

在项目根目录下运行：

**命令提示符 (CMD):**
```batch
scripts\setup.bat
```

**PowerShell:**
```powershell
& scripts\setup.bat
```

**Git Bash (如果已安装):**
```bash
bash scripts/setup.sh
```

### 3. 验证安装

运行测试脚本：

```batch
scripts\test-setup.bat
```

或手动验证：

```batch
doc-search --help
```

## 常见问题

### Q: "python" 不是内部或外部命令

**原因**: Python 未添加到系统 PATH

**解决方案**:
1. 重新安装 Python，勾选 "Add Python to PATH"
2. 或使用 Python Launcher: `py -3` 代替 `python`
3. 或手动添加 Python 目录到 PATH 环境变量

### Q: "doc-search" 命令找不到

**原因**: Python Scripts 目录未在 PATH 中

**解决方案**:
1. 找到 Python Scripts 目录（通常在 `C:\Users\<用户名>\AppData\Local\Programs\Python\Python3x\Scripts\`）
2. 将该目录添加到系统 PATH
3. 或使用完整路径运行

### Q: 安装失败提示权限错误

**原因**: 权限不足

**解决方案**:
- 以管理员身份运行命令提示符
- 或使用 `--user` 标志安装: `python -m pip install --user -e scripts\doc-search[all]`

### Q: pip 安装速度很慢

**原因**: 默认使用国外 PyPI 源

**解决方案**: 使用国内镜像源

```batch
python -m pip install -e scripts\doc-search[all] -i https://pypi.tuna.tsinghua.edu.cn/simple
```

### Q: 网络连接失败

**原因**: 防火墙或代理设置

**解决方案**:
- 检查防火墙设置，允许 Python 访问网络
- 如使用代理，设置环境变量:
  ```batch
  set HTTP_PROXY=http://proxy-server:port
  set HTTPS_PROXY=http://proxy-server:port
  ```

## 配置说明

### 使用默认公共服务（推荐）

安装后无需额外配置，直接使用：

```batch
doc-search init --doc_path "your_file.pdf"
```

默认使用公共 MinerU 服务器，无需 API key。

### 配置 PageIndex（可选）

如需为扫描文档或无书签文档自动生成目录：

1. 编辑 `scripts\doc-search\config.yaml`
2. 设置以下字段：

```yaml
pageindex_model: "gpt-4.1-mini"  # 或 gpt-4o-2024-11-20
pageindex_api_key: "sk-your-key-here"
pageindex_base_url: "https://api.openai.com/v1"  # 必须包含 /v1
```

**注意**: 不配置 PageIndex 不影响其他功能使用。

## 使用示例

### 初始化文档

```batch
doc-search init --doc_path "test.pdf"
```

对于大文档（>40页）：
```batch
doc-search init --doc_path "large_document.pdf" --lazy_ocr
```

### 查看文档大纲

```batch
doc-search outline --doc_id "your_doc_id"
```

### 搜索内容

**语义搜索:**
```batch
doc-search search-semantic --doc_id "your_doc_id" --page_idxs "" --query "实验结果" --top_k 3
```

**关键词搜索:**
```batch
doc-search search-keyword --doc_id "your_doc_id" --page_idxs "" --pattern "表格"
```

### 读取页面

```batch
doc-search pages --doc_id "your_doc_id" --page_idxs "0,1,2" --return_text
```

### 提取元素

```batch
doc-search --timeout 300 elements --doc_id "your_doc_id" --page_idxs "5" --query "性能对比表格"
```

## PowerShell 用户注意事项

在 PowerShell 中：

- 使用 `&` 运算符执行 .bat 文件: `& scripts\setup.bat`
- 路径中的反斜杠 `\` 或正斜杠 `/` 都可以
- 字符串可以使用单引号或双引号

## 卸载

如需卸载：

```batch
python -m pip uninstall mineru-document-explorer
```

手动删除：
- 项目目录
- Python Scripts 中的 `doc-search.exe`（如果存在）

## 获取帮助

- 查看命令帮助: `doc-search --help`
- 查看子命令帮助: `doc-search init --help`
- 项目文档: `references\` 目录下的各个 .md 文件
