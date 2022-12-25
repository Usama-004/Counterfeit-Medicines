// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract ApprovedManufacturerList
{
    // DECLARATIONS
    address private Owner;

    mapping(address=>bool) private validManufacturers;

    // Initializes the state by setting the owner as the DRAP's address
    constructor()
    {   
        Owner = msg.sender;
    }

    // function to get address of the owner of this contract. Must be DRAP's address.
    function getOwner() public view returns(address)
    {
        return Owner;
    }

    // function to add a new manufacturer to the AML. Only DRAP can add to AML. 
    function addManufacturer(address manufacturer) public
    {
        require(msg.sender == Owner,"Only the owner DRAP can add a manufacturer from Approved Manufacturer List (AML).");
        validManufacturers[manufacturer] = true;
    }
    
    // function to remove a manufacturer from the AML. Only DRAP can add to AML. 
    function removeValidManufacturer(address manufacturer) public 
    {
        require(msg.sender == Owner,"Only the owner DRAP can remove a manufacturer from the Approved Manufacturer List (AML).");
        delete validManufacturers[manufacturer];
    }

    // function to check if a manufacturer is from AML. 
    function verifyManufacturer(address manufacturer) public view returns (bool)
    {
        return (validManufacturers[manufacturer] == true);
    }
}
