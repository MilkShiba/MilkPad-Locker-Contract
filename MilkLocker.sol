
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

/**
 * @dev Library for managing
 * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
 * types.
 *
 * Sets have the following properties:
 *
 * - Elements are added, removed, and checked for existence in constant time
 * (O(1)).
 * - Elements are enumerated in O(n). No guarantees are made on the ordering.
 *
 * ```
 * contract Example {
 *     // Add the library methods
 *     using EnumerableSet for EnumerableSet.AddressSet;
 *
 *     // Declare a set state variable
 *     EnumerableSet.AddressSet private mySet;
 * }
 * ```
 *
 * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
 * and `uint256` (`UintSet`) are supported.
 */
library EnumerableSet {
    // To implement this library for multiple types with as little code
    // repetition as possible, we write it in terms of a generic Set type with
    // bytes32 values.
    // The Set implementation uses private functions, and user-facing
    // implementations (such as AddressSet) are just wrappers around the
    // underlying Set.
    // This means that we can only create new EnumerableSets for types that fit
    // in bytes32.

    struct Set {
        // Storage of set values
        bytes32[] _values;
        // Position of the value in the `values` array, plus 1 because index 0
        // means a value is not in the set.
        mapping(bytes32 => uint256) _indexes;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function _add(Set storage set, bytes32 value) private returns (bool) {
        if (!_contains(set, value)) {
            set._values.push(value);
            // The value is stored at length-1, but we add 1 to all indexes
            // and use 0 as a sentinel value
            set._indexes[value] = set._values.length;
            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function _remove(Set storage set, bytes32 value) private returns (bool) {
        // We read and store the value's index to prevent multiple reads from the same storage slot
        uint256 valueIndex = set._indexes[value];

        if (valueIndex != 0) {
            // Equivalent to contains(set, value)
            // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
            // the array, and then remove the last element (sometimes called as 'swap and pop').
            // This modifies the order of the array, as noted in {at}.

            uint256 toDeleteIndex = valueIndex - 1;
            uint256 lastIndex = set._values.length - 1;

            if (lastIndex != toDeleteIndex) {
                bytes32 lastValue = set._values[lastIndex];

                // Move the last value to the index where the value to delete is
                set._values[toDeleteIndex] = lastValue;
                // Update the index for the moved value
                set._indexes[lastValue] = valueIndex; // Replace lastValue's index to valueIndex
            }

            // Delete the slot where the moved value was stored
            set._values.pop();

            // Delete the index for the deleted slot
            delete set._indexes[value];

            return true;
        } else {
            return false;
        }
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function _contains(Set storage set, bytes32 value) private view returns (bool) {
        return set._indexes[value] != 0;
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function _length(Set storage set) private view returns (uint256) {
        return set._values.length;
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function _at(Set storage set, uint256 index) private view returns (bytes32) {
        return set._values[index];
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function _values(Set storage set) private view returns (bytes32[] memory) {
        return set._values;
    }

    // Bytes32Set

    struct Bytes32Set {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _add(set._inner, value);
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
        return _remove(set._inner, value);
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
        return _contains(set._inner, value);
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(Bytes32Set storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
        return _at(set._inner, index);
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(Bytes32Set storage set) internal view returns (bytes32[] memory) {
        return _values(set._inner);
    }

    // AddressSet

    struct AddressSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(AddressSet storage set, address value) internal returns (bool) {
        return _add(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(AddressSet storage set, address value) internal returns (bool) {
        return _remove(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(AddressSet storage set, address value) internal view returns (bool) {
        return _contains(set._inner, bytes32(uint256(uint160(value))));
    }

    /**
     * @dev Returns the number of values in the set. O(1).
     */
    function length(AddressSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(AddressSet storage set, uint256 index) internal view returns (address) {
        return address(uint160(uint256(_at(set._inner, index))));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(AddressSet storage set) internal view returns (address[] memory) {
        bytes32[] memory store = _values(set._inner);
        address[] memory result;

        assembly {
            result := store
        }

        return result;
    }

    // UintSet

    struct UintSet {
        Set _inner;
    }

    /**
     * @dev Add a value to a set. O(1).
     *
     * Returns true if the value was added to the set, that is if it was not
     * already present.
     */
    function add(UintSet storage set, uint256 value) internal returns (bool) {
        return _add(set._inner, bytes32(value));
    }

    /**
     * @dev Removes a value from a set. O(1).
     *
     * Returns true if the value was removed from the set, that is if it was
     * present.
     */
    function remove(UintSet storage set, uint256 value) internal returns (bool) {
        return _remove(set._inner, bytes32(value));
    }

    /**
     * @dev Returns true if the value is in the set. O(1).
     */
    function contains(UintSet storage set, uint256 value) internal view returns (bool) {
        return _contains(set._inner, bytes32(value));
    }

    /**
     * @dev Returns the number of values on the set. O(1).
     */
    function length(UintSet storage set) internal view returns (uint256) {
        return _length(set._inner);
    }

    /**
     * @dev Returns the value stored at position `index` in the set. O(1).
     *
     * Note that there are no guarantees on the ordering of values inside the
     * array, and it may change when more values are added or removed.
     *
     * Requirements:
     *
     * - `index` must be strictly less than {length}.
     */
    function at(UintSet storage set, uint256 index) internal view returns (uint256) {
        return uint256(_at(set._inner, index));
    }

    /**
     * @dev Return the entire set in an array
     *
     * WARNING: This operation will copy the entire storage to memory, which can be quite expensive. This is designed
     * to mostly be used by view accessors that are queried without any gas fees. Developers should keep in mind that
     * this function has an unbounded cost, and using it as part of a state-changing function may render the function
     * uncallable if the set grows to a point where copying to memory consumes too much gas to fit in a block.
     */
    function values(UintSet storage set) internal view returns (uint256[] memory) {
        bytes32[] memory store = _values(set._inner);
        uint256[] memory result;

        assembly {
            result := store
        }

        return result;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint256);
    function decimals() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract MilkLocker{

    using EnumerableSet for EnumerableSet.AddressSet;
    using EnumerableSet for EnumerableSet.UintSet;
    struct Locker{
        address owner;
        address token;
        uint256 lockerBalance;
        uint256 lockTime;
        uint256 unlockTime;
        string name;
        string symbol;
        uint256 decimals;
        uint256 totalSupply;
        address token0;
        address token1;
        string token1Symbol;
        address dex;
    }
    
    mapping(address => EnumerableSet.UintSet) private tokenLockerIndices;
    mapping(address => EnumerableSet.UintSet) private liquidityLockerIndices;

    Locker[] public lockers;

    EnumerableSet.AddressSet private tokenAddresses;    
    EnumerableSet.AddressSet private liquidityAddresses;    
    mapping(address => EnumerableSet.UintSet) private ownedTokenLockerIndices;
    mapping(address => EnumerableSet.UintSet) private ownedLiquidityLockerIndices;
    constructor(){}

    function viewLockerAt(uint256 lockerIndex) external view returns (Locker memory) {
         return lockers[lockerIndex];   
    }

    function viewSummedTokenOrLiquidityLockerForAddress(address addy, bool showLiquidityAddress) external view returns (Locker memory){

        uint256 numLockedTokens;
        uint256 _numLockers;
                
        if (showLiquidityAddress){ 
            _numLockers = liquidityLockerIndices[addy].length();
            for(uint256 i=0;i< _numLockers;i++){
                numLockedTokens += lockers[liquidityLockerIndices[addy].at(i)].lockerBalance;
            }
            Locker memory data = Locker(lockers[liquidityLockerIndices[addy].at(0)].owner, lockers[liquidityLockerIndices[addy].at(0)].token, 
            numLockedTokens, 
             lockers[liquidityLockerIndices[addy].at(0)].lockTime, lockers[liquidityLockerIndices[addy].at(0)].unlockTime,
             lockers[liquidityLockerIndices[addy].at(0)].name, lockers[liquidityLockerIndices[addy].at(0)].symbol, 
             lockers[liquidityLockerIndices[addy].at(0)].decimals, lockers[liquidityLockerIndices[addy].at(0)].totalSupply, 
             lockers[liquidityLockerIndices[addy].at(0)].token0, lockers[liquidityLockerIndices[addy].at(0)].token1, 
             lockers[liquidityLockerIndices[addy].at(0)].token1Symbol, lockers[liquidityLockerIndices[addy].at(0)].dex);
            return data;
        }
        else{
             _numLockers = tokenLockerIndices[addy].length();
            for(uint256 i=0;i< _numLockers;i++){
                numLockedTokens += lockers[tokenLockerIndices[addy].at(i)].lockerBalance;
            }
            Locker memory data = Locker(lockers[tokenLockerIndices[addy].at(0)].owner, lockers[tokenLockerIndices[addy].at(0)].token, 
            numLockedTokens, 
             lockers[tokenLockerIndices[addy].at(0)].lockTime, lockers[tokenLockerIndices[addy].at(0)].unlockTime,
             lockers[tokenLockerIndices[addy].at(0)].name, lockers[tokenLockerIndices[addy].at(0)].symbol, 
             lockers[tokenLockerIndices[addy].at(0)].decimals, lockers[tokenLockerIndices[addy].at(0)].totalSupply, 
             lockers[tokenLockerIndices[addy].at(0)].token0, lockers[tokenLockerIndices[addy].at(0)].token1, 
             lockers[tokenLockerIndices[addy].at(0)].token1Symbol, lockers[tokenLockerIndices[addy].at(0)].dex);
             return data;
        }

    }
    
    function viewSummedTokenOrLiquidityLockerForAddressAt(uint256 addressIndex, bool showLiquidityAddress) external view returns (Locker memory){
        uint256 numLockedTokens;
        uint256 _numLockers;
        
        if(showLiquidityAddress){
            address liquidityAddy = liquidityAddresses.at(addressIndex);
            _numLockers = liquidityLockerIndices[liquidityAddy].length();
            for(uint256 i=0;i< _numLockers;i++){
                numLockedTokens += lockers[liquidityLockerIndices[liquidityAddy].at(i)].lockerBalance;
            }
            Locker memory data = Locker(lockers[liquidityLockerIndices[liquidityAddy].at(0)].owner, lockers[liquidityLockerIndices[liquidityAddy].at(0)].token, 
            numLockedTokens, 
             lockers[liquidityLockerIndices[liquidityAddy].at(0)].lockTime, lockers[liquidityLockerIndices[liquidityAddy].at(0)].unlockTime,
             lockers[liquidityLockerIndices[liquidityAddy].at(0)].name, lockers[liquidityLockerIndices[liquidityAddy].at(0)].symbol, 
             lockers[liquidityLockerIndices[liquidityAddy].at(0)].decimals, lockers[liquidityLockerIndices[liquidityAddy].at(0)].totalSupply, 
             lockers[liquidityLockerIndices[liquidityAddy].at(0)].token0, lockers[liquidityLockerIndices[liquidityAddy].at(0)].token1, 
             lockers[liquidityLockerIndices[liquidityAddy].at(0)].token1Symbol, lockers[liquidityLockerIndices[liquidityAddy].at(0)].dex);
            return data;
        }
        else{
            address tokenAddy = tokenAddresses.at(addressIndex);
            _numLockers = tokenLockerIndices[tokenAddy].length();
            for(uint256 i=0;i< _numLockers;i++){
                numLockedTokens += lockers[tokenLockerIndices[tokenAddy].at(i)].lockerBalance;
            }
            Locker memory data = Locker(lockers[tokenLockerIndices[tokenAddy].at(0)].owner, lockers[tokenLockerIndices[tokenAddy].at(0)].token, 
            numLockedTokens, lockers[tokenLockerIndices[tokenAddy].at(0)].lockTime, lockers[tokenLockerIndices[tokenAddy].at(0)].unlockTime,
             lockers[tokenLockerIndices[tokenAddy].at(0)].name, lockers[tokenLockerIndices[tokenAddy].at(0)].symbol, 
             lockers[tokenLockerIndices[tokenAddy].at(0)].decimals, lockers[tokenLockerIndices[tokenAddy].at(0)].totalSupply, 
             lockers[tokenLockerIndices[tokenAddy].at(0)].token0, lockers[tokenLockerIndices[tokenAddy].at(0)].token1, 
             lockers[tokenLockerIndices[tokenAddy].at(0)].token1Symbol, lockers[tokenLockerIndices[tokenAddy].at(0)].dex);
             return data;
        }
    }
    
    function viewLockerForTokenOrLiquidityAt(address token, uint256 lockerIndex, bool requestLiquidityLocker) external view returns (Locker memory) {
        if(requestLiquidityLocker){
            return lockers[liquidityLockerIndices[token].at(lockerIndex)];
        }
        else{
            return lockers[tokenLockerIndices[token].at(lockerIndex)];
        }
    }

    function viewOwnedTokenOrLiquidityLockerAt(uint256 lockerIndex, bool showLiquidityAddress) external view returns (Locker memory){

        if(showLiquidityAddress){
            return lockers[ownedLiquidityLockerIndices[msg.sender].at(lockerIndex)];
        }
        else{
            return lockers[ownedTokenLockerIndices[msg.sender].at(lockerIndex)];
        } 
    }

    function numLockers() external view returns (uint256) {
        return lockers.length;
    }

    function numLockersForTokenOrLiquidity(address token, bool requestLiquidityLocker) external view returns (uint256) {
        if(requestLiquidityLocker){
            return liquidityLockerIndices[token].length();
        }
        else{
            return tokenLockerIndices[token].length();
        }   
    }

    function numLockersForWallet(address wallet, bool requestLiquidityLocker) external view returns (uint256) {
        if(requestLiquidityLocker){
            return ownedLiquidityLockerIndices[wallet].length();
        }
        else{
            return ownedTokenLockerIndices[wallet].length();
        } 
    }

    function viewLockerAddressAt(uint256 addressIndex, bool requestLiquidityLocker) external view returns (address) {
        if(requestLiquidityLocker){
            return liquidityAddresses.at(addressIndex);
        }
        else{
            return tokenAddresses.at(addressIndex);
        }
    }    

    function numLockerAddresses(bool requestLiquidityLocker) external view returns (uint256) {
       if(requestLiquidityLocker){
            return liquidityAddresses.length();
        }
        else{
            return tokenAddresses.length();
        }
    }

    function viewLockerIndex(address token, uint256 lockerIndex, bool requestLiquidityLocker) external view returns (uint256) {
        if(requestLiquidityLocker){
            return liquidityLockerIndices[token].at(lockerIndex);
        }
        else{
            return tokenLockerIndices[token].at(lockerIndex);
        }
    }
    function viewOwnedLockerIndex(uint256 lockerIndex, bool requestLiquidityLocker) external view returns (uint256) {
        if(requestLiquidityLocker){
            return ownedLiquidityLockerIndices[msg.sender].at(lockerIndex);
        }
        else{
            return ownedTokenLockerIndices[msg.sender].at(lockerIndex);
        }
    }
   
    function extendLockDurationForTokenAt(
        uint256 lockerIndex, uint256 absoluteUnlockTime, uint256 unlockTimeIncreaseSeconds, 
        bool useAbsoluteUnlockTime, bool requestLiquidityLocker) external {

        if(requestLiquidityLocker){
            require(msg.sender == lockers[ lockerIndex ].owner, "Only the locker owner may extend!");
            if(useAbsoluteUnlockTime){
                require(absoluteUnlockTime > lockers[lockerIndex].unlockTime, "May only extend lock duration.");
                lockers[lockerIndex].unlockTime = absoluteUnlockTime;
            }
            else{
                lockers[lockerIndex].unlockTime += unlockTimeIncreaseSeconds;
            }
        }
        else{
            require(msg.sender == lockers[ lockerIndex ].owner, "Only the locker owner may extend!");
            if(useAbsoluteUnlockTime){
                require(absoluteUnlockTime > lockers[lockerIndex].unlockTime, "May only extend lock duration.");
                lockers[lockerIndex].unlockTime = absoluteUnlockTime;
            }
            else{
                lockers[lockerIndex].unlockTime += unlockTimeIncreaseSeconds;
            }
        }
    }

    function transferOwnership(uint256 lockerIndex, address newOwner, bool requestLiquidityLocker) external {
        if(requestLiquidityLocker){
            require(msg.sender == lockers[lockerIndex ].owner, "Only the locker owner may transfer ownership!");    
            ownedLiquidityLockerIndices[msg.sender].remove(lockerIndex);  
                      
            ownedLiquidityLockerIndices[newOwner].add(lockerIndex);            
            lockers[lockerIndex].owner = newOwner;
        }
        else{
            require(msg.sender == lockers[lockerIndex].owner, "Only the locker owner may transfer ownership!");    
            ownedTokenLockerIndices[msg.sender].remove(lockerIndex);            

            ownedTokenLockerIndices[newOwner].add(lockerIndex);            
            lockers[lockerIndex].owner = newOwner;
        }
    }
 
    function lockTokens(address token, uint256 tokenAmount, uint256 lockTimeSeconds, 
     string memory name, string memory symbol, uint256 decimals, uint256 totalSupply,
      address token0, address token1, string memory token1Symbol, address dex, 
      bool requestLiquidityLocker) external {
          safeDeposit(token, tokenAmount);
          _lock( token,  tokenAmount,  lockTimeSeconds, 
                   name,   symbol,  decimals,  totalSupply,
                  token0,  token1,   token1Symbol,  dex);
        if(requestLiquidityLocker){
            if (liquidityAddresses.contains(token) == false){
                liquidityAddresses.add(token);
            }
            liquidityLockerIndices[token].add(lockers.length-1);
            ownedLiquidityLockerIndices[tx.origin].add(lockers.length-1); 
        }
        else{
            if (tokenAddresses.contains(token) == false){
                tokenAddresses.add(token);
            }
           tokenLockerIndices[token].add(lockers.length-1);
           ownedTokenLockerIndices[tx.origin].add(lockers.length-1);   
        } 
         
    }
    function safeDeposit(address token, uint256 amount) internal {

        uint256 balanceBefore = IERC20(token).balanceOf(address(this));
        IERC20(token).transferFrom(msg.sender, address(this), amount);
        
        require(balanceBefore + amount == IERC20(token).balanceOf(address(this)), "Owner must receive full locker amount.");
    }

    function _lock (
        address token, uint256 tokenAmount, uint256 lockTimeSeconds, 
        string memory name, string memory symbol, uint256 decimals, 
        uint256 totalSupply, address token0, address token1, 
        string memory token1Symbol, address dex) internal {
          
          Locker memory newLocker =  Locker(tx.origin, token, tokenAmount,  block.timestamp, block.timestamp + lockTimeSeconds,
            name, symbol, decimals, totalSupply,
            token0, token1, token1Symbol, dex);  
            lockers.push(newLocker);
    }
    
    function withdrawAt(uint256 lockerIndex) external {
        require(block.timestamp >= lockers[lockerIndex].unlockTime, "Tokens have yet to unlock!");
        require(msg.sender == lockers[lockerIndex].owner, "Only the locker owner may unlock!");
        uint256 lockerBalance = lockers[lockerIndex].lockerBalance;
        lockers[lockerIndex].lockerBalance = 0;
        address token = lockers[lockerIndex].token;
        uint256 balanceBefore = IERC20(token).balanceOf(lockers[lockerIndex].owner);

        IERC20(lockers[lockerIndex].token).transfer(lockers[lockerIndex].owner, lockerBalance);

        require(balanceBefore + lockerBalance == IERC20(token).balanceOf(lockers[lockerIndex].owner), "Owner must receive full locker amount.");

        if(lockers[lockerIndex].dex != address(0x0)){
            ownedLiquidityLockerIndices[msg.sender].remove(lockerIndex);
            liquidityLockerIndices[token].remove(lockerIndex);
            if(liquidityLockerIndices[token].length() == 0){
                liquidityAddresses.remove(token);
            }
        }
        else{
            ownedTokenLockerIndices[msg.sender].remove(lockerIndex); 
            tokenLockerIndices[token].remove(lockerIndex); 
            if(tokenLockerIndices[token].length() == 0){
                tokenAddresses.remove(token);
            }  
        }
    }
}