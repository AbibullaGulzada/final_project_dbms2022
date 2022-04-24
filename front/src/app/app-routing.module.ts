import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { WelcomeModule } from './pages/login/welcome.module';
import { MainPageModule } from './pages/main-page/main.module';

const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: '/login' },
  { path: 'login', loadChildren: () => import('./pages/login/welcome.module').then(m => WelcomeModule) },
  { path: 'main' ,loadChildren: () => import('./pages/main-page/main.module').then(m => MainPageModule)}
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
