import { NgModule } from '@angular/core';
import { FormsModule,ReactiveFormsModule } from '@angular/forms';
import { LoginRoutingModule } from './login-routing.module';
import { LoginComponent } from './login.component';
import { NgAntModule } from 'src/app/ng-antd.module';
import { CommonModule } from '@angular/common';



@NgModule({
  imports: [LoginRoutingModule,CommonModule,  NgAntModule,FormsModule,ReactiveFormsModule],
  declarations: [LoginComponent],
  exports: [LoginComponent]
})
export class WelcomeModule { }
