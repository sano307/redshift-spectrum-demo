import os
import sys

from fastparquet import ParquetFile, write
import pandas as pd


PARQUET_FILE_PATH = '../data/sample.parq'

if os.path.isfile(PARQUET_FILE_PATH):
    os.remove(PARQUET_FILE_PATH)

data = [
  {'year': 2014, 'make': "toyota", 'model':"corolla"},
  {'year': 2017, 'make': "nissan" ,'model':"sentra"}, 
  {'year': 2018, 'make': "honda", 'model':"civic"}, 
  {'year': 2020, 'make': "hyndai", 'model':"nissan"}
]

df = pd.DataFrame(data)
write(PARQUET_FILE_PATH, df)
pf = ParquetFile(PARQUET_FILE_PATH)
print(pf.to_pandas())
