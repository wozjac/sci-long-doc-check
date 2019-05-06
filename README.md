# [ABAP] Code Inpsector custom check - presence of long documentation
This custom check checks whether the checked object or interface has the long documentation created for itself and public members (properties, methods, events).

The code is intenionally written without NW 7.4 (and higher) ABAP syntax. 

## Installation
First, get the code:  
- Install via [abapGit](https://github.com/larshp/abapGit)  
- or manually: create and paste the code for classes: ... ... In ... paste in the  Class-relevant Local Types; it's implementation paste to "Local Types" include. Next, update the constants in ... to match your class names:      
```ABAP
 CONSTANTS:
      c_class_name  TYPE seoclsname VALUE 'ZT38MP_CL_ZZ_CI_LDOC_CHECK' ##NO_TEXT,
      c_category    TYPE string VALUE 'ZT38MP_CL_ZZ_CI_DOC_CATEGORY' ##NO_TEXT,
```
  
Secondly, install the check:
- in SCI transaction menu Code Inspector -> Management od -> Tests
- find the installed classes and check them, save
- from now on the new check should be available to select in Check Variant configuration

## Configuration

## License
This extension is licensed under the [MIT license](http://opensource.org/licenses/MIT).

## Author
Feel free to contact me: wozjac@zoho.com or via LinkedIn (https://www.linkedin.com/in/jacek-wznk).
