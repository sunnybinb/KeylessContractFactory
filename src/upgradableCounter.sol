import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract UpgradableCounter is UUPSUpgradeable {
    uint256 public count;

    function initialize() public initializer {
        count = 0;
    }

    function increment() public {
        count++;
    }

    function _authorizeUpgrade(address newImplementation) internal override {
        require(newImplementation != address(0), "Cannot upgrade to the zero address");
    }
}