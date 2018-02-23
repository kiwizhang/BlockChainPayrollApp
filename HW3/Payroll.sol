pragma solidity ^0.4.14;
import './SafeMath1.sol';
import './Ownable4.sol';
contract Payroll is Ownable {
    address owner; 
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    mapping(address => Employee) employees;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    modifier employeeExist(address employeeId){
        var employee =employees[employeeId];
        assert(employee.id != 0x0);
        _;
    }
    
    modifier employeeUnExist(address employeeId){
        var employee =employees[employeeId];
        assert(employee.id == 0x0);
        _;
    }
    
    function addEmployee (address employeeId, uint salary) onlyOwner {
        var employee = employees[employeeId];
        assert(employee.id == 0x0);
        employees[employeeId] = Employee(employeeId, salary * 1 ether, now);
        totalSalary += salary * 1 ether;
    }
    
    //  function updateEmployee(address employeeId, uint newSalary) onlyOwner employeeExist(employeeId) {
    //     var employee = employees[employeeId];
        
    //     _partialPaid(employee);
        
    //     totalSalary = totalSalary.sub(employees[employeeId].salary);
    //     employees[employeeId].salary = newSalary.mul(1 ether);
    //     totalSalary = totalSalary.add(employees[employeeId].salary);
    //     employees[employeeId].lastPayday = now;
    // }
    function updateEmployee(address employeeId, uint salary) onlyOwner employeeExist(employeeId){
        var employee = employees[employeeId];
        _partialPaid(employee);
        totalSalary += (salary * 1 ether - employee.salary);
        employees[employeeId].salary = salary * 1 ether;
        employees[employeeId].lastPayday = now;
        
    }
    
    function removeEmployee(address employeeId) onlyOwner employeeExist(employeeId) {
        var employee = employees[employeeId];
        totalSalary -= employee.salary;
        delete employees[employeeId];
    }
    
    function _partialPaid (Employee employee) private {
        uint payment = employee.salary * (now - employee.lastPayday) / payDuration;
        employee.id.transfer(payment);
    }
    
    function addFund() payable returns (uint) {
        return this.balance;
    }
    
    function calculateRunway() returns (uint) {
        assert (totalSalary != 0); 
        return  this.balance / totalSalary;
    }
    
    function hasEnoughFund() returns (bool) {
        return calculateRunway() > 0;
    }
    
    function checkEmployee(address employeeId) returns (uint salary, uint lastPayday) {
        var employee = employees[employeeId];
        salary = employee.salary;
        lastPayday = employee.lastPayday;
    }
    
    function getPaid() employeeExist(msg.sender){
        var employee = employees[msg.sender];
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(now > nextPayDay);
        employees[msg.sender].lastPayday = nextPayDay;
        employees[msg.sender].id.transfer(employee.salary);
        
    }
   //owner change a employee's address
    function changePaymentAddress(address oldAddress, address newAddress) onlyOwner employeeExist(oldAddress) employeeUnExist(newAddress) {
        var employee = employees[oldAddress];
        employee.id = newAddress;
        employees[oldAddress] = employee;
        delete employees[oldAddress];
    }
    //employee change his/her own address
    function changePaymentAddress(address newAddress) employeeExist(msg.sender) employeeUnExist(newAddress) {
        var employee = employees[msg.sender];
        employee.id = newAddress;
        employees[newAddress] = employee;
        delete employees[msg.sender];
    }
}