pragma solidity ^0.4.14;

contract Payroll {
    address employer; 
    uint constant payDuration = 10 seconds;
    uint totalSalary;
    Employee[] employees;
    struct Employee {
        address id;
        uint salary;
        uint lastPayday;
    }
    
    function Payroll () {
        employer = msg.sender;
        totalSalary = 0;
    }
    
    function addEmployee (address employeeId, uint salary) {
        require(msg.sender == employer);
        var(employee, index)= _findEmployee(employeeId);
        assert(employee.id == 0x0);
        employees.push(Employee(employeeId, salary * 1 ether, now));
        totalSalary += salary * 1 ether;
    }
    
     
    function updateEmployee(address employeeId, uint salary) {
        require(msg.sender == employer);
        var(employee, index)= _findEmployee(employeeId);
        assert(employee.id != 0x0);
        _partialPaid(employee);
        totalSalary += (salary * 1 ether - employee.salary);
        employees[index].salary = salary * 1 ether;
        employees[index].lastPayday = now;
        
    }
    
    function removeEmployee(address employeeId) {
        require(msg.sender == employer);
        var(employee, index)= _findEmployee(employeeId);
        totalSalary -= employee.salary;
        delete employees[index];
        employees[index] = employees[employees.length-1];
        employees.length -= 1;
    }
    
    function _findEmployee (address employeeId) private returns(Employee, uint) {
        for (uint i = 0; i < employees.length; i++) {
            if (employees[i].id == employeeId) {
                return (employees[i], i);
            }
        }
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
    
    function getPaid() {
        var(employee, index)= _findEmployee(msg.sender);
        assert(employee.id != 0x0);
        uint nextPayDay = employee.lastPayday + payDuration;
        assert(now > nextPayDay);
        employees[index].lastPayday = nextPayDay;
        employees[index].id.transfer(employee.salary);
        
    }
   
    
}

/*
trasaction  execution
22966 gas   1694 gas 
23747 gas   2475 gas
24528 gas   3256 gas
25309 gas   4037 gas
26090 gas   4818 gas
26871 gas   5599 gas
27652 gas   6380 gas
28433 gas   7161 gas
29214 gas   7942 gas
29995 gas   8723 gas

*/
