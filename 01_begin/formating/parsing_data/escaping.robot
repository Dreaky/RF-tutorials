*** Settings ***
Documentation     The escape character in Robot Framework test data is the backslash (\) and
...               built-in variables ${EMPTY} and ${SPACE} can often be used for escaping.
...               Different escaping mechanisms are discussed in the sections below.

*** Variables ***
${var}            path${/}to${/}space

*** Test Cases ***
Special characters
    Log    \${notvar}    # as you can see RF plugin fr pycharm doeasnt support this options and signalize error
    Log    \@{notvar}
    Log    \&{notvar}    # same problem for dictionaries in RF
    Log    \%{notvar}
    Log    \# not comment
    Log    not\=named
    Log    ls -1 *.txt \| wc -l
    Log    c:\\temp, \\${var}

Forming escape sequences
    Log All Items    first line\n2nd line
    ...    text${\n}more text
    ...    text\rmore text
    ...    text\tmore text
    ...    null byte: \x00, ä: \xE4
    ...    snowman: \u2603
    ...    love hotel: \U0001f3e9

Handling empty values
    #    Using backlash
    Do Something    first arg    \
    Do Something    \    second arg
    #    Using ${EMPTY}
    Do Something    first arg    ${EMPTY}
    Do Something    ${EMPTY}    second arg
    Do Something    ''    ""        # example "" or '' != \ or ${EMPTY}

Handling spaces
    #    Escaping with backslash
    Log All Items
    ...  \ leading space
    ...  trailing space \ 	        # Backslash must be after the space.
    ...  \ \ 	                    # Backslash needed on both sides.
    ...  consecutive \ \ spaces
    #    Escaping with ${SPACE}
    Log All Items
    ...  ${SPACE}leading space
    ...  trailing space${SPACE}
    ...  ${SPACE}
    ...  consecutive${SPACE * 3}spaces

*** Keywords ***
Log All Items
    [Arguments]    @{items}
    FOR    ${item}    IN    @{items}
        Log    ${item}
    END

Do Something
    [Arguments]    ${first_arg}    ${second_arg}
    Log    ${first_arg}
    Log    ${second_arg}
