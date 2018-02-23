pragma solidity ^0.4.14;
contract Payroll {
    uint salary = 1 ether;
    address employer = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    address employee = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    uint constant payDuration = 10 seconds;
    uint lastPayday = now;
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        return  this.balance / salary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function getPaid() {
        if (msg.sender != employee) {
            revert();
        }
        uint nextPayDay = lastPayday + payDuration;
        if (now < nextPayDay) {
            revert();
        }
        lastPayday = nextPayDay;
        employee.transfer(salary);
        
    }
    
    function updateEmployee(address newAddress, uint newSalary) {
        if (msg.sender != employer) {
            revert();
        }
        employee = newAddress;
        salary = newSalary * 1 ether;
    }
    
}