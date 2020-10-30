CLASS yrap_class_datagen_ap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS yrap_class_datagen_ap IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    DELETE FROM yrap_atravel_ap.
    DELETE FROM yrap_abooking_ap.
    INSERT yrap_atravel_ap FROM (
        SELECT
        FROM /dmo/travel
        FIELDS
        uuid( ) AS travel_uuid,
        travel_id,
        agency_id,
        customer_id,
        begin_date,
        end_date,
        booking_fee,
        total_price,
        currency_code,
        description,
        CASE status
         WHEN 'B' THEN 'A' "accepted
         WHEN 'X' THEN 'X' "cancelled
         ELSE 'O'          "open
        END AS overall_status,
        createdby AS created_by,
        createdat AS created_at,
        lastchangedby AS last_changed_by
        ORDER BY travel_id UP TO 200 ROWS
    ).
    COMMIT WORK.

    INSERT yrap_abooking_ap FROM (
    SELECT FROM /dmo/booking AS booking
    JOIN yrap_atravel_ap AS travel
    ON booking~travel_id = travel~travel_id
    FIELDS
    uuid( ) AS booking_id,
    travel_uuid,
    booking_id,
    booking_date,
    booking~customer_id,
    carrier_id,
    connection_id,
    flight_date,
    flight_price,
    booking~currency_code,
    created_by,
    last_changed_by,
    last_changed_at
     ).
    COMMIT WORK.

    out->write( |Travel and booking data inserted.| ).
  ENDMETHOD.

ENDCLASS.
