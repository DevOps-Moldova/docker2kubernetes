import { Component, OnInit } from '@angular/core';
import { Employee } from 'src/app/models/employee.model';
import { TutorialService } from 'src/app/services/employee.service';

@Component({
  selector: 'app-add-tutorial',
  templateUrl: './add-tutorial.component.html',
  styleUrls: ['./add-tutorial.component.css']
})
export class AddTutorialComponent implements OnInit {

  employee: Employee = {
    firstName: '',
    lastname: '',
    salary: 0
  };
  submitted = false;

  constructor(private employeeService: TutorialService) { }

  ngOnInit(): void {
  }

  saveEmployee(): void {
    const data = this.employee;

    this.employeeService.create(data)
      .subscribe({
        next: (res) => {
          console.log(res);
          this.submitted = true;
        },
        error: (e) => console.error(e)
      });
  }

  newEmployee(): void {
    this.submitted = false;
    this.employee = {
      firstName: '',
      lastname: '',
      salary: 0
    };
  }

}
