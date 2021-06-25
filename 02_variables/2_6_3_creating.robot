*** Variables ***
#               STRING
${NAME}         Robot Framework
${VERSION}      2.0
${ROBOT}        ${NAME} ${VERSION}
#${NAME} =       Robot Framework
#${VERSION} =    2.0
${EXAMPLE}      This value is joined
...             together with a space.
${MULTILINE}    SEPARATOR=\n
...             First line.
...             Second line.
...             Third line.

#               NUMBER
${ONE}          ${1}
${TWO}          2  # not supported every where, can be calculated but moved as string

#               LIST
@{NAMES}        Matti       Teppo
@{NAMES2}       @{NAMES}    Seppo
@{NOTHING}
@{MANY}         one         two      three      four
...             five        six      seven

#               DICTIONARY
&{USER 1}       name=Matti    address=xxx         phone=123
&{USER 2}       name=Teppo    address=yyy         phone=456
&{DIC_MANY}         first=1       second=${2}         ${3}=third
&{EVEN MORE}    &{DIC_MANY}       first=override      empty=
...             =empty        key\=here=value


*** Test Cases ***
Test Log All Variables
    Log Variables

Test Assigning list variables
    @{list} =    Create List    first    second    third
    Length Should Be    ${list}    3
    Log Many    @{list}


Test Assigning dictionary variables
    &{dict} =    Create Dictionary    first=1    second=${2}    ${3}=third
    Length Should Be    ${dict}    3
    Log   ${dict}

Test Returning Variables From Keyword
#    Assign multiple
    ${a}    ${b}    ${c} =    Get Three
    ${first}    @{rest} =    Get Three
    @{before}    ${last} =    Get Three
    ${begin}    @{middle}    ${end} =    Get Three
    Log  ${${b} + ${c}}


*** Keywords ***
Get Three
    [Return]  One  2   ${3}