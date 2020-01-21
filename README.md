# PPR-Meta: a tool for identifying phages and plasmids from metagenomic fragments using deep learning

* [Introduction](#introduction)
* [Version](#version)
* [Requirements](#requirements)
* [Installation](#installation)
* [Usage](#usage)
* [Output](#output)
* [Citation](#citation)
* [Contact](#contact)
    

## Introduction

PPR-Meta is designed to identify metagenomic sequences as phages, chromosomes or plasmids. The program calculate three score reflecting the likelihood of each input fragment as phage, chromosome or plasmid. PPR-Meta can run either on the virtual machine or physical host. For non-computer professionals, we recommend running the virtual machine version of PPR-Meta on local PC. In this way, users do not need to install any dependency package. If GPU is available, you can also choose to run the physical host version. This version can automatically speed up with GPU and is more suitable to handle large scale data. The program is also available at http://cqb.pku.edu.cn/ZhuLab/PPR_Meta/.

## Version
+ PPR-Meta 1.1 (Tested on Ubuntu 16.04)

## Requirements
------------
### 1. To run the physical host version of PPR-Meta, you need to install:
+ [Python 2.7.12](https://www.python.org/)
+ [numpy 1.13.1](http://www.numpy.org/)
+ [h5py 2.6.0](http://www.h5py.org/)
+ [TensorFlow 1.4.1](https://www.tensorflow.org/)
+ [Keras 2.0.8](https://keras.io/)
+ [MATLAB Component Runtime (MCR) R2018a](https://www.mathworks.com/products/compiler/matlab-runtime.html) or [MATLAB R2018a](https://www.mathworks.com/products/matlab.html)

  **Note:**
(1) PPR-Meta should be run under Linux operating system.
(2) For compatibility, we recommend installing the tools with the similar version as described above.
(3) If GPU is available in your machine, we recommend installing a GPU version of the TensorFlow to speed up the program.
(4) PPR-Meta can be run with either an executable file or a MATLAB script. If you run PPR-Meta through the executable file, you need to install the MCR (for free) while MATLAB is not necessary. If you run PPR-Meta through the MATLAB script, MATLAB is required.

### 2. If you are non-computer professionals who unfamiliar with the Linux operating system, we recommend using the virtual machine of PPR-Meta. In this way, you do not need to install any dependant packages as mentioned above.



## Installation

### 1. Physical host version
  #### 1.1 Prerequisites
  
  First, please install **numpy, h5py, TensorFlow** and **Keras** according to their manuals. All of these are python packages, which can be installed with ``pip``. If “pip” is not already installed in your machine, use the command “sudo apt-get install python-pip python-dev” to install “pip”. Here are example commands of installing the above python packages using “pip”.
    
    pip install numpy
    pip install h5py
    pip install tensorflow==1.4.1  #CPU version
    pip install tensorflow-gpu==1.4.1  #GPU version
    pip install keras==2.0.8
    
  If you are going to install a GPU version of the TensorFlow, specified NVIDIA software should be installed. See https://www.tensorflow.org/install/install_linux to know whether your machine can install TensorFlow with GPU support.  
  
  When running PPR-Meta through the executable file, MCR should be installed. See https://www.mathworks.com/help/compiler/install-the-matlab-runtime.html to install MCR. On the target computer, please append the following to your LD_LIBRARY_PATH environment variable according to the tips of MCR:
  
    <MCR_installation_folder>/v94/runtime/glnxa64
    <MCR_installation_folder>/v94/bin/glnxa64
    <MCR_installation_folder>/v94/sys/os/glnxa64
    <MCR_installation_folder>/v94/extern/bin/glnxa64
    
  When  running  PPR-Meta  through  the MATLAB script, please  see https://www.mathworks.com/support/ to install the MATLAB.  
  
  #### 1.2 Install PPR-Meta using git
  
  Clone PPR-Meta package
  
    git clone https://github.com/zhenchengfang/PPR-Meta.git
    
  Change directory to PPR-Meta:
  
    cd PPR-Meta
    
  The executable file and all scripts are under the folder
  
  #### 1.3 Install PPR-Meta from zipped file
  
  PPR-Meta can also download as a zipped file:
  
    wget http://cqb.pku.edu.cn/ZhuLab/PPR_Meta/PPR_Meta_v_1_0.zip
    
  Unpack the zipped file:
  
    unzip PPR_Meta_v_1_0.zip
    
  Change directory to PPR-Meta
  
    cd PPR_Meta_v_1_0
    
  The executable file and all scripts are under the folder
  
### 2. Virtual machine version

The installation of the virtual machine is much easier. Please refer to [Manual.pdf](http://cqb.pku.edu.cn/ZhuLab/PPR_Meta/Manual.pdf) for a step by step guide with screenshot to see how to install the vertual machine. Also, you can refer to a breaf [video guide](http://cqb.pku.edu.cn/ZhuLab/PPR_Meta/Video_Guide.mp4) to see how to install the virtual machine.

## Usage

### 1. Run PPR-Meta using executable file (in command line)

  Please simply execute the command:
  
    ./PPR_Meta <input_file_folder>/input_file.fna <output_file_folder>/output_file.csv
    
  The input file must be in fasta format containing the sequences to be identified. For example, users can use the file "example.fna" in the folder to test PPR-Meta by simply executing the command:
  
    ./PPR_Meta example.fna result.csv
    
### 2. Run PPR-Meta using MATLAB script (in MATLAB GUI)

  Please execute the following command directly in MATLAB command window:
  
    PPR_Meta('<input_file_folder>/input_file.fna','<output_file_folder>/output_file.csv')
    
  For example, if you want to identify the sequences in "example.fna", please execute:
  
    PPR_Meta('example.fna','result.csv')
    
  Please remember to set the working path of MATLAB to PPR-Meta folder before running the programe.
  
### 3. Run PPR-Meta with specified threshold

  For each input sequence, PPR-Meta will output three scores (between 0 to 1), representing the probability that the sequence belongs to a phage, chromosome or plasmid. By default, the prediction of PPR-Meta is the category with the highest score. Users can also specify a threshold. In this way, a sequence with a highest score lower than the threshold will be labelled as "uncertain". In general, with a higher threshold, the percentage of uncertain predictions will be higher while the remaining predictions will be more reliable. For example, if you want to get reliable phage and plasmid sequences in the file "example.fna", you can take 0.7 as the threshold. Please run PPR_Meta using -t option:
  
    ./PPR_Meta example.fna result.csv -t 0.7 (by executable file)
    or
    PPR_Meta('example.fna','result.csv','-t','0.7') (by MATLAB script)

### 4. Run PPR-Meta over a large file

  If the RAM of your machine is small, or your file is very large, you can you -b option to let the program read the file in block to reduce the memory requirements and speed up the program. For example, if you want to let the program to predict 1000 sequences at a time, please execute:
  
    ./PPR_Meta example.fna result.csv -b 1000 (by executable file)
    or
    PPR_Meta('example.fna','result.csv','-b','1000') (by MATLAB script)
    
The default value of -b is 10000.

### 5. Run PPR-Meta in virtual machine

  We recommend that non-computer professionals run PPR-Meta in this way. The virtual machine version of PPR-Meta run through the executable file (see item 1 above). Please refer to [Manual.pdf](http://cqb.pku.edu.cn/ZhuLab/PPR_Meta/Manual.pdf) or the [video guide](http://cqb.pku.edu.cn/ZhuLab/PPR_Meta/Video_Guide.mp4) for a step by step guide to see how to run PPR-Meta in the vertual machine. 
  
## Output

The output of PPR-Meta consists of six columns:

Header | Length | phage_score | chromosome_score | plasmid_score | Possible_source |
------ | ------ | ----------- | ---------------- | ------------- | --------------- |

The content in `Header` column is the same with the header of corresponding sequence in the input file. The possible source is the catagory with the higest score. If PPR-Meta is executed under specified threshold, the sequence with the highest score lower than the threshold will be label as uncertain in `Possible_score` columns.

**Note:**
(1) The current version of PPR-Meta uses “comma-separated values (CSV)” as the format of the output file. Please use “.csv” as the extension of the output file. PPR-Meta will automatically add the “.csv” extension to the file name if the output file does not take “.csv” as its extension”.
(2) The version 1.1 of the program allows run mutiple tasks in parallel. However, running mutiple same tasks (with the same input file under the same '-t' and '-b' setting will throw error. 


# Citation
+ [Fang, Z., Tan, J., Wu, S., Li, M., Xu, C., Xie, Z., and Zhu, H. (2019). PPR-Meta: a tool for identifying phages and plasmids from metagenomic fragments using deep learning. GigaScience, 8(6), giz066.] (https://doi.org/10.1093/gigascience/giz066)

# Contact
Any question, please do not hesitate to contact me: fangzc@pku.edu.cn
