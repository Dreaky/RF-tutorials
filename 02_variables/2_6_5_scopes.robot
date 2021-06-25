*** Variables ***
${var_1}=   This is first variable
${var_2}    This is second variable

*** Test Cases ***
Test Variables deinfed in file
    Log  ${var_1}
    Log  ${var_2}

Test Variables deinfed in test case
    ${var_3}=  Set Variable  New value
    Set Test Variable    ${var_4}   New Test value
    Set Global Variable  ${var_5}   New Global value
    Log  ${var_3}
    Log  ${var_4}
    Log  ${var_5}
#    Quiz :
#    KW Log variable
    KW Log test variable
    KW Log global variable

Test Variables deinfed in keyword
    KW define variable for test
    Log  ${var_6}
#    Quiz:                  robot --randomize all .
#    KW Log variable
#    KW Log test variable
    KW Log global variable

*** Keywords ***
KW Log variable
    Log  ${var_3}

KW Log test variable
    Log  ${var_4}

KW Log global variable
    Log  ${var_5}

KW define variable for test
    Set Test Variable    ${var_6}   New KW Test value