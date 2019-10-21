pragma solidity >=0.4.18;

contract EventRegistration {

    address owner;

    //Initializing contract with owner
    constructor() public {
                owner = msg.sender;
    }

    //struct that have event description and list of registrations on this event
    struct Event {
        string eventDescription;
        bytes32[] eventRegistrations;
    }

    mapping (uint => Event) events;
    uint[] public EventsList;

    //converts uint to string
    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len - 1;
        while (_i != 0) {
            bstr[k--] = byte(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }

    //merge 3 strings
    function append(string memory a, string memory b, string memory c) internal pure returns (string memory) {
        return string(abi.encodePacked(a, b, c));
    }

    //add double quotes to string
    function quotesCover(string memory text) internal pure returns (string memory) {
        return append("\"", text, "\"" );
    }

    //add json object to JSON. (need for return of function getInfoAboutEvents )
    function appendJSONItem(string memory text, string memory key, string memory value) internal pure returns (string memory) {
        return string(abi.encodePacked(text,"{",quotesCover("id"),":", quotesCover(key), ",",
        quotesCover("desc"),":", quotesCover(value),"}"));
    }

    //create event with description
    function setEvent(string memory _eventDescription) public {
        require(msg.sender == owner);
        uint _id  = EventsList.length+1;
        events[_id].eventDescription = _eventDescription;
        EventsList.push(_id) -1;
    }

    //get list of events in JSON format
    function getInfoAboutEvents() view public returns (string memory){
        string memory result = "[";
        for (uint i=0; i<EventsList.length; i++) {
            string memory _identifier = uint2str(i+1);
            string memory _description = events[i+1].eventDescription;
            result = appendJSONItem(result, _identifier, _description);
            if (i+1<EventsList.length) {
                result = append(result,",","");
            }
        }
        result = append(result, "]", "");
        return (result);
    }


    event registrationStatus(string message);

    //register member on Event. Function don't send real passport data into blockchain. Only hash of it
    //this function also check if member is already registred on event

    function eventRegistration(uint _id, string memory _passport) public {
        bool _alreadyRegistered = false;
        string memory _message = "";
        bytes32 _encodedPassport = keccak256(abi.encode(_passport));
        for(uint i=0; i<events[_id].eventRegistrations.length; i++) {
            if ((events[_id].eventRegistrations[i]) == _encodedPassport) {
                _alreadyRegistered = true;
                break;
            }
        }
        if (_alreadyRegistered == true) {
            _message = "member is already registered on this event";
        } else {
            events[_id].eventRegistrations.push(_encodedPassport);
            _message = "successfully registered on event";
        }
        //show result in event
        emit registrationStatus(_message);
    }


    event IsRegistered(bool status);

    //check if member registered on event
    function checkMember(uint _id, string memory _passport) public returns (bool) {
        bool result = false;
        for(uint i=0; i<events[_id].eventRegistrations.length; i++) {
            //compare hashes of passport numbers
            if ((events[_id].eventRegistrations[i]) == keccak256(abi.encode(_passport))) {
                result = true;
                break;
            }
        }
        //show result in event
        emit IsRegistered(result);
        return (result);
    }

}