// SPDX-License-Identifier: MIT
pragma solidity ^0.7.4;
pragma abicoder v2;
import "./OwnedToken.sol";


contract UserStoreAPI {

  struct User {
    bytes32 firstName;
    bytes32 lastName;
    bytes32 email;
    uint age;
    uint weight;
    uint height;
    uint index;
  }
  
  mapping(address => User) private users;
  address[] private userAddresses;

  event LogNewUser   (address indexed userAddress, User user);
  event LogUpdateUser(address indexed userAddress, User user);
  event LogDeleteUser(address indexed userAddress, uint index);
  event LogMsgSender(address msgSender);
  event LogAddress(address currentAddress);
  
  function createUserContract(bytes32 name) public returns (address newAddress) {
      address user = address(new OwnedToken(name));
      
      emit LogAddress(user);
      return user;
  }
  
  function isUser(address userAddress) public view returns(bool isIndeed) {
    if(userAddresses.length == 0) {
        return false;
    }
    return (userAddresses[users[userAddress].index] == userAddress);
  }

  function insertUser(address userAddress, bytes32 firstName, bytes32 lastName, bytes32 email, uint age, uint weight, uint height) public returns(uint index) {
    if(isUser(userAddress)) {
        revert(); 
    }
    users[userAddress].firstName = firstName;
    users[userAddress].lastName = lastName;
    users[userAddress].email = email;
    users[userAddress].age   = age;
    users[userAddress].weight = weight;
    users[userAddress].height = height;
    users[userAddress].index     = userAddresses.length;
    userAddresses.push(userAddress);
    
    emit LogNewUser(
        userAddress,
        users[userAddress]
    );
    return userAddresses.length - 1;
  }

  function deleteUser(address userAddress) public returns(uint index) {
    if(!isUser(userAddress)) {
        revert();
    }
    uint rowToDelete = users[userAddress].index;
    address keyToMove = userAddresses[userAddresses.length - 1];
    userAddresses[rowToDelete] = keyToMove;
    users[keyToMove].index = rowToDelete; 
    userAddresses.pop();
    
    emit LogDeleteUser(
        userAddress, 
        rowToDelete
    );
    emit LogUpdateUser(
        keyToMove,
        users[keyToMove]
    );
    return rowToDelete;
  }
  
  function getUser(address userAddress) public view returns(bytes32 firstName, bytes32 lastName, bytes32 email, uint age, uint weight, uint height, uint index) {
    if(!isUser(userAddress)) {
        revert();
    }
    return(
        users[userAddress].firstName,
        users[userAddress].lastName,
        users[userAddress].email,
        users[userAddress].age,
        users[userAddress].weight,
        users[userAddress].height,
        users[userAddress].index
      );
  } 
  
  function updateUserEmail(address userAddress, bytes32 email) public returns(bool success) {
    if(!isUser(userAddress)) {
        revert();
    }
    users[userAddress].email = email;
    emit LogUpdateUser(
        userAddress, 
        users[userAddress]
    );
    return true;
  }
  
  function updateUserAge(address userAddress, uint age) public returns(bool success) {
    if(!isUser(userAddress)) {
        revert();
    }
    users[userAddress].age = age;
    emit LogUpdateUser(
        userAddress,
        users[userAddress]
    );
    return true;
  }

  function getUserCount() public view returns(uint count) {
    return userAddresses.length;
  }

  function getUserAtIndex(uint index) public view returns(address userAddress) {
    return userAddresses[index];
  }
  
  function logSender() public {
      emit LogMsgSender(msg.sender);
  }
}
