#!/bin/sh

SAR_FILE=$1
OUT_FILE=$2
BASE_DIR=`pwd`
CSV2XLS_DIR=${BASE_DIR}/csv2xls
XLWT_DIR=${BASE_DIR}/csv2xls/xlwt_install/xlwt-1.3.0

TIME=`date +%m%d%H%M%S`

echo "sar to csv"
./sar2csv.sh $SAR_FILE $OUT_FILE

cd $XLWT_DIR
python setup.py install
 
cd $BASE_DIR
cp $CSV2XLS_DIR/csv2xls.py $OUT_FILE 

echo "csv to excel"
cd $BASE_DIR
cd $OUT_FILE
python csv2xls.py

mv output.xls output_$TIME.xls
mkdir -p csv_file
mv *.csv csv_file/ 
rm -rf csv2xls.py
cd  $BASE_DIR

echo "end"
