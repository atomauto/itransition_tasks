#
# Exposes functions for handling an incoming request and sending a response
#


#
# Get a query parameters by its name
#
function getRequestParam(name)
{
    return _requestParams[name]
}


# 
# Get a request header by its name (case-insensitive)
#
function getRequestHeader(name)
{
    return _requestHeaders[tolower(name)]
}


#
# Get the incoming request contents
#
function getRequestBody()
{
    return _requestBody
}


#
# Get the incoming request endpoint
#
function getRequestEndpoint() {
    return _endpoint
}


#
# Set the outgoing response status
#
function setResponseStatus(status)
{
    _responseStatus = status
}


#
# Set an outgoing response header
#
function setResponseHeader(name, value)
{
    _responseHeaders[name] = value
}


#
# Set the outgoing response body
#
function setResponseBody(body)
{
    _responseBody = body
}


#
# Send a file as the outgoing response. This function guesses the content type based on the file extension
#
function sendFile(file, headers)
{
    _contents = getFile(file)
    if (_contents)
    {
        _contentType = "text/plain" 
        switch(file) {
            case /\.html$/:
                _contentType = "text/html; charset=utf-8"
                break
            case /\.css$/:
                _contentType = "text/css"
                break
            case /\.js$/:
                _contentType = "application/javascript"
                break
            case /\.jpg$/:
            case /\.jpeg$/:
                _contentType = "image/jpeg"
                break
            case /\.png$/:
                _contentType = "image/png"
                break
            case /\.gif$/:
                _contentType = "image/gif"
                break
            case /\.ico$/:
                _contentType = "image/x-icon"
                break
        
        }
        setResponseHeader("Pragma", "no-cache")
        setResponseHeader("Content-Type", _contentType)
        setResponseBody(_contents)
        return 1
    }
    return 0
}

function getFile(file)
{
    _contents = ""
    while (getline line < file > 0)
    {
        if (_contents) _contents = contents ORS
        _contents = _contents line
    }

    close(file)
    return _contents
}


function addRoute(method, endpoint, dest)
{
    info("adding route: " method " " endpoint " -> " dest)
    _routes[method][endpoint] = dest
}


function urlDecode(text)
{
    if (!text)
        return ""
    _uDecoded = ""
    split(text, _uParts, "+")
    for (_uI in _uParts)
    {
        if (_uI > 1)
            _uDecoded = _uDecoded " "

        split(_uParts[_uI], _uSubParts, "%")
        for (_uJ in _uSubParts)
        {
            if (_uJ > 1)
            {
                _uCode = substr(_uSubParts[_uJ], 0, 2)
                _uReplacement = _uCode in _uUrlChars ? _uUrlChars[_uCode] : "?"
                sub("^" _uCode, _uReplacement, _uSubParts[_uJ])
            }
            _uDecoded = _uDecoded _uSubParts[_uJ]
        }

    }
    return _uDecoded
}


function urlEncode(text) {
    
    if (!text)
        return ""

    _uEncoded = ""
    split(text, _uParts, "")
    for (_uI in _uParts) 
    {
        _uC = _uUrlCharsReverse[_uParts[_uI]]
        if (_uC)
        {
            if (_uC != "+") _uC = "%" _uC
        }
        else {
            _uC = _uParts[_uI]
        }
        _uEncoded = _uEncoded _uC
    }

    return _uEncoded
}


