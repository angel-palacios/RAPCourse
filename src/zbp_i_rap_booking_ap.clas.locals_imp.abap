CLASS lhc_Booking DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS calculateBookingID FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateBookingID.

    METHODS calculateTotalPrice FOR DETERMINE ON MODIFY
      IMPORTING keys FOR Booking~calculateTotalPrice.

ENDCLASS.

CLASS lhc_Booking IMPLEMENTATION.

  METHOD calculateBookingID.
    DATA max_booking_id TYPE /dmo/booking-booking_id.
    DATA update TYPE TABLE FOR UPDATE yi_rap_travel_ap\\Booking.
    "Read all travels for the requested bookings.
    "If multiple bookings of the same travel are requested, the travel is returned only once.
    READ ENTITIES OF yi_rap_travel_ap IN LOCAL MODE
    ENTITY Booking BY \_Travel
    FIELDS ( TravelUUID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(travels).
    "Process all affected travels. Read respective bookings, determine the max id and update bookings w/o ID
    LOOP AT travels INTO DATA(travel).
      READ ENTITIES OF yi_rap_travel_ap IN LOCAL MODE
      ENTITY Travel BY \_Booking
      FIELDS ( BookingID )
      WITH VALUE #( ( %tky = travel-%tky ) )
      RESULT DATA(bookings).
      "Find max booking id used in this travel
      SORT bookings BY bookingID DESCENDING.
      READ TABLE bookings INTO DATA(booking) INDEX 1.
      max_booking_id = booking-BookingID.
      "Provide a BookingID for all bookings w/o one.
      LOOP AT bookings INTO booking WHERE BookingID IS INITIAL.
        max_booking_id += 10.
        APPEND VALUE #( %tky = booking-%tky
                        BookingID = max_booking_id )
        TO update.
      ENDLOOP.
    ENDLOOP.

    "Update the BookingID of all relevant bookings
    MODIFY ENTITIES OF yi_rap_travel_ap IN LOCAL MODE
    ENTITY Booking
    UPDATE FIELDS ( BookingID ) WITH update
    REPORTED DATA(update_reported).

    reported = CORRESPONDING #( DEEP update_reported ).

  ENDMETHOD.

  METHOD calculateTotalPrice.
    "Read all travels for the requested bookings
    "If multiple bookings of the same travel are requested, the travel is returned only once.
    READ ENTITIES OF yi_rap_travel_ap IN LOCAL MODE
    ENTITY Booking BY \_Travel
    FIELDS ( TravelUUID )
    WITH CORRESPONDING #( keys )
    RESULT DATA(travels)
    FAILED DATA(read_failed).
    "Trigger calculation of total price
    MODIFY ENTITIES OF yi_rap_travel_ap IN LOCAL MODE
    ENTITY Travel
    EXECUTE recalcTotalPrice
    FROM CORRESPONDING #( travels )
    REPORTED DATA(execute_reported).

    reported = CORRESPONDING #( DEEP execute_reported ).

  ENDMETHOD.

ENDCLASS.
