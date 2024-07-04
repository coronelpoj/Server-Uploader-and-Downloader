## SERVER UPLOADER DOWNLOADER
#### A program that lets you upload/download files or directories to/from your server/environment with ease
#
#
### Pre-Requisites
1. Python Installed
2. Robot Framework Installed
3. App that can run shell scripts
#
#
## 1. Install Python 
Python is required for this program to work. It is recommended to get the latest version but it is probably fine if you have version 3 and above. Download [here](https://www.python.org/downloads/)
#
## 2. Install Robot Framework
Python is required to install Robot Framework
After installing python make sure that the "pip" command works on the command line of your system.
After confirming that execute the command below.
```
pip install robotframework
```
We will also install the required libraries for Robot Framework in order for the program to work.
```
pip install robotframework-seleniumlibrary
pip install robotframework-sshlibrary
```

## 3. App that can run shell scripts
You should have the means to execute shell scripts. Don't worry, most people can do this.

### For Linux Users
Nothing. Just follow the procedure below and execute the shell script normally using the command line of linux
#
### For Windows Users
Assuming that you have git bash and that you used git bash to get pull this repo, you should also use the git bash to execute the shell script below. 
If not, just download git bash [here](https://git-scm.com/downloads). WSL, in theory, should work too but I have not tried it personally
