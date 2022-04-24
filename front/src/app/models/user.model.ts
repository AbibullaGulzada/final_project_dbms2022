export class User {
    name: string;
    password: string;
    phone?: string;
}

export class UserResp{
  NICKNAME: string;
  PASS: string;
  PASS_SALT: string;
  PHONE_NUMBER: string;
  USER_ID: number;
}
