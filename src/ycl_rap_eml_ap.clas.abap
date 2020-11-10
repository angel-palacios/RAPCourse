CLASS ycl_rap_eml_ap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ycl_rap_eml_ap IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
* Step 1 - READ
*    READ ENTITIES OF yi_rap_travel_ap
*    ENTITY Travel
*        FROM VALUE #( ( TravelUUID = '23BA12305CB6B44917000C0214639CF0' ) )
*     RESULT DATA(travels).
*
*    out->write( travels ).
** Step 2 - READ with fields
*    READ ENTITIES OF yi_rap_travel_ap
*    ENTITY Travel
*    FIELDS ( AgencyID CustomerID )
*        WITH VALUE #( ( TravelUUID = '23BA12305CB6B44917000C0214639CF0' ) )
*     RESULT DATA(travels).
*
*    out->write( travels ).
** Step 3 - READ all fields
*    READ ENTITIES OF yi_rap_travel_ap
*    ENTITY Travel
*    ALL FIELDS  WITH VALUE #( ( TravelUUID = '23BA12305CB6B44917000C0214639CF0' ) )
*     RESULT DATA(travels).
*
*    out->write( travels ).
** Step 4 - READ by association
*    READ ENTITIES OF yi_rap_travel_ap
*    ENTITY travel BY \_Booking
*    ALL FIELDS WITH VALUE #( ( TravelUUID = '23BA12305CB6B44917000C0214639CF0' ) )
*      RESULT DATA(bookings)
*      FAILED DATA(failed)
*      REPORTED DATA(reported).
*
*    out->write( bookings ).
*    out->write( failed ).
*    out->write( reported ).
** Step 5 - MODIFY update
*    MODIFY ENTITIES OF yi_rap_travel_ap
*    ENTITY travel
*    UPDATE
*    SET FIELDS WITH VALUE #(
*     (  TravelUUID = '23BA12305CB6B44917000C0214639CF0'
*        Description = 'RAP@OpenSAP' )
*     )
*     FAILED DATA(failed)
*     REPORTED DATA(reported).
*
*    COMMIT ENTITIES
*        RESPONSE OF yi_rap_travel_ap
*        FAILED DATA(failed_commit)
*        REPORTED DATA(reported_commit).
*
*    out->write( 'Update complete' ).
** Step 6 - MODIFY create
*    MODIFY ENTITIES OF yi_rap_travel_ap
*    ENTITY travel
*    CREATE
*    SET FIELDS WITH VALUE #(
*     (  %cid = 'MyContentID_1'
*        AgencyID = '70012'
*        CustomerID = '14'
*        BeginDate = cl_abap_context_info=>get_system_date( )
*        EndDate = cl_abap_context_info=>get_system_date( ) + 10
*        Description = 'RAP@OpenSAP' )
*     )
*     MAPPED DATA(mapped)
*     FAILED DATA(failed)
*     REPORTED DATA(reported).
*
*    out->write( mapped-travel ).
*
*    COMMIT ENTITIES
*        RESPONSE OF yi_rap_travel_ap
*        FAILED DATA(failed_commit)
*        REPORTED DATA(reported_commit).
*
*    out->write( 'Create complete' ).
* Step 6 - MODIFY delete
    MODIFY ENTITIES OF yi_rap_travel_ap
    ENTITY travel
    DELETE FROM VALUE #(
        ( TravelUUID = '123E4D666C4B1EEB87C5D32D9E2C4047' )
     )
     FAILED DATA(failed)
     REPORTED DATA(reported).

    COMMIT ENTITIES
        RESPONSE OF yi_rap_travel_ap
        FAILED DATA(failed_commit)
        REPORTED DATA(reported_commit).

    out->write( 'Delete complete' ).
  ENDMETHOD.
ENDCLASS.
