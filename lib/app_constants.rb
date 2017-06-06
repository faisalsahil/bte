module AppConstants
  DRIVER = 'driver'
  HELPER = 'helper'
  ACTIVE = 'active'
  FACTORY = 'factory'
  SALER   = 'saler'
  COMPLETED = 'completed'
  
  VISIT = 'visit'
  LEAD  = 'lead'
  CONTRACTED = 'contracted'
  ACTIVE = 'active'
  COMPLETED = 'completed'
  
  Lead_REPORT   = 'lead_report'
  VISIT_REPORT = 'visit_report'
  CONTRACTED_REPORT = 'contracted_report'
  ACTIVE_ROUTES_REPORT = 'active_routes_report'
  NO_WASTE_OIL_REPORT  = 'no_waste_oil_report'
  COLLECTED_OIL_TO_DATE_REPORT = 'collected_oil_to_date_report'
  MONTH_WISE_COLLECTION_REPORT = 'month_wise_collection_report'
  RESTAURANT_WISE_COLLECTION_REPORT = 'restaurant_wise_collection_report'
  NOT_VISITED_REPORT = 'not_visited_report'
  
  REPORTS   = [
      {name: 'Lead report', id: Lead_REPORT},
      {name: 'Visit report', id: VISIT_REPORT},
      {name: 'Contracted report', id: CONTRACTED_REPORT},
      {name: 'Active routes report', id: ACTIVE_ROUTES_REPORT},
      {name: 'No Waste oil report', id: NO_WASTE_OIL_REPORT},
      {name: 'Collected oil to date report', id: COLLECTED_OIL_TO_DATE_REPORT},
      {name: 'Month wise collection report', id: MONTH_WISE_COLLECTION_REPORT},
      {name: 'Restaurant wise collection report', id: RESTAURANT_WISE_COLLECTION_REPORT},
      {name: 'Not visited report', id: NOT_VISITED_REPORT}
  ]

  LEAD_REPORT_HEADER = [
      {name: 'Area', id: 'area_id'},
      {name: 'Sale representative', id: 'representative'},
      {name: 'Branch name', id: 'branch_name'},
      {name: 'Code', id: 'branch_code'},
      {name: 'Contact name', id: 'contact_name'},
      {name: 'Contact #', id: 'contact_phone'},
      {name: 'Oil used', id: 'monthly_oil_used'},
      {name: 'Rate/Kg', id: 'rate_per_kg'},
      {name: 'Visits/month', id: 'visits_per_month'},
      {name: 'Collection', id: 'total_collection'},
      {name: 'Address', id: 'address'}
  ]
  
end