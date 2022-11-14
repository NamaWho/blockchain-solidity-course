# Personal Notes

## Simple Storage

### View and Pure Functions
A function can be either *pure* or *view*. Both of them disallow modification of state. When called, **they don't spend gas**.
- *view*, means that it allows only to read the state of the contract.
- *pure*, means that additionally disallow you to read from blockchain state. (e.g. function which returns (1+1)). When calling a pure function you don't make a transaction, you're just reading off-chain.
If a gas calling function calls a view or pure function - only then will it cost gas.

### Arrays
There can be both *fixed-size* array and *dynamic* array.

```typescript 
People[] public people;
People[3] public people;

function addPerson(string memory _name, uint256 _favoriteNumber) public {
    people.push(People(_favoriteNumber, _name));
   
    // or 
    People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
    people.push(newPerson);
    
    // or 
    People memory newPerson = People(_favoriteNumber, _name); // same order of the declaration of People struct 
    people.push(newPerson);
}
```

### Basic solidity Memory, Storage & Calldata 
There are 6 places where EVM can access and store information: 
- stack
- **memory**
- **storage**
- **calldata**
- code
- logs

Calldata & Memory keywords means that the identifier only exist temporarily, during the transaction which is being performed.
On the other hand, Storage identifiers refer to a contract state variable.

By default, a local declared variable is a storage variable. 

Calldata is a temporary variable that **can't** be modified.
Memory is a temporary variable that **can** be modified.
Storage is a permanent variable that **can** be modified.

> Data location can only be specified for array (strings included), struct or mapping types.

### Mapping
A mapping is a data structure where a key is "mapped" to a single value.

```typescript
mapping(string => uint256) public nameToFavoriteNumber;
```