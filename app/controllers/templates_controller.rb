class TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :edit, :update, :destroy]

  def index
    @templates = Template.all
  end

  def show
  end

  def new
    @template = Template.new
  end

  def edit
  end

  def create
    @template = Template.new(template_params)

    respond_to do |format|
      if @template.save
        format.html { redirect_to @template, notice: 'Template was successfully created.' }
        format.json { render :show, status: :created, location: @template }
      else
        format.html { render :new }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @template.update(template_params)
        format.html { redirect_to @template, notice: 'Template was successfully updated.' }
        format.json { render :show, status: :ok, location: @template }
      else
        format.html { render :edit }
        format.json { render json: @template.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @template.destroy
    respond_to do |format|
      format.html { redirect_to templates_url, notice: 'Template was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def send_mail
    @template = Template.find_by_id(params[:id])
    @branches = Branch.all
  end

  def send_mail_confirm
    # Make history
    template      = Template.find_by_id(params[:id])
    email_history = template.email_histories.build
    email_history.html       = template.html
    email_history.subject    = template.subject
    email_history.from_email = template.from_email
    email_history.cc         = template.cc
    email_history.save!
  
    # Send mail
    params[:multiselect] && params[:multiselect].each do |branch_id|
      ClientMailer.delay.send_email(branch_id, params[:id])
      client_history = email_history.history_clients.build
      client_history.branch_id = branch_id
      client_history.count = 1
      client_history.save!
    end
  
    flash[:success] = 'Send mail in process.'
    redirect_to templates_path
  end

  private
    def set_template
      @template = Template.find(params[:id])
    end

    def template_params
      params.require(:template).permit(:html, :subject, :from_email, :cc, :is_deleted)
    end
end
