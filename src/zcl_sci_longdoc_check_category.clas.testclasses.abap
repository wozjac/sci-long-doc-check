CLASS lcl_unit_test DEFINITION FOR TESTING RISK LEVEL HARMLESS DURATION SHORT FINAL.
  PRIVATE SECTION.
    DATA:
      m_class_under_test TYPE REF TO zcl_sci_longdoc_check_category.
    METHODS:
      setup,
      has_correct_attributes FOR TESTING.
ENDCLASS.

CLASS lcl_unit_test IMPLEMENTATION.
  METHOD setup.
    CREATE OBJECT m_class_under_test.
  ENDMETHOD.

  METHOD has_correct_attributes.
    cl_abap_unit_assert=>assert_equals(
      exp = '999'
      act = m_class_under_test->position
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'CL_CI_CATEGORY_TOP'
      act = m_class_under_test->category
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'Custom checks: long docs presence (objects and interfaces)'
      act = m_class_under_test->description
    ).
  ENDMETHOD.
ENDCLASS.
