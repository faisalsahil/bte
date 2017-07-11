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
  FACTORY_COLLECTION_REPORT = 'factory_collection_report'
  URGENT_ACTION_REPORT      = 'urgent_action_report'
  
  REPORTS   = [
      {name: 'Lead report', id: Lead_REPORT},
      {name: 'Visit report', id: VISIT_REPORT},
      {name: 'Contracted report', id: CONTRACTED_REPORT},
      {name: 'Active routes report', id: ACTIVE_ROUTES_REPORT},
      {name: 'No Waste oil report', id: NO_WASTE_OIL_REPORT},
      # {name: 'Collected oil to date report', id: COLLECTED_OIL_TO_DATE_REPORT},
      {name: 'Month wise collection report', id: MONTH_WISE_COLLECTION_REPORT},
      {name: 'Restaurant wise collection report', id: RESTAURANT_WISE_COLLECTION_REPORT},
      {name: 'Not visited report', id: NOT_VISITED_REPORT},
      {name: 'Factory collection report', id: FACTORY_COLLECTION_REPORT},
      {name: 'Urgent action report', id: URGENT_ACTION_REPORT}
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
  
  FACTORY_REPORT_HEADER = [
      {name: 'ID', id: 'factory_collection_id'},
      {name: 'Voucher#', id: 'voucher'},
      {name: 'Branch name', id: 'branch_name'},
      {name: 'Branch code', id: 'branch_code'},
      {name: 'Quantity', id: 'quantity'},
      {name: 'Driver', id: 'driver'},
      {name: 'Helper', id: 'helper'},
      {name: 'Vehicle#', id: 'vehicle'},
      {name: 'Comment', id: 'comment'}
  ]

  ACTIVE_ROUTE_REPORT_HEADER = [
      {name: 'Voucher#', id: 'voucher'},
      {name: 'Branch name', id: 'branch_name'},
      {name: 'Branch code', id: 'branch_code'},
      {name: 'Quantity', id: 'quantity'},
      {name: 'Driver', id: 'driver'},
      {name: 'Helper', id: 'helper'},
      {name: 'Vehicle#', id: 'vehicle'},
      {name: 'Comment', id: 'comment'}
  ]

  NO_WASTE_OIL_REPORT_HEADER = [
      {name: 'Voucher#', id: 'voucher'},
      {name: 'Date', id: 'date'},
      {name: 'Branch name', id: 'branch_name'},
      {name: 'Branch code', id: 'branch_code'},
      {name: 'Quantity', id: 'quantity'},
      {name: 'Driver', id: 'driver'},
      {name: 'Helper', id: 'helper'},
      {name: 'Vehicle#', id: 'vehicle'},
      {name: 'Comment', id: 'comment'}
  ]
  
  MONTH_WISE_COLLECCTION_REPORT_HEADER = [
      {name: 'Area', id: 'area_id'},
      {name: 'Sale representative', id: 'representative'},
      {name: 'Branch name', id: 'branch_name'},
      {name: 'Code', id: 'branch_code'},
      {name: 'Contact name', id: 'contact_name'},
      {name: 'Contact #', id: 'contact_phone'},
      {name: 'Collection', id: 'total_collection'},
      {name: 'Rate/Kg', id: 'rate_per_kg'},
      {name: 'Address', id: 'address'}
  ]
  
  URGENT_ACTION_REPORT_HEADER = [
      {name: 'date', id: 'date'},
      {name: 'Branch name', id: 'branch_name'},
      {name: 'Code', id: 'branch_code'},
      {name: 'Contact #', id: 'contact_phone'},
      {name: 'Address', id: 'address'},
      {name: 'Comment', id: 'comment'},
      {name: 'Completed Notes', id: 'completed_notes'}
  ]
  GLOBAL_ARRAY   = ["Super admin", "admin"]
  STORAGE_ARRAY  = ["Super admin", "admin"]
  FOODTYPE_ARRAY = ["Super admin", "admin"]
  COMPANY_ARRAY  = ["Super admin", "admin"]
  STATE_ARRAY    = ["Super admin", "admin"]
  CITY_ARRAY     = ["Super admin", "admin"]
  AREA_ARRAY     = ["Super admin", "admin"]
  VEHICLE_ARRAY  = ["Super admin", "admin"]
  ROLE_ARRAY     = ["Super admin", "admin"]
  BILLING_ARRAY  = ["Super admin", "admin"]
  USER_ARRAY     = ["Super admin", "admin"]
  
  BRANCH_ARRAY     = ["Super admin", "admin", "accout-1", "account-2"]
  ROUTES_ARRAY     = ["Super admin", "admin", "accout-1", "account-2"]
  ASSIGNMENT_ARRAY = ["Super admin", "admin", "accout-1", "account-2"]
  FACTORY_ASSIGNMENT_ARRAY = ["Super admin", "admin", "factory"]
  REPORT_ARRAY     = ["Super admin", "admin", "accout-1", "account-2"]
  FACTORY_ARRAY    = ["Super admin", "admin", "factory"]
end