*** Settings ***
Resource    ./script_files/script.robot
Suite Setup    Initialize Robot Script
Suite Teardown    Close All Connections
*** Test Cases ***
Transfer file from local to environment
    [Tags]    Local to Env
    Put File into the environment

Transfer file from environment to local
    [Tags]    Env to Local
    Get File from the environment