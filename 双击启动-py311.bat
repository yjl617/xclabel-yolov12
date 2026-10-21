@echo off
CHCP 65001 >nul
cd /d "%~dp0"

REM ===== 1. 激活 conda 环境 py311 =====
call conda activate py311
if errorlevel 1 (
  echo [错误] conda activate py311 失败，请确认已安装 Anaconda/Miniconda 且存在 py311 环境
  echo 可用环境列表如下：
  call conda env list
  pause
  exit /b 1
)

echo 当前 Python: 
python --version
where python

REM ===== 2. 首次运行自动安装 yolov12 本地包 =====
python -c "import ultralytics" >nul 2>&1
if errorlevel 1 (
  echo 初次运行，正在安装 yolov12，请耐心等待...
  pip install -e yolov12 --no-build-isolation
)

REM ===== 3. 拷贝中文字体（和原版逻辑一致）=====
set "ttf_source=default\Arial.ttf"
set "ttf_destination=%APPDATA%\yolov12\Arial.ttf"
if not exist "%ttf_destination%" (
  mkdir "%APPDATA%\yolov12" >nul 2>&1
  copy "%ttf_source%" "%ttf_destination%" /Y >nul 2>&1
)

REM ===== 4. 启动 Django =====
echo 正在启动服务 http://127.0.0.1:9924 ...
python manage.py runserver 0.0.0.0:9924

pause
