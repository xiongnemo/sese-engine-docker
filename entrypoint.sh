#!/bin/sh
cd /code/
python 人服务器.py &
python 上网.py &
python 回.py &
while true; do python 收获服务器.py; done
