# [ABAP] Code Inspector custom check - presence of long documentation
This custom check checks whether the checked object or interface has long documentation created for itself and for public or protected members (properties, methods, events).
![example](http://public_repo.vipserv.org/images/sci/inspecition.png)

Long documentation is the one created/accessed via F9, Ctrl+Shift+F9 in SAP GUI ABAP editor.
The code is intentionally written without NW 7.4 (and higher) ABAP syntax. 

## Installation
First, get the code:  
- Install via [abapGit](https://github.com/larshp/abapGit)  
- or manually: create and paste the code for classes: *zcl_sci_longdoc_check.clas.abap*, *zcl_sci_longdoc_check_category.clas.abap*. In ZCL_SCI_LONGDOC_CHECK paste *zcl_sci_longdoc_check.clas.locals_def* in the  Class-relevant Local Types; it's implementation *zcl_sci_longdoc_check.clas.locals_imp* paste to "Local Types" include. Next, update the constants in your ZCL_SCI_LONGDOC_CHECK to match your class names:      
```ABAP
 CONSTANTS:
      c_class_name  TYPE seoclsname VALUE 'ZCL_SCI_LONGDOC_CHECK' ##NO_TEXT,
      c_category    TYPE string VALUE 'ZCL_SCI_LONGDOC_CHECK_CATEGORY' ##NO_TEXT,
```
  
Secondly, install the check:
- in SCI transaction, menu Code Inspector -> Management of -> Tests
- find the installed classes and check them, save
- from now on the new check should be available to select in Check Variant configuration

## Configuration
### Error types for inspection
After selecting the check in Check Variant, maintain the error types when long documentation is missing for the main object/interface and when docs are not present for public members:
![attributes](http://public_repo.vipserv.org/images/sci/sci_attributes.png)  
Possible values: error, warning, info, no message.

### Excluding names
To exclude given names during inspection, place a comment prefixed with SCI_LDE (anywhere in the source code) 
```ABAP
"SCI_LDE: member_name
```

## License
This extension is licensed under the [MIT license](http://opensource.org/licenses/MIT).

## Author
Feel free to contact me:  
- wozjac@zoho.com
- [jacekw.dev](https://jacekw.dev)
- Bluesky (<https://jacekwoz.bsky.social>)  
- LinkedIn (https://www.linkedin.com/in/jacek-wznk)
