#!/usr/bin/env python

import os
import glob
import csv
import xlwt

def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        pass
 
    try:
        import unicodedata
        unicodedata.numeric(s)
        return True
    except (TypeError, ValueError):
        pass
 
    return False

wb = xlwt.Workbook()
for csvfile in glob.glob(os.path.join('.', '*.csv')):
	fpath = csvfile.split("/", 1)
	fname = fpath[1].split(".", 1) ##fname[0] should be our worksheet name

	ws = wb.add_sheet(fname[0])
	with open(csvfile, 'rb') as f:
		reader = csv.reader(f)
		for r, row in enumerate(reader):
			for c, col in enumerate(row):
				if is_number(col):
					col = float(col)
				ws.write(r, c, col)
wb.save('output.xls')
