CLASS zcl_sci_longdoc_check_category DEFINITION INHERITING FROM cl_ci_category_root PUBLIC CREATE PUBLIC FINAL.
  PUBLIC SECTION.
    METHODS:
      constructor.

  PRIVATE SECTION.
    CONSTANTS:
      c_category    TYPE string VALUE 'CL_CI_CATEGORY_TOP',
      c_position    TYPE synum03 VALUE '999',
      c_description TYPE string VALUE 'Custom checks: long docs presence (objects and interfaces)' ##NO_TEXT.
ENDCLASS.

CLASS zcl_sci_longdoc_check_category IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    description = c_description.
    category = c_category.
    position = c_position.
  ENDMETHOD.
ENDCLASS.
