import "./Destroyable.sol";

pragma solidity 0.5.12;

contract ClassicToBeCalled is Destroyable{
    
    struct Person {
        string name;
        uint age;        
        uint height;
        bool alreadyTwentyOne;
    }
    
    // Inside the normal parenthesis () is already written what should be executed, here we don't need to specify memory (pragma 0.5.12, not sure after that)
    event personCreated (string name4, uint age4, uint height4, bool alreadyTwentyOne4); 
    
    event personDeleted (string name5, uint age5, uint height5, bool alreadyTwentyOne5, address deletedBy5); 
    
    event personUpdated (string beforeUpdatedName7, uint beforeUpdatedAge7, uint beforeUpdatedHeight7, bool beforeUpdatedAlreadyTwentyOne7, string updatedName7, uint updatedAge7, uint updatedHeight7, bool updatedAlreadyTwentyOne7);
    
    uint public balance;
    
   mapping (address => Person) private people ;
    
    address[] private creators;
    
    // here we make "costs" a modifier that is dynamic, meaning we can specify a price when using it
    modifier costs(uint cost) {
       require(msg.value >= cost); 
       _;
    }
    
    //Here we use the "costs" modifier and specify that the price is 1 ether
    function createPerson (string memory name1, uint age1, uint height1) public payable costs(1 ether) {
        require (age1>0, "Age must be larger than 0");
        
        balance += msg.value;
        
        Person memory newPerson1;
        
        bool updating1 = false;
        string memory beforeUpdatedName1;
        uint beforeUpdatedAge1;
        uint beforeUpdatedHeight1;
        bool beforeUpdatedAlreadyTwentyOne1;
        
        // Change so that if statement works, should mean "if entry already exists, then..."
        if (people[msg.sender].age != 0) {
            
            beforeUpdatedName1 = people[msg.sender].name;
            beforeUpdatedAge1 = people[msg.sender].age;
            beforeUpdatedHeight1 = people[msg.sender].height;
            beforeUpdatedAlreadyTwentyOne1 = people[msg.sender].alreadyTwentyOne;
            updating1 = true;
        }
        
        newPerson1.name = name1;
        newPerson1.age = age1;
        newPerson1.height = height1;
        
        if (age1 >= 21) {
            newPerson1.alreadyTwentyOne = true;
        } 
        else {
            newPerson1.alreadyTwentyOne = false;
        }
        insertPerson(newPerson1);
        creators.push(msg.sender);
        // structs cannot be compared to each other, so both need to be turned into hexadecimal ( abi.encodePacked ) and hashed and these hashes compared. 
        //Spaced like this just learning, normally all in one line.
        assert(
            keccak256(
                abi.encodePacked(
                    people[msg.sender].name, 
                    people[msg.sender].age, 
                    people[msg.sender].height, 
                    people[msg.sender].alreadyTwentyOne
                )
            ) 
            
            == 
            
            keccak256(
                abi.encodePacked(
                    newPerson1.name, 
                    newPerson1.age, 
                    newPerson1.height, 
                    newPerson1.alreadyTwentyOne
                )
            )
        );
        
        if (updating1 == true) {
            emit personUpdated(beforeUpdatedName1, beforeUpdatedAge1, beforeUpdatedHeight1, beforeUpdatedAlreadyTwentyOne1, newPerson1.name, newPerson1.age, newPerson1.height, newPerson1.alreadyTwentyOne);
        } else {
            emit personCreated(newPerson1.name, newPerson1.age, newPerson1.height, newPerson1.alreadyTwentyOne); 
        }
        
    }
    
    function insertPerson (Person memory newPerson2) private {
        address creator2 = msg.sender; 
        people[creator2] = newPerson2;
    }
    
    function getPerson () public view returns (string memory name3, uint age3, uint height3, bool alreadyTwentyOne3) {
        address creator3 = msg.sender;
        return (people[creator3].name, people[creator3].age, people[creator3].height, people[creator3].alreadyTwentyOne);
    }
    
    function deletePerson (address addressToDelete) public onlyOwner {
        string memory name6 = people[addressToDelete].name;
        uint age6 = people[addressToDelete].age;
        uint height6 = people[addressToDelete].height;
        bool alreadyTwentyOne6 = people[addressToDelete].alreadyTwentyOne;
        
        delete people[addressToDelete];
        assert( people[addressToDelete].age == 0 );
        emit personDeleted (name6, age6, height6, alreadyTwentyOne6, msg.sender); 
    }
    
    function getAddress (uint index) public view onlyOwner returns(address) {
        return (creators[index]);
    }
    
    function withdrawAll() public onlyOwner returns(uint) {
        uint toTransfer = balance;
        balance = 0;
        owner.transfer(toTransfer);
        return toTransfer;
    }
}



