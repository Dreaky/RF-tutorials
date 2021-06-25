*** Settings ***
Resource        var.resource

*** Variables ***
#${EXAMPLE}=   defined in file

*** Test Cases ***
Test Variables deinfed in file
    # run with: robot --variable EXAMPLE:defined from console --variablefile vars.py .
#    ${EXAMPLE}=   Set Variable  defined in test
    Log  ${EXAMPLE}

Test get variables from file
    Log  ${SPEC_VALUE}

#*** Settings ***
#Resource    example.resource
#Resource    ../data/resources.robot
#Resource    ${RESOURCES}/common.resource
#
#*** Settings ***
#Variables    myvariables.py
#Variables    ../data/variables.py
#Variables    ${RESOURCES}/common.py
#Variables    taking_arguments.py    arg1    ${ARG2}
#
#--variablefile myvariables.py
#--variablefile path/variables.py
#--variablefile /absolute/path/common.py
#--variablefile taking_arguments.py:arg1:arg2