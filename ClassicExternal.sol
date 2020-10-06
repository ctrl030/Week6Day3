import "./Destroyable.sol";

pragma solidity 0.5.12;

contract classicToGetCalled {
    function createPerson (string memory name1, uint age1, uint height1) public payable; 
    
}

contract externalCreatePerson is Destroyable {
    // IClassicToBeCalled externalContract;
    // constructor (address externalAddress) {
    //0xddaAd340b0f1Ef65169Ae5E41A8b10776a75482d
    //     externalContract = IClassicToBeCalled( externalAddress );
    //}
    
   // put in the correct address of the deployed contract to be called
   classicToGetCalled externalContract = classicToGetCalled (0xd9145CCE52D386f254917e481eB44e9943F39138);
   
    function classicExternalCaller (string memory nameE2, uint ageE2, uint heightE2) public payable {
                                
        externalContract.createPerson.value(msg.value)(nameE2, ageE2, heightE2);
        
    }
}