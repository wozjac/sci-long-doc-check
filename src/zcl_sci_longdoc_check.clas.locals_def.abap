CLASS lcl_object_info DEFINITION.
  PUBLIC SECTION.
    DATA:
      m_object_type TYPE trobjtype READ-ONLY,
      m_object_name TYPE sobj_name READ-ONLY,

      BEGIN OF m_document_id READ-ONLY,
        object    TYPE doku_id,
        attribute TYPE doku_id,
        event     TYPE doku_id,
        method    TYPE doku_id,
      END OF m_document_id.
    METHODS:
      set_object
        IMPORTING object_name TYPE sobj_name
                  object_type TYPE trobjtype,
      get_attributes
        IMPORTING non_private       TYPE abap_bool DEFAULT abap_true
        RETURNING VALUE(attributes) TYPE seo_attributes,
      get_methods
        IMPORTING non_private    TYPE abap_bool DEFAULT abap_true
        RETURNING VALUE(methods) TYPE seo_methods,
      get_events
        IMPORTING non_private   TYPE abap_bool DEFAULT abap_true
        RETURNING VALUE(events) TYPE seo_events.
  PROTECTED SECTION.
    METHODS:
      get_object_metadata
        IMPORTING name                   TYPE seoclsname
                  type                   TYPE trobjtype
        RETURNING VALUE(object_metadata) TYPE REF TO cl_oo_object.
  PRIVATE SECTION.
    DATA:
      m_object_metadata TYPE REF TO cl_oo_object.
ENDCLASS.
