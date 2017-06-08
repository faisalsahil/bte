class Area < ApplicationRecord
  has_many :branches
  belongs_to :state
  belongs_to :city

  validates_uniqueness_of :name, :scope => :city_id
  validates_presence_of   :name


  def sorted_branches
    @branches = Branch.joins('LEFT OUTER JOIN "route_branches" ON "route_branches"."branch_id" = "branches"."id"')
                    .where('area_id = ? AND branches.branch_status = ?', self.id, AppConstants::CONTRACTED)
                    .group('branches.id')
                    # .order(order_options)
                    # .select('branches.visits_per_month as remaining_visits')

  end

  def order_options
    [
    "COALESCE(branches.visits_per_month - COUNT(CASE " \
    "WHEN (route_branches.transfer_to IS NULL AND route_branches.is_deleted != 't' AND extract(month from route_branches.created_at) = #{Date.today.month}) " \
    "THEN " \
      "route_branches.branch_id " \
    "ELSE " \
      "0 " \
    "END), 0) desc",
    ]

    # [
    #     'COALESCE(SUM(CASE ' \
    # 'WHEN (COUNT(route_branches.branch_id) - COUNT(route_branches.branch_id) > 0) ' \
    # 'THEN ' \
    #   'branches.visits_per_month - COUNT(route_branches.branch_id) ' \
    # 'ELSE ' \
    #   '0 ' \
    # 'END), 0) desc',
    # ]
  end
end
