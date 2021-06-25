*** Variables ***
&{dict_1}=     key=value  key_2=value_2
${TEST_ENV}    https://edf.test.eset.systems/edf
${DEV_ENV}     https://edf.test.eset.systems/edf


*** Test Cases ***
Test dictionary usage
    Log  ${dict_1}
#    Quiz:
    Log  ${dict_1}
    Log  ${dict_1}[key]
    Log  ${dict_1.key_2}
    Log  ${dict_1['key_2']}

Test Strings with python funct
    ${string} =    Set Variable    abc
    Log    ${string.upper()}      # Logs 'ABC'
    Log    ${string * 2}          # Logs 'abcabc'

Test Number with python funct
    ${number} =    Set Variable    ${-2}
    Log    ${number * 10}         # Logs -20
    Log    ${number.__abs__()}    # Logs 2

Test Variables inside variables
    ${env} =       Set Variable    TEST
    Log    ${${env}_ENV}
#    Quiz:
#    is another options how to set similar variable ?

Test Inline Python evaluation
    Log    ${{1 + 2}}
    ${tmp}=  Evaluate    ${1} + ${2}
    Log    ${tmp}
    Log    ${{len('${DEV_ENV}') > 3}}
    Log    ${{$DEV_ENV[0] if $DEV_ENV is not None else None}}
    Log    ${{datetime.date(2021, 6, 24)}}

