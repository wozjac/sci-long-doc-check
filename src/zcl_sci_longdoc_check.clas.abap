CLASS zcl_sci_longdoc_check DEFINITION PUBLIC INHERITING FROM cl_ci_test_scan CREATE PUBLIC.
  PUBLIC SECTION.
    CONSTANTS:
      BEGIN OF c_error_codes,
        no_main_documentation      TYPE sci_errc VALUE '001',
        no_attribute_documentation TYPE sci_errc VALUE '002',
        no_method_documentation    TYPE sci_errc VALUE '003',
        no_event_documentation     TYPE sci_errc VALUE '004',
      END OF c_error_codes.

    METHODS:
      constructor,
      get_attributes   REDEFINITION,
      get_message_text REDEFINITION,
      query_attributes REDEFINITION,
      put_attributes   REDEFINITION,
      run              REDEFINITION.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_member_document,
        document_id          TYPE doku_id,
        document_object_name TYPE dokhl-object,
        member_name          TYPE string,
      END OF ty_member_document.

    CONSTANTS:
      c_class_name          TYPE seoclsname VALUE 'ZCL_SCI_LONGDOC_CHECK' ##NO_TEXT,
      c_category            TYPE string VALUE 'ZCL_SCI_LONGDOC_CHECK_CATEGORY' ##NO_TEXT,
      c_description         TYPE string VALUE 'Check long documentation for classes/interfaces and their members' ##NO_TEXT,
      c_version             TYPE char03 VALUE '001' ##NO_TEXT,
      c_exclude_list_prefix TYPE string VALUE 'SCI_LDE:',
      c_error_text_part     TYPE string VALUE 'Long documentation missing:' ##NO_TEXT.

    DATA:
      m_missing_long_doc_error_type TYPE sci_errty VALUE 'N' ##NO_TEXT,
      m_missing_member_error_type   TYPE sci_errty VALUE 'N' ##NO_TEXT,
      m_error_counter               TYPE sci_errcnt,
      m_object_info                 TYPE REF TO lcl_object_info,
      m_excluded_names              TYPE STANDARD TABLE OF string.

    METHODS:
      check_object,
      check_member IMPORTING member_document TYPE ty_member_document
                             error_code      TYPE sci_errc,
      check_main_documentation,
      check_attributes,
      check_methods,
      check_events,
      has_long_documentation IMPORTING document_id                   TYPE doku_id
                                       object_name                   TYPE dokhl-object
                             RETURNING VALUE(has_long_documentation) TYPE abap_bool,
      create_exclude_list.
ENDCLASS.

