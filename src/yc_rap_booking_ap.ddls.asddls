@EndUserText.label: 'Projection  View for Booking'
@AccessControl.authorizationCheck: #CHECK
@Search.searchable: true
@Metadata.allowExtensions: true

define view entity YC_RAP_BOOKING_AP
  as projection on YI_RAP_BOOKING_AP as Booking
{
      //YI_RAP_BOOKING_AP
  key BookingUUID,
      TravelUUID,
      @Search.defaultSearchElement: true
      BookingID,
      BookingDate,
      @Consumption.valueHelpDefinition: [{ entity : { name: '/DMO/I_Customer' , element: 'CustomerID' } }]
      @ObjectModel.text.element: ['CustomerName']
      @Search.defaultSearchElement: true
      CustomerID,
      _Customer.LastName as CustomerName,
      @Consumption.valueHelpDefinition: [{ entity : { name: '/DMO/I_Carrier' , element: 'AirlineID' } }]
      @ObjectModel.text.element: ['CarrierName']
      CarrierID,
      _Carrier.Name      as CarrierName,
      @Consumption.valueHelpDefinition: [{entity : { name: '/DMO/I_Connection' , element: 'ConnectionID'},
                                          additionalBinding: [{ localElement: 'CarrierID', element: 'AirlineID'},
                                                              { localElement: 'FlightDate', element: 'FlightDate', usage: #RESULT},
                                                              { localElement: 'FlightPrice', element: 'Price', usage: #RESULT},
                                                              { localElement: 'CurrencyCode', element: 'CurrencyCode', usage: #RESULT}]}]
      ConnectionID,
      FlightDate,
      @Semantics.amount.currencyCode: 'CurrencyCode'
      FlightPrice,
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Currency' , element: 'Currency'} }]
      CurrencyCode,
      CreatedBy,
      LastChangedBy,
      LocalLastChangedAt,
      /* Associations */
      //YI_RAP_BOOKING_AP
      _Carrier,
      _Connection,
      _Currency,
      _Customer,
      _Flight,
      _Travel : redirected to parent YC_RAP_TRAVEL_AP
}
