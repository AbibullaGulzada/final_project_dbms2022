import { Injectable } from '@angular/core';
import { User, UserResp } from '../../models/user.model';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { environment } from '../../../environments/environment';
import { Observable } from 'rxjs';
@Injectable({
    providedIn: 'root'
})
export class LoginService {
    selectedUser: User = {
        name: '',
        password: ''
    }

    constructor(private http: HttpClient  ){}

    Register(user: User){
        return this.http.post(environment.apiBaseUrl + '/register', user )
    }

    Login(user:User):Observable<UserResp> {
      return this.http.post<UserResp>(environment.apiBaseUrl + '/auth', user )
    }

}
