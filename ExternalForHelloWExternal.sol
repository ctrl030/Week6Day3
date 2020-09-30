import "./Ownable.sol";
import "./Destroyable.sol";

pragma solidity 0.5.12;


//Interface, holds the function headers of the functions from the contract we want to call
contract HelloWExternal {
    function createPerson (string memory nameE2, uint ageE2, uint heightE2) public payable; 
    function getPerson () public view returns (string memory nameE3, uint ageE3, uint heightE3, bool alreadyTwentyOneE3);
}

contract ExternalForHelloWExternal is Ownable, Destroyable{
    
    HelloWExternal instance = HelloWExternal(0x9d83e140330758a8fFD07F8Bd73e86ebcA8a5692);
    
    function externalgetPerson () public view returns (string memory nameE4, uint ageE4, uint heightE4, bool alreadyTwentyOneE4) {
        instance.getPerson();
    }
    
    //this function calls the createPerson function in HelloWExternal.sol and forwards any ether to that contract as well
    function externalCreatePerson (string memory nameE1, uint ageE1, uint heightE1) public payable {
        
        //the double parenthesis should be read as getting executed in order from left to right. It's like a modification to the functiona call 
        instance.createPerson.value(msg.value)(nameE1, ageE1, heightE1); 
    }
    
    
     
    
    
}