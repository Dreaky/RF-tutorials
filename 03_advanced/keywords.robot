*** Settings ***
Library   Process

*** Test Cases ***
#    run keyword
#    run keywords
#    run keyword if  ${true}==1
#    Wait Until Keyword Succeeds	3x	200ms
#    Run Keywords  Run keyword and ignore ERROR

Test embeded Keywords
    This is my KW with attr ${1} with second value this_is_value

Test arguments Keywords
    This is other KW with attr and values  1   2   4   5   8    7

Regexp in embedded args
    I execute "ls"
    I execute "ls" with "-lh"
    Today is 2011-06-27

#Add two numbers
#    Given I have Calculator open
#    When I add 2 and 40
#    Then result should be 42

*** Keywords ***
This is my KW with attr ${attr} with second value ${value}
    Log  ${attr}
    Log  ${value}

This is other KW with attr and values
    [Arguments]  ${attr}   @{value}
    Log  ${attr}
    Log  ${value}

I execute "${cmd:[^"]+}"
    Run Process    ${cmd}    shell=True

I execute "${cmd}" with "${opts}"
    Run Process    ${cmd} ${opts}    shell=True

Today is ${date:\d{4}-\d{2}-\d{2}}
    Log    ${date}