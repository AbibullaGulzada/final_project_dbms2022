import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { Router, Route } from '@angular/router';
import { NzMessageService } from 'ng-zorro-antd/message';


import { User } from '../../models/user.model';
import { LoginService } from './login.service';
@Component({
  selector: 'app-welcome',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.css']
})
export class LoginComponent implements OnInit {

  validateForm!: FormGroup;
  selectedMode="login";

  submitForm(): void {
    for (const i in this.validateForm.controls) {
      this.validateForm.controls[i].markAsDirty();
      this.validateForm.controls[i].updateValueAndValidity();
    }
  }

  constructor(private fb: FormBuilder, private router: Router, private loginService: LoginService, private message: NzMessageService) {}

  ngOnInit(): void {
    if( localStorage.getItem("user")){
      this.router.navigate(['./main']);
    }
    this.validateForm = this.fb.group({
      userName: [null, [Validators.required]],
      password: [null, [Validators.required]],
      remember: [true],
    });
  }

  changeMode(): void{
    if(this.selectedMode == 'login'){
      this.selectedMode = "reg";
      this.validateForm.addControl('mobileNumber', new FormControl('', [Validators.required, Validators.pattern("^((\\+91-?)|0)?[0-9]{10}$")]));
      this.validateForm.addControl('mobilePrefix', new FormControl(8));
    }
    else{
      this.selectedMode = "login"
      this.validateForm.removeControl("mobileNumber");
      this.validateForm.removeControl("mobilePrefix");
    }
  }

  onRegister(){
    const req: User = {
      name : this.validateForm.get('userName').value,
      phone : this.validateForm.get('mobilePrefix').value + this.validateForm.get('mobileNumber').value,
      password: this.validateForm.get('password').value
    }
    this.loginService.Register(req)
      .subscribe(arg => {
        this.message.info('You are registered succesfully');
        this.selectedMode= "login";
      });


  }

  onLogin(){
    const req: User = {
      name : this.validateForm.get('userName').value,
      password: this.validateForm.get('password').value
    }
    this.loginService.Login(req)
      .subscribe(arg => {
        this.message.info('You are registered succesfully');
        const dataToSave = {
          user: arg.NICKNAME,
          phone: arg.PHONE_NUMBER,
          id: arg.USER_ID
        }
        console.log(arg)
        localStorage.setItem("user", JSON.stringify(dataToSave));
        this.router.navigate(['./main']);
      });
  }
}
