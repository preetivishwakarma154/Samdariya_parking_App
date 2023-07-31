# samdriya

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


---------------

## Testing Report 

> Mobile Application | 25-07-2023 15:00

### User 

#### Login

```
Username : mukesh
Password : 12345 
```

- Validations

    * Empty Fields : **<g>PASS</g>**
    * Too Short Name : **<g>PASS</g>**
    * Wrong Info : `Login` display's validation when press `back` (*Invalid....*) **<r>FAIL</r>**
    * Username : *Casesensitive* **<r>FAIL</r>**
    * Login : **<g>PASS</g>**

#### Dashboard

```
- Summary | Logout (btns)

- Radio btns

- Input :
    Vehicle
    Phone Number (optional)

- Check In btn

- Popup
```

**Summary**

* First Login Summary : Blank **<r>FAIL</r>**
* Pressing back will close the app **<r>FAIL</r>**
* Print button missing **<r>FAIL</r>**
* Back btn : **<g>PASS</g>**
* Logout btn : Not working properly **<r>FAIL</r>**
```
Login page UI 
Fields Not working
Session expire not working
```

**Radio btns**

- `Layout`

- Validations 
    * Vehicle type can't be empty **<g>PASS</g>**

**Input**

- Validations 
    * Vehicle number can't be empty **<g>PASS</g>**
    * Please enter full 10 digit number **<g>PASS</g>**

**Check In** **<g>PASS</g>**

**Popup** **<g>PASS</g>**

**Logout** 

- Session expire **<r>FAIL</r>**

**Print** **<g>PASS</g>**
