import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { Observable } from 'rxjs';
import { Employee } from '../models/employee.model';

const baseUrl = '/api'; //const baseUrl = 'http://localhost:4200/api';

@Injectable({
  providedIn: 'root'
})
export class TutorialService {

  constructor(private http: HttpClient) { }

  getAll(): Observable<Employee[]> {
    return this.http.get<Employee[]>(`${baseUrl}/employee`);
  }

  get(id: any): Observable<Employee> {
    return this.http.get(`${baseUrl}/employee/${id}`);
  }

  create(data: any): Observable<any> {
    return this.http.post(`${baseUrl}/employee`, data);
  }

  update(id: any, data: any): Observable<any> {
    return this.http.put(`${baseUrl}/employee/${id}`, data);
  }

  delete(id: any): Observable<any> {
    return this.http.delete(`${baseUrl}/employee/${id}`);
  }

  deleteAll(): Observable<any> {
    return this.http.delete(baseUrl);
  }

  findByTitle(title: any): Observable<Employee[]> {
    return this.http.get<Employee[]>(`${baseUrl}?title=${title}`);
  }
}
