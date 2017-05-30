class EmailHistoriesController < ApplicationController
  # before_action :check_authorize_user
  
  def index
    @template        = Template.find_by_id(params[:id])
    @email_histories = @template.email_histories.order('created_at DESC')
  end
  
  def show
    respond_to do |format|
      @email_history   = EmailHistory.find_by_id(params[:id])
      @history_clients = @email_history.history_clients.count
      @branches        = Branch.count
      format.html
      format.js { render layout: false }
    end
  end
  
  def send_email
    @email_history       = EmailHistory.find_by_id(params[:id])
    @history_branch_ids  = @email_history.history_clients.pluck(:branch_id)
    @branches             = Branch.where.not(id: @history_branch_ids)
    @history_branches     = Branch.where(id: @history_branch_ids)
  end
  
  def send_mail_confirm
    # Send to new clients
    email_history  = EmailHistory.find_by_id(params[:id])
    params[:multiselect] && params[:multiselect].each do |branch_id|
      ClientMailer.delay.send_email_from_history(branch_id, email_history.id)
      client_history = email_history.history_clients.build
      client_history.branch_id = branch_id
      client_history.count     = 1
      client_history.save!
    end
    
    # Send again to clients
    params[:history_clients] && params[:history_clients].each do |branch_id|
      ClientMailer.delay.send_email_from_history(branch_id, email_history.id)
      client_history = email_history.history_clients.where(branch_id: branch_id).first
      client_history.count = client_history.count + 1
      client_history.save!
    end
    flash[:success] = 'Send mail in process.'
    redirect_to email_histories_path(email_history.template, email_history)
  end
end
