// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "wormhole-solidity-sdk/WormholeRelayerSDK.sol";
import "wormhole-solidity-sdk/interfaces/IERC20.sol";
import "wormhole-solidity-sdk/interfaces/IWETH.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

abstract contract WormholeInteractions is Ownable, TokenSender, TokenReceiver {
    uint256 constant GAS_LIMIT = 250_000;

    constructor(address _wormholeRelayer, address _tokenBridge, address _wormhole)
        TokenBase(_wormholeRelayer, _tokenBridge, _wormhole)
    {}

    function quoteCrossChainDeposit(uint16 targetChain) public view returns (uint256 cost) {
        // Cost of delivering token and payload to targetChain
        uint256 deliveryCost;
        (deliveryCost,) = wormholeRelayer.quoteEVMDeliveryPrice(targetChain, 0, GAS_LIMIT);

        // Total cost: delivery cost + cost of publishing the 'sending token' wormhole message
        cost = deliveryCost + wormhole.messageFee();
    }

    function sendNativeCrossChainDeposit(uint16 targetChain, address targetToken, address recipient, uint256 amount)
        public
        payable
    {
        uint256 cost = quoteCrossChainDeposit(targetChain);
        require(msg.value == cost + amount, "msg.value must be quoteCrossChainDeposit(targetChain) + amount");

        IWETH wrappedNativeToken = tokenBridge.WETH();
        wrappedNativeToken.deposit{value: amount}();

        bytes memory payload = abi.encode(recipient);
        sendTokenWithPayloadToEvm(
            targetChain,
            targetToken, // address (on targetChain) to send token and payload to
            payload,
            0, // receiver value
            GAS_LIMIT,
            address(wrappedNativeToken), // address of IERC20 token contract
            amount
        );
    }
}
