CLASS lcl_td_object_info DEFINITION INHERITING FROM lcl_object_info.
  PUBLIC SECTION.
    METHODS:
      get_attributes REDEFINITION,
      get_events REDEFINITION,
      get_methods REDEFINITION.
  PROTECTED SECTION.
    METHODS:
      get_object_metadata REDEFINITION.
ENDCLASS.

CLASS lcl_td_object_info IMPLEMENTATION.
  METHOD get_attributes.
    DATA: attribute LIKE LINE OF attributes.

    CASE m_object_name.
      WHEN 'CL_NO_DOC'.
      WHEN 'IF_NO_DOC'.
      WHEN 'CL_DOC'.
      WHEN 'IF_DOC'.
    ENDCASE.
  ENDMETHOD.

  METHOD get_events.
    CASE m_object_name.
      WHEN 'CL_NO_DOC'.
      WHEN 'IF_NO_DOC'.
      WHEN 'CL_DOC'.
      WHEN 'IF_DOC'.
    ENDCASE.
  ENDMETHOD.

  METHOD get_methods.
    CASE m_object_name.
      WHEN 'CL_NO_DOC'.
      WHEN 'IF_NO_DOC'.
      WHEN 'CL_DOC'.
      WHEN 'IF_DOC'.
    ENDCASE.
  ENDMETHOD.

  METHOD get_object_metadata.
    "do nothing
  ENDMETHOD.
ENDCLASS.

CLASS lcl_unit_test DEFINITION DEFERRED.
CLASS zcl_sci_longdoc_check DEFINITION LOCAL FRIENDS lcl_unit_test.

CLASS lcl_unit_test DEFINITION FOR TESTING DURATION SHORT RISK LEVEL HARMLESS FINAL.
  PRIVATE SECTION.
    DATA:
      m_class_under_test  TYPE REF TO zcl_sci_longdoc_check,
      m_td_object_info    TYPE REF TO lcl_td_object_info,
      m_attributes_buffer TYPE xstring.
    METHODS:
      setup,
      puts_attributes FOR TESTING,
      gets_attributes FOR TESTING,
      has_attributes_set FOR TESTING,
      gets_message_text FOR TESTING,
      no_error_if_has_doc FOR TESTING.
ENDCLASS.

CLASS lcl_unit_test IMPLEMENTATION.
  METHOD setup.
    CREATE OBJECT m_class_under_test.
    CREATE OBJECT m_td_object_info.
    m_class_under_test->m_object_info = m_td_object_info.

    EXPORT
      sci_long_doc_error_type = 'W'
      sci_member_doc_error_type = 'E'
      TO DATA BUFFER m_attributes_buffer.
  ENDMETHOD.

  METHOD puts_attributes.
    m_class_under_test->put_attributes( m_attributes_buffer ).

    cl_abap_unit_assert=>assert_equals(
     exp = 'E'
     act =  m_class_under_test->m_missing_member_error_type
   ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'W'
      act =  m_class_under_test->m_missing_long_doc_error_type
    ).
  ENDMETHOD.

  METHOD gets_attributes.
    DATA: long_doc_error_type TYPE sci_errty,
          member_error_type   TYPE sci_errty.

    m_class_under_test->m_missing_long_doc_error_type = 'N'.
    m_class_under_test->m_missing_member_error_type = 'W'.

    m_attributes_buffer = m_class_under_test->get_attributes( ).

    IMPORT
      sci_long_doc_error_type = long_doc_error_type
      sci_member_doc_error_type = member_error_type
      FROM DATA BUFFER m_attributes_buffer.

    cl_abap_unit_assert=>assert_equals(
      exp = 'N'
      act = long_doc_error_type
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'W'
      act = member_error_type
    ).
  ENDMETHOD.

  METHOD gets_message_text.
    DATA: message TYPE string.

    m_class_under_test->get_message_text(
      EXPORTING
        p_code = m_class_under_test->c_error_codes-no_main_documentation
        p_test = ''
      IMPORTING p_text = message
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'Long documentation missing: &1'
      act = message
    ).

    m_class_under_test->get_message_text(
      EXPORTING
        p_code = m_class_under_test->c_error_codes-no_attribute_documentation
        p_test = ''
      IMPORTING p_text = message
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'Long documentation missing: attribute &1'
      act = message
    ).

    m_class_under_test->get_message_text(
      EXPORTING
        p_code = m_class_under_test->c_error_codes-no_event_documentation
        p_test = ''
      IMPORTING p_text = message
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'Long documentation missing: event &1'
      act = message
    ).

    m_class_under_test->get_message_text(
      EXPORTING
        p_code = m_class_under_test->c_error_codes-no_method_documentation
        p_test = ''
      IMPORTING p_text = message
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'Long documentation missing: method &1'
      act = message
    ).

    m_class_under_test->get_message_text(
     EXPORTING
       p_code = '999'
       p_test = ''
     IMPORTING p_text = message
   ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'Unknown error code'
      act = message
    ).
  ENDMETHOD.

  METHOD has_attributes_set.
    cl_abap_unit_assert=>assert_equals(
      exp = 'Check long documentation for classes/interfaces and their members'
      act = m_class_under_test->description
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'ZCL_SCI_LONGDOC_CHECK_CATEGORY'
      act = m_class_under_test->category
    ).

    cl_abap_unit_assert=>assert_equals(
      exp = 'ZCL_SCI_LONGDOC_CHECK'
      act = m_class_under_test->c_class_name
    ).
  ENDMETHOD.

  METHOD no_error_if_has_doc.
    m_class_under_test->object_name = 'CL_DOC'.
    m_class_under_test->object_type = 'CLAS'.
    m_class_under_test->run( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = m_class_under_test->m_error_counter
    ).

    m_class_under_test->object_name = 'IF_DOC'.
    m_class_under_test->object_type = 'INTF'.
    m_class_under_test->run( ).

    cl_abap_unit_assert=>assert_equals(
      exp = 0
      act = m_class_under_test->m_error_counter
    ).
  ENDMETHOD.

ENDCLASS.
