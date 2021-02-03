from tkinter import *  
from PIL import ImageTk, Image
import time
import subprocess
import os
import multiprocessing

stage = Tk() 
stage.title("CBB")
stage.geometry("1500x800")

C = Canvas(stage, bg="blue", height=250, width=300)
filename = PhotoImage(file = "assets/gene2.png")
background_label = Label(stage, image=filename)
background_label.place(x=0, y=0, relwidth=1, relheight=1)

C.pack()


def run_1():
    command ="Rscript"
    path = 'C:\\Users\\HP\\CBB\\data_fromatting.R'
    cmd = [command,path]
    x = subprocess.check_output(cmd,universal_newlines=True)
    # os.system("start cmd /k Rscript C:\\Users\\kumud\\OneDrive\\Documents\\CBB_Project\\data_fromatting.R")

def run_2():
    command ="Rscript"
    path = 'C:\\Users\\HP\\CBB\\bhawan.R'
    cmd = [command,path]
    x = subprocess.check_output(cmd,universal_newlines=True)
    # os.system("start cmd /k Rscript C:\\Users\\kumud\\OneDrive\\Documents\\CBB_Project\\bhawan.R")

def openNewWindow():
    global newWindow
    # global run_1
    # global run_2
    newWindow = Toplevel() 
    newWindow.title("Loading") 
    newWindow.geometry("1500x800") 
    name = variable.get()
    print("The input is : " + name[0:4])
    fun1(name[0:4])
def fun1(s):
    import csv
    import pandas as pd
    import requests
    import gzip
    import shutil
    import numpy as np
    inp=s
    host="https://gdc.xenahubs.net"
    dataset="TCGA-"+inp+".GDC_phenotype.tsv.gz"
    string="https://gdc.xenahubs.net/download/"+dataset
    filename="data/" + "raw_phenotype.tsv"
    with open(filename,"wb") as f:
        r=requests.get(string)
        f.write(r.content)
    with gzip.open(filename,"r") as f:
        a=pd.read_csv(f,delimiter="\t")
        a.to_csv("data/PHENOTYPE.csv",index=False)
    host1="https://gdc.xenahubs.net"
    dataset1="TCGA-"+inp+".htseq_counts.tsv.gz"
    string1="https://gdc.xenahubs.net/download/"+dataset1
    filename1="data/"+"raw_htseq_count.tsv"
    with open(filename1,"wb") as f1:
        r1=requests.get(string1)
        f1.write(r1.content)
    with gzip.open(filename1,"r") as f1:
        a1=pd.read_csv(f1,delimiter="\t")
        a1.to_csv("data/HTSEQ.csv",index=False)
    string2="https://gdc.xenahubs.net/download/gencode.v22.annotation.gene.probeMap"
    filename2="data/" + string2.split("/")[-1]
    with open(filename2,"wb") as f2:
        r2=requests.get(string2)
        f2.write(r2.content)
    f3=open(filename2,"r")
    a2=pd.read_csv(f3,delimiter="\t")
    a2.to_csv("data/PROBEMAP.csv",index=False)
    run_1()
    run_2()
    print("Entered the Final Stage")

  
#     Label(newWindow,  text ="This is a new window").place(x=200, y=200)

    C1 = Canvas(newWindow, bg="blue", height=250, width=300)
    filename1 = PhotoImage(file = "assets/gene2.png")
    background_label1 = Label(newWindow, image=filename1)
    background_label1.place(x=0, y=0, relwidth=1, relheight=1)

    C1.pack()

    load = Image.open("plots/violin_plot.jpeg")
    resized = load.resize((475, 375),Image.ANTIALIAS)
    image = ImageTk.PhotoImage(resized) 
    display = Label(newWindow, image = image)
    display.place(x=50, y=25)
    
    load2 = Image.open("plots/v_plot.jpeg")
    resized2 = load2.resize((475, 375),Image.ANTIALIAS)
    image2 = ImageTk.PhotoImage(resized2) 
    display2 = Label(newWindow, image = image2)
    display2.place(x=800, y=25)
    
    load3 = Image.open("plots/hm_plot.jpeg")
    resized3 = load3.resize((475, 375),Image.ANTIALIAS)
    image3 = ImageTk.PhotoImage(resized3) 
    display3 = Label(newWindow, image = image3)
    display3.place(x=50, y=400)
    
    load4 = Image.open("plots/box_plot.jpeg")
    resized4 = load4.resize((475, 375),Image.ANTIALIAS)
    image4 = ImageTk.PhotoImage(resized4) 
    display4 = Label(newWindow, image = image4)
    display4.place(x=800, y=400)
    
    btn2 = Button(newWindow, text="BACK", command = newWindow.destroy).place(x=640, y=300)
    newWindow.mainloop()
    
#     my_img = ImageTk.PhotoImage(Image.open("/Users/hardikdudeja/Downloads/img.png"))
#     my_label = Label(newWindow, image=my_img).place(x=0, y=0)
    
#     time.sleep(3)
    
#     btn2 = Button(newWindow, text="Click to destroy", command = openLastWindow).place(x=200, y=200)
    
    
    
def openLastWindow():
    global lastWindow
    lastWindow = Toplevel()
    lastWindow.geometry("1500x800")
    

btn = Button(stage,  text ="Start Analysis", command = openNewWindow).place(x=650, y=500)



title = Label(text="MKHHYB", font=('Helvetica', 42), fg = 'white', bg='black').place(x=100, y=50)
# title.pack(side="top")

OptionList = ["BRCA(Breast Cancer)","PRAD(Prostate Cancer)","CESC(Cervical Cancer)","CHOL(Bile Duct Cancer)","ESCA(Esophageal Cancer)","GBM(Gliboastoma)","KICH(Kidney Chromophobe)","THYM (Thyomo)","SARC(Sacrome)"]
OptionList.sort()
variable = StringVar(stage)
variable.set(OptionList[0])

opt = OptionMenu(stage, variable, *OptionList)
opt.config(width=50, font=('Helvetica', 12))
opt.place(x=450, y=400)
# opt.pack(side="top")


labelTest = Label(text="", font=('Helvetica', 12), fg='red', bg = 'black').place(x=100, y=200)
# labelTest.pack(side="top")

# def callback(*args):
#     labelTest.configure(text="The selected item is {}".format(variable.get())

# variable.trace("w", callback)

stage.mainloop()
