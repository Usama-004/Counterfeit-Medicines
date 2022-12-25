// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract MedicineTransferability
{
    // DECLARATIONS

    address private Owner;

    address private CurrentOwner;
    address[] private HistoryOfOwners;
    string private DataHash;
    uint private ExpiryDate;

    address private constant amlAddress = 0x5801bd1Be6e6093745FCafA18De4b11217dDD0CE; //address of AML contract

    ApprovedManufacturerList public aml;

    //Constructor verifies the address of the deployer by calling the DRAP's AML contract.
    //Only allows this smart contract to be deployed if it is by a valid manufacturer. 
    constructor(string memory dataHash, uint expiryDate)
    {   
        aml = ApprovedManufacturerList(amlAddress);
        Owner = msg.sender;
        
        require(aml.verifyManufacturer(Owner) == true, "Only the manufacturers approved by DRAP can sell the medicine.");
        
        CurrentOwner = msg.sender;
        HistoryOfOwners.push(msg.sender);
        DataHash=dataHash;
        ExpiryDate = expiryDate;
    }

    //Returns the complete list of owners of this medicine.
    function getHistoryOfOwners() public view returns(address[] memory)
    {
        return HistoryOfOwners;
    }

    //Returns the manufacturer of this medicine.
    function getOwner() public view returns(address)
    {
        return Owner;
    }

    //Returns the current owner of this medicine.
    function getCurrentOwner() public view returns(address)
    {
        return CurrentOwner;
    }

    //Returns the hash of this medicine.
    function getDataHash() public view returns(string memory)
    {
        return DataHash;
    }

    //Sells the medicine to the new owner. Only the current owner is allowed to call this function.
    //Only the unexpired medicines can be sold.
    function sellMedicine(address buyer) public 
    {
        require(msg.sender == CurrentOwner,"Only the current owner of this medicine can sell it.");
        require(block.timestamp > ExpiryDate,"The medicine has expired and can not be sold now.");

        HistoryOfOwners.push(buyer);
        CurrentOwner = buyer;

    }

    //Destroys this smart contract and transfers the remaining value to the customer.
    function destroy() public {
        require(msg.sender == CurrentOwner, "Only the current owner can destroy it.");
        selfdestruct(payable(CurrentOwner));
    }
}

//Interface for calling the functions of DRAP's ApprovedManufacturerList smart contract.
interface ApprovedManufacturerList{
    function verifyManufacturer(address) external view returns (bool);
}

 
