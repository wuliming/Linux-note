
csv2xls使用方法
================

1) 将csv2xls.tar.gz拷贝到Linux系统中，解包
# tar zxvf csv2xls.tar.gz
# cd csv2xls

2）首先需要安装xlwt这个python的库
安装方法1（有网络）：
# pip install xlwt

安装方法2（无网络）
# cd xlwt_install
# tar zxvf xlwt-1.3.0.tar.gz
# cd xlwt-1.3.0
# python setup.py install

3）将csv2xls.py脚本拷贝到需要转换的csv文件同目录下，并执行
例：
# cp csv2xls.py test/
# cd test
# python csv2xls.py

4）检查结果
运行结束后，会在当前目录生成一个名为output.xls的Excel文件，
# ls *.xls
output.xls

该文件包含当前目录下所有csv文件，每个csv为一个sheet, sheet名就是csv文件名。
将生成的xls文件拷贝到Windows下，双击打开即可。



-----------
2017/12/19
FNST

