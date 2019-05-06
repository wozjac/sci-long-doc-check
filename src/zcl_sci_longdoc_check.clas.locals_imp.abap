CLASS lcl_object_info IMPLEMENTATION.
  METHOD set_object.
    DATA: class_name TYPE seoclsname.

    class_name = object_name.

    CASE object_type.
      WHEN 'CLAS'.
        m_object_metadata = get_object_metadata( name = class_name type = object_type ).
        m_document_id-attribute = 'CA'.
        m_document_id-event = 'CE'.
        m_document_id-method = 'CO'.
        m_document_id-object = 'CL'.
      WHEN 'INTF'.
        m_object_metadata = get_object_metadata( name = class_name type = object_type ).
        m_document_id-attribute = 'IA'.
        m_document_id-event = 'IE'.
        m_document_id-method = 'IO'.
        m_document_id-object = 'IF'.
    ENDCASE.

    m_object_type = object_type.
    m_object_name = object_name.
  ENDMETHOD.

  METHOD get_object_metadata.
    TRY.
        CASE type.
          WHEN 'CLAS'.
            object_metadata = cl_oo_interface=>get_instance( name ).
          WHEN 'INTF'.
            object_metadata = cl_oo_object=>get_instance( name ).
        ENDCASE.
      CATCH cx_class_not_existent.
        RAISE EXCEPTION TYPE cx_sy_create_object_error.
    ENDTRY.
  ENDMETHOD.

  METHOD get_attributes.
    attributes = m_object_metadata->get_attributes( ).

    IF non_private = abap_true.
      DELETE attributes WHERE exposure = 0.
    ENDIF.
  ENDMETHOD.

  METHOD get_events.
    events = m_object_metadata->get_events( ).

    IF non_private = abap_true.
      DELETE events WHERE exposure = 0.
    ENDIF.
  ENDMETHOD.

  METHOD get_methods.
    methods = m_object_metadata->get_methods( ).

    IF non_private = abap_true.
      DELETE methods WHERE exposure = 0.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
