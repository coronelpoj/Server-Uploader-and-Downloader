*** Settings ***
Library    BuiltIn
Library    yaml
Library    OperatingSystem
Library    SSHLibrary
Library    Collections
Library    String

Variables    ./var_files/connection.yaml
Variables    ./var_files/path_directory.yaml


*** Keywords ***
Initialize Robot Script
    Init Variables
    Init Connection
Init Variables
    ${CONNECTION}    Set Variable    ${CONNECTION_LIST}
    Set Global Variable    ${CONNECTION}

    ${LOCAL_TO_ENV_DIR}    Set Variable    ${TRANSFER_TO_ENV}
    Set Global Variable    ${LOCAL_TO_ENV_DIR}

    ${ENV_TO_LOCAL_DIR}    Set Variable    ${GET_FILE_FROM_ENV}
    Set Global Variable    ${ENV_TO_LOCAL_DIR}
 
Init Connection 
    FOR    ${ITEM}    IN    @{CONNECTION}
        ${LAST_CONNECTION}    Get Connection
        ${SERVER}    Set To Dictionary    ${ITEM}
        Open Connection    ${SERVER}[HOST]    ${SERVER}[NAME]    22
        Log To Console    Opening connection to ${SERVER}[HOST] ${SERVER}[NAME] 22
        IF    "${SERVER}[KEY]" != ""
            IF    "${LAST_CONNECTION.alias}" == "None"
                Login With Public Key    ${SERVER}[USER]    ${SERVER}[KEY]    delay=3 seconds
            ELSE
                Login With Public Key    ${SERVER}[USER]    ${SERVER}[KEY]    delay=3 seconds    jumphost_index_or_alias=${LAST_CONNECTION.alias}
            END
        ELSE
            IF    "${LAST_CONNECTION.alias}" == "None"
                Login    ${SERVER}[USER]    ${SERVER}[PASS]    delay=3 seconds
            ELSE 
                Login    ${SERVER}[USER]    ${SERVER}[PASS]    delay=3 seconds    jumphost_index_or_alias=${LAST_CONNECTION.alias}
            END
        END
    END


FilePath Processing In Environment
    [Arguments]    ${FILEPATH}
    ${IS_A_FILE}=    Run Keyword And Return Status    SSHLibrary.File Should Exist    ${FILEPATH}
    RETURN    ${IS_A_FILE}

FilePath Processing In Local    
    [Arguments]    ${FILEPATH}
    ${IS_A_FILE}=    Run Keyword And Return Status    OperatingSystem.File Should Exist    ${FILEPATH}
    RETURN    ${IS_A_FILE}

Put File into the environment
    [Tags]    Local to Env
    FOR    ${ITEM}    IN      @{LOCAL_TO_ENV_DIR}
        ${ALL_DIR}    Set To Dictionary    ${ITEM}
        Execute Command     mkdir -p ${ALL_DIR}[ENV_PATH]
        Log To Console    ${ALL_DIR}[ENV_PATH] Directory Created
        ${IS_IT_FILE}    FilePath Processing In Local    ${ALL_DIR}[FILEPATH_TO_PUT]
        IF    ${IS_IT_FILE} == $True
            Put File    ${ALL_DIR}[FILEPATH_TO_PUT]    ${ALL_DIR}[ENV_PATH]    mode=0744    scp=on
        ELSE
            Put Directory    ${ALL_DIR}[FILEPATH_TO_PUT]    ${ALL_DIR}[ENV_PATH]    mode=0744    scp=on
        END
    END

Get File from the environment
    [Tags]    Env to Local
    FOR    ${ITEM}    IN    @{ENV_TO_LOCAL_DIR}
        ${DIR_ALL}    Set To Dictionary    ${ITEM}
        Log To Console    "Gettng File "${DIR_ALL}[FILEPATH_TO_GET]
        ${IS_IT_FILE}=    FilePath Processing In Environment    ${DIR_ALL}[FILEPATH_TO_GET]
        IF    ${IS_IT_FILE} == $True
            SSHLibrary.Get File    ${DIR_ALL}[FILEPATH_TO_GET]     scp=on
            ${FILENAME}=     Evaluate    "${DIR_ALL}[FILEPATH_TO_GET]".split("/")[-1]
            Move File    ./${FILENAME}    ${DIR_ALL}[LOCAL_PATH]
        ELSE
            SSHLibrary.Get Directory    ${DIR_ALL}[FILEPATH_TO_GET]     scp=on    recursive=true
            ${FILENAME}=     Evaluate    "${DIR_ALL}[FILEPATH_TO_GET]".split("/")[-1]
            Move Directory    ./${FILENAME}    ${DIR_ALL}[LOCAL_PATH]
        END
    END

