#!/usr/bin/python

import os
import glob
import sys
import errno
import re
from _ast import Str
import shutil

''' python script for data file validation taking parameter as SOURCE(file location ) from command line '''

# define by user to take file from source directory!
#SOURCE='/datafeed/CustomerMain'
# define location where correct file need to move!
#CORRECTDIR='/var/tmp/'
# define location where incorrect file need to move!
#INCORRECTDIR='/var/tmp/'
''' sys.argv[1] is parameter to change directory for actual file location '''
os.chdir(sys.argv[1])
count=1
print (os.getcwd())

def HEADERCHECK(HEADER) :
    list=re.split('[|]',HEADER)
    fieldcount=0
    FLAG=False
    if 'MSISDN' in list :
        print ("header is correct format now check for field count")
        for field in list :
            fieldcount+=1
        if fieldcount == 71 :
            print ("header is correct!")
            FLAG=True
        else :
            FLAG=False
    return FLAG



def RECORDCOUNT(file) :
    TOTALRECORDCOUNT=0
    print (("file name : %s" ) %(file))
    f=open(file,'r')
    for line in f :
        #print(line)
        TOTALRECORDCOUNT+=1
    f.close()
    return TOTALRECORDCOUNT


def FOOTCONTERCHECK(file) :
    f=open(file,'r')
    for line in f :
        if '__EOF__' in line :
           linecount=re.split('[_]',line)
           print (("linecountValues : %s") %linecount)
           return int(linecount[-1])
    else :
        pass
    f.close()
    return "NOTEOF"

for root, dirs, files in os.walk(sys.argv[1]) :
    for file in files :
        count=1
        if file.endswith('.dat') and not file.startswith(('CORRECT_','INCORRECT_')):
           try :
                f=open(file,'r')
                HEADER=f.readline()
                FLAG=False
                FLAG=HEADERCHECK(HEADER)
                if FLAG == True :
                   print (("fine name %s containing header and correct formate! ") %(file))
                   TOTALRECORDCOUNT = RECORDCOUNT(file)
                   print (("TOTALRECORDCOUNT : %s ") %(TOTALRECORDCOUNT))
                   lastlineoffooter=FOOTCONTERCHECK(file)
                   print (("lastlineoffooter : %s") %(lastlineoffooter))
                   ''' ther is a point '''
                   if  lastlineoffooter == TOTALRECORDCOUNT :
                       print (("fine_name %s is correct") %(file))
					   filerename='CORRECT_'+file
                       os.renames(file, filerename)
                       #shutil.move(file, CORRECTDIR)
                       continue
                   else :
                       print (("fine_name %s is incorrect") %(file))
                       renamefile='INCORRECT_'+file
                       os.renames(file, renamefile)
                       #shutil.move(sample, INCORRECTDIR)
                       #print (renamefile)
                       continue
                       ''' raise alert to nagios for file is incorrect '''
                else :
                     print ("file in containing header is invalid! ")
                     ''' nagios alert configuration requierd '''
                     renamefile='INCORRECT_'+file
                     #print (("sample file change : %s") %(sample1))
                     os.renames(file, renamefile)
                     #shutil.move(renamefile, INCORRECTDIR)
                     continue
           except IOError:
               print ("checking for file ")
                #msg=("file does not exist!")
           finally :
                   f.close()
        else :
            print ("no files exist endwith *.dat, kindly check source directory!")