#
# URL encoding / decoding
#
BEGIN {
    _uUrlChars["20"] = " "
    _uUrlChars["21"] = "!"
    _uUrlChars["22"] = "\""
    _uUrlChars["23"] = "#"
    _uUrlChars["24"] = "$"
    _uUrlChars["25"] = "%"
    _uUrlChars["26"] = "&"
    _uUrlChars["27"] = "'"
    _uUrlChars["28"] = "("
    _uUrlChars["29"] = ")"
    _uUrlChars["2A"] = "*"
    _uUrlChars["2B"] = "+"
    _uUrlChars["2C"] = ","
    _uUrlChars["2D"] = "-"
    _uUrlChars["2E"] = "."
    _uUrlChars["2F"] = "/"
    _uUrlChars["30"] = "0"
    _uUrlChars["31"] = "1"
    _uUrlChars["32"] = "2"
    _uUrlChars["33"] = "3"
    _uUrlChars["34"] = "4"
    _uUrlChars["35"] = "5"
    _uUrlChars["36"] = "6"
    _uUrlChars["37"] = "7"
    _uUrlChars["38"] = "8"
    _uUrlChars["39"] = "9"
    _uUrlChars["3A"] = ":"
    _uUrlChars["3B"] = ";"
    _uUrlChars["3C"] = "<"
    _uUrlChars["3D"] = "="
    _uUrlChars["3E"] = ">"
    _uUrlChars["3F"] = "?"
    _uUrlChars["40"] = "@"
    _uUrlChars["41"] = "A"
    _uUrlChars["42"] = "B"
    _uUrlChars["43"] = "C"
    _uUrlChars["44"] = "D"
    _uUrlChars["45"] = "E"
    _uUrlChars["46"] = "F"
    _uUrlChars["47"] = "G"
    _uUrlChars["48"] = "H"
    _uUrlChars["49"] = "I"
    _uUrlChars["4A"] = "J"
    _uUrlChars["4B"] = "K"
    _uUrlChars["4C"] = "L"
    _uUrlChars["4D"] = "M"
    _uUrlChars["4E"] = "N"
    _uUrlChars["4F"] = "O"
    _uUrlChars["50"] = "P"
    _uUrlChars["51"] = "Q"
    _uUrlChars["52"] = "R"
    _uUrlChars["53"] = "S"
    _uUrlChars["54"] = "T"
    _uUrlChars["55"] = "U"
    _uUrlChars["56"] = "V"
    _uUrlChars["57"] = "W"
    _uUrlChars["58"] = "X"
    _uUrlChars["59"] = "Y"
    _uUrlChars["5A"] = "Z"
    _uUrlChars["5B"] = "["
    _uUrlChars["5C"] = "\\"
    _uUrlChars["5D"] = "]"
    _uUrlChars["5E"] = "^"
    _uUrlChars["5F"] = "_"
    _uUrlChars["60"] = "`"
    _uUrlChars["61"] = "a"
    _uUrlChars["62"] = "b"
    _uUrlChars["63"] = "c"
    _uUrlChars["64"] = "d"
    _uUrlChars["65"] = "e"
    _uUrlChars["66"] = "f"
    _uUrlChars["67"] = "g"
    _uUrlChars["68"] = "h"
    _uUrlChars["69"] = "i"
    _uUrlChars["6A"] = "j"
    _uUrlChars["6B"] = "k"
    _uUrlChars["6C"] = "l"
    _uUrlChars["6D"] = "m"
    _uUrlChars["6E"] = "n"
    _uUrlChars["6F"] = "o"
    _uUrlChars["70"] = "p"
    _uUrlChars["71"] = "q"
    _uUrlChars["72"] = "r"
    _uUrlChars["73"] = "s"
    _uUrlChars["74"] = "t"
    _uUrlChars["75"] = "u"
    _uUrlChars["76"] = "v"
    _uUrlChars["77"] = "w"
    _uUrlChars["78"] = "x"
    _uUrlChars["79"] = "y"
    _uUrlChars["7A"] = "z"
    _uUrlChars["7B"] = "{"
    _uUrlChars["7C"] = "|"
    _uUrlChars["7D"] = "}"
    _uUrlChars["7E"] = "~"
    _uUrlChars["80"] = "`"
    _uUrlChars["81"] = "??"
    _uUrlChars["82"] = "???"
    _uUrlChars["83"] = "??"
    _uUrlChars["84"] = "???"
    _uUrlChars["85"] = "???"
    _uUrlChars["86"] = "???"
    _uUrlChars["87"] = "???"
    _uUrlChars["88"] = "??"
    _uUrlChars["89"] = "???"
    _uUrlChars["8A"] = "??"
    _uUrlChars["8B"] = "???"
    _uUrlChars["8C"] = "??"
    _uUrlChars["8D"] = "??"
    _uUrlChars["8E"] = "??"
    _uUrlChars["8F"] = "??"
    _uUrlChars["90"] = "??"
    _uUrlChars["91"] = "???"
    _uUrlChars["92"] = "???"
    _uUrlChars["93"] = "???"
    _uUrlChars["94"] = "???"
    _uUrlChars["95"] = "???"
    _uUrlChars["96"] = "???"
    _uUrlChars["97"] = "???"
    _uUrlChars["98"] = "??"
    _uUrlChars["99"] = "???"
    _uUrlChars["9A"] = "??"
    _uUrlChars["9B"] = "???"
    _uUrlChars["9C"] = "??"
    _uUrlChars["9D"] = "??"
    _uUrlChars["9E"] = "??"
    _uUrlChars["9F"] = "??"
    _uUrlChars["A1"] = "??"
    _uUrlChars["A2"] = "??"
    _uUrlChars["A3"] = "??"
    _uUrlChars["A4"] = "??"
    _uUrlChars["A5"] = "??"
    _uUrlChars["A6"] = "??"
    _uUrlChars["A7"] = "??"
    _uUrlChars["A8"] = "??"
    _uUrlChars["A9"] = "??"
    _uUrlChars["AA"] = "??"
    _uUrlChars["AB"] = "??"
    _uUrlChars["AC"] = "??"
    _uUrlChars["AD"] = "??"
    _uUrlChars["AE"] = "??"
    _uUrlChars["AF"] = "??"
    _uUrlChars["B0"] = "??"
    _uUrlChars["B1"] = "??"
    _uUrlChars["B2"] = "??"
    _uUrlChars["B3"] = "??"
    _uUrlChars["B4"] = "??"
    _uUrlChars["B5"] = "??"
    _uUrlChars["B6"] = "??"
    _uUrlChars["B7"] = "??"
    _uUrlChars["B8"] = "??"
    _uUrlChars["B9"] = "??"
    _uUrlChars["BA"] = "??"
    _uUrlChars["BB"] = "??"
    _uUrlChars["BC"] = "??"
    _uUrlChars["BD"] = "??"
    _uUrlChars["BE"] = "??"
    _uUrlChars["BF"] = "??"
    _uUrlChars["C0"] = "??"
    _uUrlChars["C1"] = "??"
    _uUrlChars["C2"] = "??"
    _uUrlChars["C3"] = "??"
    _uUrlChars["C4"] = "??"
    _uUrlChars["C5"] = "??"
    _uUrlChars["C6"] = "??"
    _uUrlChars["C7"] = "??"
    _uUrlChars["C8"] = "??"
    _uUrlChars["C9"] = "??"
    _uUrlChars["CA"] = "??"
    _uUrlChars["CB"] = "??"
    _uUrlChars["CC"] = "??"
    _uUrlChars["CD"] = "??"
    _uUrlChars["CE"] = "??"
    _uUrlChars["CF"] = "??"
    _uUrlChars["D0"] = "??"
    _uUrlChars["D1"] = "??"
    _uUrlChars["D2"] = "??"
    _uUrlChars["D3"] = "??"
    _uUrlChars["D4"] = "??"
    _uUrlChars["D5"] = "??"
    _uUrlChars["D6"] = "??"
    _uUrlChars["D7"] = "??"
    _uUrlChars["D8"] = "??"
    _uUrlChars["D9"] = "??"
    _uUrlChars["DA"] = "??"
    _uUrlChars["DB"] = "??"
    _uUrlChars["DC"] = "??"
    _uUrlChars["DD"] = "??"
    _uUrlChars["DE"] = "??"
    _uUrlChars["DF"] = "??"
    _uUrlChars["E0"] = "??"
    _uUrlChars["E1"] = "??"
    _uUrlChars["E2"] = "??"
    _uUrlChars["E3"] = "??"
    _uUrlChars["E4"] = "??"
    _uUrlChars["E5"] = "??"
    _uUrlChars["E6"] = "??"
    _uUrlChars["E7"] = "??"
    _uUrlChars["E8"] = "??"
    _uUrlChars["E9"] = "??"
    _uUrlChars["EA"] = "??"
    _uUrlChars["EB"] = "??"
    _uUrlChars["EC"] = "??"
    _uUrlChars["ED"] = "??"
    _uUrlChars["EE"] = "??"
    _uUrlChars["EF"] = "??"
    _uUrlChars["F0"] = "??"
    _uUrlChars["F1"] = "??"
    _uUrlChars["F2"] = "??"
    _uUrlChars["F3"] = "??"
    _uUrlChars["F4"] = "??"
    _uUrlChars["F5"] = "??"
    _uUrlChars["F6"] = "??"
    _uUrlChars["F7"] = "??"
    _uUrlChars["F8"] = "??"
    _uUrlChars["F9"] = "??"
    _uUrlChars["FA"] = "??"
    _uUrlChars["FB"] = "??"
    _uUrlChars["FC"] = "??"
    _uUrlChars["FD"] = "??"
    _uUrlChars["FE"] = "??"
    _uUrlChars["FF"] = "??"

    for (_uCode in _uUrlChars) 
    {
        if (!match(_uUrlChars[_uCode], /[a-zA-Z0-9]/))
        {
            _uUrlCharsReverse[_uUrlChars[_uCode]] = _uCode
        }
    }
    _uUrlChars[" "] = "+"
}

