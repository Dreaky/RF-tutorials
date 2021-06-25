*** Variables ***
@{ITEMS}=  1   2   6

*** Test Cases ***
Template with for loop
    [Template]    Example keyword
    FOR    ${item}    IN    @{ITEMS}
        ${item}    2nd arg
    END
    FOR    ${index}    IN RANGE    42
        1st arg    ${index}
    END



Template with for and if
    [Template]    Example keyword
    FOR    ${item}    IN    @{ITEMS}
        IF  ${item} < 5
            ${item}    2nd arg
        END
    END


*** Keywords ***
Example keyword
    [Arguments]  ${arg_1}   ${arg_2}
    Fail
    Log   Just kw with args ${arg_1} and ${arg_2}