CLASS zcl_sci_longdoc_check IMPLEMENTATION.
  METHOD check_attributes.
    DATA: attributes      TYPE seo_attributes,
          attribute       LIKE LINE OF attributes,
          member_document TYPE ty_member_document.

    attributes = m_object_info->get_attributes( ).

    LOOP AT attributes INTO attribute.
      CONCATENATE attribute-clsname attribute-cmpname INTO member_document-document_object_name RESPECTING BLANKS.
      member_document-document_id = m_object_info->m_document_id-attribute.
      member_document-member_name = attribute-cmpname.

      check_member(
        member_document = member_document
        error_code = c_error_codes-no_attribute_documentation
      ).
    ENDLOOP.
  ENDMETHOD.

  METHOD check_events.
    DATA: events          TYPE seo_events,
          event           LIKE LINE OF events,
          member_document TYPE ty_member_document.

    events = m_object_info->get_events(  ).

    LOOP AT events INTO event.
      CONCATENATE event-clsname event-cmpname INTO member_document-document_object_name RESPECTING BLANKS.
      member_document-member_name = event-cmpname.
      member_document-document_id = m_object_info->m_document_id-event.

      check_member(
        member_document = member_document
        error_code = c_error_codes-no_event_documentation
      ).
    ENDLOOP.
  ENDMETHOD.

  METHOD check_main_documentation.
    DATA: has_class_documentation TYPE abap_bool,
          document_object_name    TYPE dokhl-object.

    document_object_name = m_object_info->m_object_name.

    has_class_documentation = has_long_documentation(
      document_id = m_object_info->m_document_id-object
      object_name = document_object_name
    ).

    IF has_class_documentation = abap_false.
      m_error_counter = m_error_counter + 1.

      inform(
        EXPORTING
          p_sub_obj_type = m_object_info->m_object_type
          p_sub_obj_name = m_object_info->m_object_name
          p_errcnt = m_error_counter
          p_kind = m_missing_long_doc_error_type
          p_test = c_class_name
          p_code = c_error_codes-no_main_documentation
          p_param_1 = m_object_info->m_object_name
      ).
    ENDIF.
  ENDMETHOD.

  METHOD check_member.
    DATA: has_documentation TYPE abap_bool.

    READ TABLE m_excluded_names WITH TABLE KEY table_line = member_document-member_name TRANSPORTING NO FIELDS.

    IF sy-subrc = 0.
      RETURN.
    ENDIF.

    has_documentation = has_long_documentation(
      document_id = member_document-document_id
      object_name = member_document-document_object_name
    ).

    IF has_documentation = abap_false.
      m_error_counter = m_error_counter + 1.

      inform(
       EXPORTING
         p_sub_obj_type = object_type
         p_sub_obj_name = object_name
         p_errcnt = m_error_counter
         p_kind = m_missing_member_error_type
         p_test = c_class_name
         p_code = error_code
         p_param_1 = member_document-member_name
      ).
    ENDIF.
  ENDMETHOD.

  METHOD check_methods.
    DATA: methods         TYPE seo_methods,
          method          LIKE LINE OF methods,
          member_document TYPE ty_member_document.

    methods = m_object_info->get_methods( ).

    LOOP AT methods INTO method.
      CONCATENATE method-clsname method-cmpname INTO member_document-document_object_name RESPECTING BLANKS.
      member_document-member_name = method-cmpname.
      member_document-document_id = m_object_info->m_document_id-method.

      check_member(
        member_document = member_document
        error_code = c_error_codes-no_method_documentation
      ).
    ENDLOOP.
  ENDMETHOD.

  METHOD check_object.
    check_main_documentation( ).
    check_attributes( ).
    check_methods( ).
    check_events( ).
  ENDMETHOD.

  METHOD constructor.
    super->constructor( ).

    description = c_description.
    category = c_category.
    version = c_version.
    has_attributes = abap_true.
    attributes_ok  = abap_false.

    add_obj_type( 'CLAS' ).
    add_obj_type( 'INTF' ).

    CREATE OBJECT m_object_info.
  ENDMETHOD.

  METHOD get_message_text.
    CASE p_code.
      WHEN c_error_codes-no_main_documentation.
        p_text = |{ c_error_text_part } { '&1' }|.
      WHEN c_error_codes-no_attribute_documentation.
        p_text = |{ c_error_text_part } attribute { '&1' }|.
      WHEN c_error_codes-no_method_documentation.
        p_text = |{ c_error_text_part } method { '&1' }|.
      WHEN c_error_codes-no_event_documentation.
        p_text = |{ c_error_text_part } event { '&1' }|.
      WHEN OTHERS.
        super->get_message_text(
          EXPORTING
            p_test = p_test
            p_code = p_code
          IMPORTING p_text = p_text
        ).
    ENDCASE.
  ENDMETHOD.

  METHOD query_attributes.
    DATA: cancelled  TYPE abap_bool,
          attributes TYPE sci_atttab,
          attribute  LIKE LINE OF attributes.

    GET REFERENCE OF m_missing_long_doc_error_type INTO attribute-ref.
    attribute-kind = ''.
    attribute-text = 'Missing docs for object/intf' ##NO_TEXT.
    APPEND attribute TO attributes.

    GET REFERENCE OF m_missing_member_error_type INTO attribute-ref.
    attribute-kind = ''.
    attribute-text = 'Missing docs for members' ##NO_TEXT.
    APPEND attribute TO attributes.

    cancelled = cl_ci_query_attributes=>generic(
      p_name = c_class_name
      p_title = 'Options'   ##NO_TEXT
      p_attributes = attributes
      p_display = p_display
    ).

    IF cancelled = abap_true.
      RETURN.
    ENDIF.

    IF m_missing_long_doc_error_type = c_error
      OR m_missing_long_doc_error_type = c_warning
      OR m_missing_long_doc_error_type = c_note
      OR m_missing_long_doc_error_type = 'O'.

      attributes_ok = abap_true.
    ELSE.
      attributes_ok = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD put_attributes.
    IMPORT
      sci_long_doc_error_type = m_missing_long_doc_error_type
      sci_member_doc_error_type = m_missing_member_error_type
      FROM DATA BUFFER p_attributes.
  ENDMETHOD.

  METHOD get_attributes.
    EXPORT
      sci_long_doc_error_type = m_missing_long_doc_error_type
      sci_member_doc_error_type = m_missing_member_error_type
      TO DATA BUFFER p_attributes.
  ENDMETHOD.

  METHOD run.
    IF object_type <> 'CLAS'
      AND object_type <> 'INTF'.

      RETURN.
    ENDIF.

    IF ref_scan IS INITIAL.
      IF get( ) <> abap_true OR ref_scan->subrc <> 0.
        RETURN.
      ENDIF.
    ENDIF.

    m_object_info->set_object(
      object_name = object_name
      object_type = object_type
    ).

    create_exclude_list(  ).
    check_object( ).
  ENDMETHOD.

  METHOD has_long_documentation.
    DATA: documentation_header TYPE thead,
          documentation        TYPE STANDARD TABLE OF tline.

    CALL FUNCTION 'DOCU_GET'
      EXPORTING
        id                = document_id
        langu             = sy-langu
        object            = object_name
      IMPORTING
        head              = documentation_header
      TABLES
        line              = documentation
      EXCEPTIONS
        no_docu_on_screen = 1
        no_docu_self_def  = 2
        no_docu_temp      = 3
        ret_code          = 4
        OTHERS            = 5.

    IF documentation_header IS INITIAL
      OR sy-subrc <> 0.

      has_long_documentation = abap_false.
    ELSE.
      has_long_documentation = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD create_exclude_list.
    DATA: excluded_name TYPE string.

    IF ref_scan IS INITIAL.
      RETURN.
    ENDIF.

    LOOP AT ref_scan->tokens INTO DATA(token)
      WHERE type = scan_token_type-comment
      AND str CS c_exclude_list_prefix.

      FIND REGEX 'SCI_LDE:[\s]*([\w]+)' IN token-str
        IGNORING CASE
        SUBMATCHES excluded_name.

      IF excluded_name IS NOT INITIAL.
        excluded_name = to_upper( excluded_name ).
        APPEND excluded_name TO m_excluded_names.
        CLEAR excluded_name.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
